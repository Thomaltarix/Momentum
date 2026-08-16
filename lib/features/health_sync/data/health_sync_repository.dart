import 'package:drift/drift.dart';

import '../../../core/db/app_database.dart';
import '../domain/daily_nutrition.dart';
import '../domain/daily_steps.dart';
import '../domain/health_snapshot.dart';
import '../domain/weight_entry.dart';
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

  Future<List<WorkoutEntry>> fetchWorkoutsHistory(int days) =>
      _client.fetchWorkoutsHistory(days);

  Future<List<DailyNutrition>> fetchNutritionHistory(int days) =>
      _client.fetchNutritionHistory(days);

  Future<List<WeightEntry>> fetchWeightHistory(int days) =>
      _client.fetchWeightHistory(days);

  Future<void> refreshToday() async {
    final HealthSnapshot snapshot = await _client.fetchToday();
    await _db
        .into(_db.healthSnapshots)
        .insertOnConflictUpdate(
          HealthSnapshotsCompanion.insert(
            date: snapshot.date,
            syncedAt: snapshot.syncedAt,
            steps: Value(snapshot.steps),
            workoutsCompleted: Value(snapshot.workoutsCompleted),
            caloriesConsumed: Value(snapshot.caloriesConsumed),
            proteinGrams: Value(snapshot.proteinGrams),
            carbsGrams: Value(snapshot.carbsGrams),
            fatGrams: Value(snapshot.fatGrams),
          ),
        );
  }

  DateTime _normalizeDate(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  HealthSnapshot _toDomain(HealthSnapshotRow row) => HealthSnapshot(
    date: row.date,
    steps: row.steps,
    workoutsCompleted: row.workoutsCompleted,
    syncedAt: row.syncedAt,
    caloriesConsumed: row.caloriesConsumed,
    proteinGrams: row.proteinGrams,
    carbsGrams: row.carbsGrams,
    fatGrams: row.fatGrams,
  );
}
