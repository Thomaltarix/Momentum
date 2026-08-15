import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../features/health_sync/data/health_snapshots_table.dart';
import '../../features/routines/data/routines_table.dart';
import '../../features/routines/domain/routine_recurrence.dart';
import '../../features/routines/domain/routine_trigger.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [Routines, RoutineCompletions, HealthSnapshots])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

final Provider<AppDatabase> databaseProvider = Provider<AppDatabase>((ref) {
  final AppDatabase database = AppDatabase();
  ref.onDispose(database.close);
  return database;
});

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File(p.join(directory.path, 'momentum.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
