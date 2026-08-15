import 'package:drift/drift.dart';

import '../../../core/db/app_database.dart';
import '../domain/health_snapshot.dart';
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

  Future<bool> hasPermissions() => _client.hasPermissions();

  Future<bool> requestPermissions() => _client.requestPermissions();

  Future<bool> isHealthConnectAvailable() =>
      _client.isHealthConnectAvailable();

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
