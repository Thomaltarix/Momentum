import 'package:drift/drift.dart';

import '../../../core/db/app_database.dart';
import '../../health_sync/data/health_sync_repository.dart';
import '../../routines/data/routines_repository.dart';
import '../../routines/domain/routine.dart';
import '../../routines/domain/routine_schedule.dart';
import '../domain/badge.dart';
import '../domain/badge_definitions.dart';
import '../domain/gamification_evaluator.dart';
import '../domain/gamification_state.dart';

class GamificationRepository {
  GamificationRepository(this._db, this._routinesRepository, this._healthSyncRepository);

  final AppDatabase _db;
  final RoutinesRepository _routinesRepository;
  final HealthSyncRepository _healthSyncRepository;

  Stream<GamificationState> watchState() {
    return _db.select(_db.gamificationStates).watchSingleOrNull().map(
      (row) => row == null ? GamificationState.initial(_today()) : _toDomain(row),
    );
  }

  Stream<List<Badge>> watchUnlockedBadges() {
    return _db.select(_db.badges).watch().map(
      (rows) => rows.map((row) => Badge(code: row.code, unlockedAt: row.unlockedAt)).toList(),
    );
  }

  /// Call on app open (see gamification_providers.dart) — replays every
  /// day since the last evaluation, not just "today", so a gap of several
  /// days between app opens is still scored correctly.
  Future<void> evaluateUpToYesterday() async {
    final GamificationState current = await _readState();
    final DateTime today = _today();
    final List<Routine> allRoutines = await _routinesRepository.fetchAllRoutines();

    final GamificationState updated = await evaluatePendingDays(
      state: current,
      asOf: today,
      wasDaySuccessful: (day) => _wasDaySuccessful(day, allRoutines),
    );

    if (updated.lastEvaluatedDate != current.lastEvaluatedDate) {
      await _saveState(updated);
      await _checkBadges(updated);
    }
  }

  Future<bool> _wasDaySuccessful(DateTime day, List<Routine> allRoutines) async {
    final dueRoutines = allRoutines.where((routine) => isRoutineDueOn(routine, day)).toList();
    final Set<int> completedIds = await _routinesRepository.fetchCompletedRoutineIdsForDate(day);
    final bool allRoutinesDone = dueRoutines.every((routine) => completedIds.contains(routine.id));

    final snapshot = await _healthSyncRepository.fetchSnapshot(day);
    final goals = await _healthSyncRepository.fetchGoals();
    final bool stepsGoalMet = (snapshot?.steps ?? 0) >= goals.stepGoal;

    return allRoutinesDone && stepsGoalMet;
  }

  Future<void> _checkBadges(GamificationState state) async {
    final existingCodes = (await _db.select(_db.badges).get()).map((row) => row.code).toSet();
    for (final definition in badgeDefinitions) {
      if (!existingCodes.contains(definition.code) && definition.isUnlocked(state)) {
        await _db
            .into(_db.badges)
            .insert(BadgesCompanion.insert(code: definition.code, unlockedAt: DateTime.now()));
      }
    }
  }

  Future<GamificationState> _readState() async {
    final row = await _db.select(_db.gamificationStates).getSingleOrNull();
    return row == null ? GamificationState.initial(_today()) : _toDomain(row);
  }

  Future<void> _saveState(GamificationState state) {
    return _db.into(_db.gamificationStates).insertOnConflictUpdate(
      GamificationStatesCompanion.insert(
        id: const Value(0),
        currentXp: Value(state.currentXp),
        currentLevel: Value(state.currentLevel),
        currentStreak: Value(state.currentStreak),
        longestStreak: Value(state.longestStreak),
        lastEvaluatedDate: state.lastEvaluatedDate,
      ),
    );
  }

  DateTime _today() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  GamificationState _toDomain(GamificationStateRow row) => GamificationState(
    currentXp: row.currentXp,
    currentLevel: row.currentLevel,
    currentStreak: row.currentStreak,
    longestStreak: row.longestStreak,
    lastEvaluatedDate: row.lastEvaluatedDate,
  );
}
