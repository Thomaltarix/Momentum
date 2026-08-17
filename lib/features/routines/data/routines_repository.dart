import 'package:drift/drift.dart';

import '../../../core/db/app_database.dart';
import '../domain/routine.dart';
import '../domain/routine_recurrence.dart';
import '../domain/routine_trigger.dart';
import 'routine_notification_scheduler.dart';

class RoutinesRepository {
  RoutinesRepository(this._db, this._scheduler);

  final AppDatabase _db;
  final RoutineNotificationScheduler _scheduler;

  Stream<List<Routine>> watchRoutines() {
    return _db.select(_db.routines).watch().map(
      (rows) => rows.map(_toDomain).toList(),
    );
  }

  Future<List<Routine>> fetchAllRoutines() async {
    final rows = await _db.select(_db.routines).get();
    return rows.map(_toDomain).toList();
  }

  Stream<Set<int>> watchCompletedRoutineIdsForDate(DateTime date) {
    final normalized = _normalizeDate(date);
    return (_db.select(_db.routineCompletions)
          ..where((t) => t.completedAt.equals(normalized)))
        .watch()
        .map((rows) => rows.map((row) => row.routineId).toSet());
  }

  Future<Set<int>> fetchCompletedRoutineIdsForDate(DateTime date) async {
    final normalized = _normalizeDate(date);
    final rows = await (_db.select(
      _db.routineCompletions,
    )..where((t) => t.completedAt.equals(normalized))).get();
    return rows.map((row) => row.routineId).toSet();
  }

  Future<void> addRoutine({
    required String title,
    required String scheduledTime,
    required RoutineRecurrence recurrence,
    List<int>? customDays,
  }) async {
    final id = await _db.into(_db.routines).insert(
      RoutinesCompanion.insert(
        title: title,
        trigger: RoutineTrigger.fixedTime,
        scheduledTime: Value(scheduledTime),
        recurrence: recurrence,
        customDays: Value(customDays?.join(',')),
      ),
    );

    await _scheduler.reschedule(
      Routine(
        id: id,
        title: title,
        trigger: RoutineTrigger.fixedTime,
        scheduledTime: scheduledTime,
        recurrence: recurrence,
        customDays: customDays,
        createdAt: DateTime.now(),
      ),
    );
  }

  Future<void> updateRoutine({
    required int id,
    required String title,
    required String scheduledTime,
    required RoutineRecurrence recurrence,
    List<int>? customDays,
  }) async {
    await (_db.update(_db.routines)..where((t) => t.id.equals(id))).write(
      RoutinesCompanion(
        title: Value(title),
        scheduledTime: Value(scheduledTime),
        recurrence: Value(recurrence),
        customDays: Value(customDays?.join(',')),
      ),
    );

    await _scheduler.reschedule(
      Routine(
        id: id,
        title: title,
        trigger: RoutineTrigger.fixedTime,
        scheduledTime: scheduledTime,
        recurrence: recurrence,
        customDays: customDays,
        createdAt: DateTime.now(),
      ),
    );
  }

  Future<void> deleteRoutine(int id) async {
    await (_db.delete(_db.routines)..where((t) => t.id.equals(id))).go();
    await _scheduler.cancel(id);
  }

  Future<void> markCompleted(int routineId, DateTime date) {
    return _db.into(_db.routineCompletions).insert(
      RoutineCompletionsCompanion.insert(
        routineId: routineId,
        completedAt: _normalizeDate(date),
      ),
    );
  }

  Future<void> markIncomplete(int routineId, DateTime date) {
    final normalized = _normalizeDate(date);
    return (_db.delete(_db.routineCompletions)
          ..where(
            (t) =>
                t.routineId.equals(routineId) &
                t.completedAt.equals(normalized),
          ))
        .go();
  }

  DateTime _normalizeDate(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  Routine _toDomain(RoutineRow row) => Routine(
    id: row.id,
    title: row.title,
    trigger: row.trigger,
    scheduledTime: row.scheduledTime,
    recurrence: row.recurrence,
    customDays: row.customDays
        ?.split(',')
        .where((s) => s.isNotEmpty)
        .map(int.parse)
        .toList(),
    createdAt: row.createdAt,
  );
}
