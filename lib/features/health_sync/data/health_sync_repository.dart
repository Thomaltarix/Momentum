import 'package:drift/drift.dart';

import '../../../core/db/app_database.dart';
import '../domain/daily_goals.dart';
import '../domain/daily_nutrition.dart';
import '../domain/daily_steps.dart';
import '../domain/data_source_mode.dart';
import '../domain/health_snapshot.dart';
import '../domain/macro_calculator_input.dart';
import '../domain/weight_entry.dart';
import '../domain/workout_category.dart';
import '../domain/workout_entry.dart';
import 'health_connect_client.dart';

class HealthSyncRepository {
  HealthSyncRepository(this._db, this._client);

  final AppDatabase _db;
  final HealthConnectClient _client;

  Stream<HealthSnapshot?> watchToday() {
    final DateTime today = _normalizeDate(DateTime.now());
    return (_db.select(
      _db.healthSnapshots,
    )..where((t) => t.date.equals(today))).watchSingleOrNull().map(
      (row) => row == null ? null : _toDomain(row),
    );
  }

  Future<HealthSnapshot?> fetchSnapshot(DateTime date) async {
    final DateTime normalized = _normalizeDate(date);
    final row = await (_db.select(
      _db.healthSnapshots,
    )..where((t) => t.date.equals(normalized))).getSingleOrNull();
    return row == null ? null : _toDomain(row);
  }

  Future<bool> hasPermissions() => _client.hasPermissions();

  Future<bool> requestPermissions() => _client.requestPermissions();

  Future<bool> isHealthConnectAvailable() =>
      _client.isHealthConnectAvailable();

  Future<List<DailySteps>> fetchStepsHistory(int days) =>
      _client.fetchStepsHistory(days);

  Future<List<WorkoutEntry>> fetchWorkoutsHistory(int days) async {
    final mode = await fetchWorkoutSourceMode();
    return mode == DataSourceMode.manual
        ? _fetchManualWorkoutsHistory(days)
        : _client.fetchWorkoutsHistory(days);
  }

  Future<List<DailyNutrition>> fetchNutritionHistory(int days) async {
    final mode = await fetchNutritionSourceMode();
    return mode == DataSourceMode.manual
        ? _fetchManualNutritionHistory(days)
        : _client.fetchNutritionHistory(days);
  }

  Future<List<WeightEntry>> fetchWeightHistory(int days) async {
    final mode = await fetchWeightSourceMode();
    return mode == DataSourceMode.manual
        ? _fetchManualWeightHistory(days)
        : _client.fetchWeightHistory(days);
  }

  // --- Data source mode (per metric: Health Connect or manual entry) ---

  Future<DataSourceMode> fetchWeightSourceMode() =>
      _fetchMode((row) => row.weightSource);

  Future<DataSourceMode> fetchWorkoutSourceMode() =>
      _fetchMode((row) => row.workoutSource);

  Future<DataSourceMode> fetchNutritionSourceMode() =>
      _fetchMode((row) => row.nutritionSource);

  Future<void> setWeightSourceMode(DataSourceMode mode) => _setMode(
    DataSourceSettingsCompanion(
      id: const Value(0),
      weightSource: Value(mode.name),
    ),
  );

  Future<void> setWorkoutSourceMode(DataSourceMode mode) => _setMode(
    DataSourceSettingsCompanion(
      id: const Value(0),
      workoutSource: Value(mode.name),
    ),
  );

  Future<void> setNutritionSourceMode(DataSourceMode mode) => _setMode(
    DataSourceSettingsCompanion(
      id: const Value(0),
      nutritionSource: Value(mode.name),
    ),
  );

  Future<DataSourceMode> _fetchMode(
    String Function(DataSourceSettingRow) field,
  ) async {
    final row = await (_db.select(
      _db.dataSourceSettings,
    )..where((t) => t.id.equals(0))).getSingleOrNull();
    return row == null ? DataSourceMode.healthConnect : _parseMode(field(row));
  }

  Future<void> _setMode(DataSourceSettingsCompanion companion) =>
      _db.into(_db.dataSourceSettings).insertOnConflictUpdate(companion);

  DataSourceMode _parseMode(String raw) =>
      DataSourceMode.values.asNameMap()[raw] ?? DataSourceMode.healthConnect;

  // --- Manual weight entries ---

  Future<void> addManualWeightEntry({
    required DateTime date,
    required double kilograms,
  }) {
    return _db
        .into(_db.weightEntries)
        .insertOnConflictUpdate(
          WeightEntriesCompanion.insert(
            date: _normalizeDate(date),
            kilograms: kilograms,
          ),
        );
  }

  Future<void> deleteManualWeightEntry(DateTime date) {
    return (_db.delete(
      _db.weightEntries,
    )..where((t) => t.date.equals(_normalizeDate(date)))).go();
  }

  Future<List<WeightEntry>> _fetchManualWeightHistory(int days) async {
    final DateTime start = _normalizeDate(
      DateTime.now(),
    ).subtract(Duration(days: days - 1));
    final rows =
        await (_db.select(_db.weightEntries)
              ..where((t) => t.date.isBiggerOrEqualValue(start))
              ..orderBy([(t) => OrderingTerm.desc(t.date)]))
            .get();
    return rows
        .map((row) => WeightEntry(date: row.date, kilograms: row.kilograms))
        .toList();
  }

  // --- Manual nutrition entries ---

  Future<void> addManualNutritionEntry({
    required DateTime date,
    required int calories,
    double? proteinGrams,
    double? carbsGrams,
    double? fatGrams,
  }) async {
    await _db
        .into(_db.nutritionEntries)
        .insertOnConflictUpdate(
          NutritionEntriesCompanion.insert(
            date: _normalizeDate(date),
            calories: calories,
            proteinGrams: Value(proteinGrams),
            carbsGrams: Value(carbsGrams),
            fatGrams: Value(fatGrams),
          ),
        );
    await _refreshTodayIfNeeded(date);
  }

  Future<void> deleteManualNutritionEntry(DateTime date) async {
    await (_db.delete(
      _db.nutritionEntries,
    )..where((t) => t.date.equals(_normalizeDate(date)))).go();
    await _refreshTodayIfNeeded(date);
  }

  Future<List<DailyNutrition>> _fetchManualNutritionHistory(int days) async {
    final DateTime today = _normalizeDate(DateTime.now());
    final DateTime start = today.subtract(Duration(days: days - 1));
    final rows = await (_db.select(
      _db.nutritionEntries,
    )..where((t) => t.date.isBiggerOrEqualValue(start))).get();
    final Map<DateTime, NutritionEntryRow> byDate = {
      for (final row in rows) row.date: row,
    };

    return List.generate(days, (i) {
      final DateTime day = start.add(Duration(days: i));
      final row = byDate[day];
      if (row == null) return DailyNutrition(date: day);
      return DailyNutrition(
        date: day,
        calories: row.calories,
        proteinGrams: row.proteinGrams,
        carbsGrams: row.carbsGrams,
        fatGrams: row.fatGrams,
      );
    }).reversed.toList();
  }

  // --- Manual workout entries ---

  Future<void> addManualWorkoutEntry({
    required WorkoutCategory category,
    required DateTime start,
    required DateTime end,
    int? caloriesBurned,
  }) async {
    await _db
        .into(_db.workoutEntries)
        .insert(
          WorkoutEntriesCompanion.insert(
            category: category,
            start: start,
            end: end,
            caloriesBurned: Value(caloriesBurned),
          ),
        );
    await _refreshTodayIfNeeded(start);
  }

  Future<void> updateManualWorkoutEntry({
    required int id,
    required WorkoutCategory category,
    required DateTime start,
    required DateTime end,
    int? caloriesBurned,
  }) async {
    await (_db.update(_db.workoutEntries)..where((t) => t.id.equals(id)))
        .write(
          WorkoutEntriesCompanion(
            category: Value(category),
            start: Value(start),
            end: Value(end),
            caloriesBurned: Value(caloriesBurned),
          ),
        );
    await _refreshTodayIfNeeded(start);
  }

  Future<void> deleteManualWorkoutEntry(int id) async {
    await (_db.delete(
      _db.workoutEntries,
    )..where((t) => t.id.equals(id))).go();
    // The entry's date is unknown after delete without another query, and
    // the home card's workout count depends on all of today's sessions —
    // simplest correct fix is to always resync rather than track it.
    await refreshToday();
  }

  Future<List<WorkoutEntry>> _fetchManualWorkoutsHistory(int days) async {
    final DateTime start = _normalizeDate(
      DateTime.now(),
    ).subtract(Duration(days: days - 1));
    final rows =
        await (_db.select(_db.workoutEntries)
              ..where((t) => t.start.isBiggerOrEqualValue(start))
              ..orderBy([(t) => OrderingTerm.desc(t.start)]))
            .get();
    return rows
        .map(
          (row) => WorkoutEntry(
            id: row.id,
            category: row.category,
            label: row.category.label,
            start: row.start,
            end: row.end,
            caloriesBurned: row.caloriesBurned,
          ),
        )
        .toList();
  }

  // --- Daily goals ---

  Stream<DailyGoals> watchGoals() {
    return (_db.select(
      _db.goals,
    )..where((t) => t.id.equals(0))).watchSingleOrNull().map(
      (row) => row == null ? DailyGoals.defaults : _goalsToDomain(row),
    );
  }

  Future<DailyGoals> fetchGoals() async {
    final row = await (_db.select(
      _db.goals,
    )..where((t) => t.id.equals(0))).getSingleOrNull();
    return row == null ? DailyGoals.defaults : _goalsToDomain(row);
  }

  Future<void> updateGoals(DailyGoals goals) {
    return _db
        .into(_db.goals)
        .insertOnConflictUpdate(
          GoalsCompanion.insert(
            id: const Value(0),
            stepGoal: Value(goals.stepGoal),
            calorieGoal: Value(goals.calorieGoal),
            proteinGoal: Value(goals.proteinGoal),
            carbsGoal: Value(goals.carbsGoal),
            fatGoal: Value(goals.fatGoal),
          ),
        );
  }

  DailyGoals _goalsToDomain(GoalsRow row) => DailyGoals(
    stepGoal: row.stepGoal,
    calorieGoal: row.calorieGoal,
    proteinGoal: row.proteinGoal,
    carbsGoal: row.carbsGoal,
    fatGoal: row.fatGoal,
  );

  // --- Macro calculator profile (remembered inputs, excluding weight) ---

  Future<MacroCalculatorProfile> fetchCalculatorProfile() async {
    final row = await (_db.select(
      _db.macroCalculatorInputs,
    )..where((t) => t.id.equals(0))).getSingleOrNull();
    if (row == null) return MacroCalculatorProfile.defaults;

    return MacroCalculatorProfile(
      sex: Sex.values.asNameMap()[row.sex] ?? Sex.male,
      age: row.age,
      heightCm: row.heightCm,
      activityLevel:
          ActivityLevel.values.asNameMap()[row.activityLevel] ??
          ActivityLevel.moderate,
      objective:
          NutritionObjective.values.asNameMap()[row.objective] ??
          NutritionObjective.maintain,
    );
  }

  Future<void> updateCalculatorProfile(MacroCalculatorProfile profile) {
    return _db
        .into(_db.macroCalculatorInputs)
        .insertOnConflictUpdate(
          MacroCalculatorInputsCompanion.insert(
            id: const Value(0),
            sex: Value(profile.sex.name),
            age: Value(profile.age),
            heightCm: Value(profile.heightCm),
            activityLevel: Value(profile.activityLevel.name),
            objective: Value(profile.objective.name),
          ),
        );
  }

  /// Recomputes the cached "today" snapshot that the home summary card and
  /// gamification read. Health Connect provides the baseline; workouts and
  /// nutrition are overridden with today's manual entry when that metric's
  /// mode is `manual`, so the card reflects whichever source is active
  /// rather than always showing the Health Connect side.
  Future<void> refreshToday() async {
    final HealthSnapshot base = await _client.fetchToday();
    final DateTime today = _normalizeDate(DateTime.now());

    final workoutMode = await fetchWorkoutSourceMode();
    final bool useManualWorkouts = workoutMode == DataSourceMode.manual;
    final (int manualWorkoutCount, int? manualCaloriesBurned) =
        useManualWorkouts
        ? await _manualWorkoutsSummaryOn(today)
        : (0, null);
    final int workoutsCompleted = useManualWorkouts
        ? manualWorkoutCount
        : base.workoutsCompleted;
    final int? caloriesBurned = useManualWorkouts
        ? manualCaloriesBurned
        : base.caloriesBurned;

    final nutritionMode = await fetchNutritionSourceMode();
    final NutritionEntryRow? manualNutrition =
        nutritionMode == DataSourceMode.manual
        ? await (_db.select(
            _db.nutritionEntries,
          )..where((t) => t.date.equals(today))).getSingleOrNull()
        : null;
    final bool useManualNutrition = nutritionMode == DataSourceMode.manual;

    await _db
        .into(_db.healthSnapshots)
        .insertOnConflictUpdate(
          HealthSnapshotsCompanion.insert(
            date: base.date,
            syncedAt: base.syncedAt,
            steps: Value(base.steps),
            workoutsCompleted: Value(workoutsCompleted),
            caloriesBurned: Value(caloriesBurned),
            caloriesConsumed: Value(
              useManualNutrition ? manualNutrition?.calories : base.caloriesConsumed,
            ),
            proteinGrams: Value(
              useManualNutrition ? manualNutrition?.proteinGrams : base.proteinGrams,
            ),
            carbsGrams: Value(
              useManualNutrition ? manualNutrition?.carbsGrams : base.carbsGrams,
            ),
            fatGrams: Value(
              useManualNutrition ? manualNutrition?.fatGrams : base.fatGrams,
            ),
          ),
        );
  }

  Future<(int, int?)> _manualWorkoutsSummaryOn(DateTime day) async {
    final DateTime nextDay = day.add(const Duration(days: 1));
    final rows =
        await (_db.select(_db.workoutEntries)..where(
              (t) => t.start.isBiggerOrEqualValue(day) & t.start.isSmallerThanValue(nextDay),
            ))
            .get();

    int? caloriesBurned;
    for (final row in rows) {
      if (row.caloriesBurned != null) {
        caloriesBurned = (caloriesBurned ?? 0) + row.caloriesBurned!;
      }
    }
    return (rows.length, caloriesBurned);
  }

  /// Manual workout/nutrition writes affect the home card and gamification
  /// only through the cached "today" snapshot — refresh it immediately when
  /// the edited entry is for today, rather than waiting for the next
  /// app-foreground refresh.
  Future<void> _refreshTodayIfNeeded(DateTime date) async {
    if (_normalizeDate(date) == _normalizeDate(DateTime.now())) {
      await refreshToday();
    }
  }

  DateTime _normalizeDate(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  HealthSnapshot _toDomain(HealthSnapshotRow row) => HealthSnapshot(
    date: row.date,
    steps: row.steps,
    workoutsCompleted: row.workoutsCompleted,
    syncedAt: row.syncedAt,
    caloriesConsumed: row.caloriesConsumed,
    caloriesBurned: row.caloriesBurned,
    proteinGrams: row.proteinGrams,
    carbsGrams: row.carbsGrams,
    fatGrams: row.fatGrams,
  );
}
