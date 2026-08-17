import 'package:drift/drift.dart';

import '../domain/workout_category.dart';

// Local entries typed directly into Momentum, used when a metric's
// DataSourceSettings is `manual` instead of `healthConnect`. Never written
// back to Health Connect (see claude/CLAUDE.md: "Read-only, always").

/// One weigh-in per day, same shape as the Health Connect reading it
/// replaces — re-entering a weight for the same day overwrites it.
@DataClassName('WeightEntryRow')
class WeightEntries extends Table {
  DateTimeColumn get date => dateTime()();
  RealColumn get kilograms => real()();

  @override
  Set<Column> get primaryKey => {date};
}

/// One raw daily total per day — a number typed in, not a food diary (see
/// claude/CLAUDE.md: "does not build its own nutrition database").
@DataClassName('NutritionEntryRow')
class NutritionEntries extends Table {
  DateTimeColumn get date => dateTime()();
  IntColumn get calories => integer()();
  RealColumn get proteinGrams => real().nullable()();
  RealColumn get carbsGrams => real().nullable()();
  RealColumn get fatGrams => real().nullable()();

  @override
  Set<Column> get primaryKey => {date};
}

/// Auto-increment id, unlike weight/nutrition — several workout sessions can
/// happen the same day.
@DataClassName('WorkoutEntryRow')
class WorkoutEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get category => textEnum<WorkoutCategory>()();
  DateTimeColumn get start => dateTime()();
  DateTimeColumn get end => dateTime()();
  IntColumn get caloriesBurned => integer().nullable()();
}
