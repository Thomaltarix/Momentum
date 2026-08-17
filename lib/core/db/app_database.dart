import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../features/gamification/data/gamification_tables.dart';
import '../../features/health_sync/data/data_source_settings_table.dart';
import '../../features/health_sync/data/health_snapshots_table.dart';
import '../../features/health_sync/data/manual_entries_tables.dart';
import '../../features/health_sync/domain/workout_category.dart';
import '../../features/routines/data/routines_table.dart';
import '../../features/routines/domain/routine_recurrence.dart';
import '../../features/routines/domain/routine_trigger.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    Routines,
    RoutineCompletions,
    HealthSnapshots,
    GamificationStates,
    Badges,
    DataSourceSettings,
    WeightEntries,
    NutritionEntries,
    WorkoutEntries,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  // v1: Routines, RoutineCompletions, HealthSnapshots (Phases 2-3).
  // v2: + GamificationStates, Badges (Phase 4).
  // v3: + DataSourceSettings, WeightEntries, NutritionEntries, WorkoutEntries
  // (manual data entry, Phase 7 brought forward). Never edit a past
  // migration step — add a new one instead, per claude/data-model.md.
  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        await m.createTable(gamificationStates);
        await m.createTable(badges);
      }
      if (from < 3) {
        await m.createTable(dataSourceSettings);
        await m.createTable(weightEntries);
        await m.createTable(nutritionEntries);
        await m.createTable(workoutEntries);
      }
    },
  );
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
