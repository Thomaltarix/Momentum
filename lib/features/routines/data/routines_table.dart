import 'package:drift/drift.dart';

import '../domain/routine_recurrence.dart';
import '../domain/routine_trigger.dart';

@DataClassName('RoutineRow')
class Routines extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  TextColumn get trigger => textEnum<RoutineTrigger>()();

  /// "HH:mm", only set when [trigger] is [RoutineTrigger.fixedTime].
  TextColumn get scheduledTime => text().nullable()();
  TextColumn get recurrence => textEnum<RoutineRecurrence>()();

  /// Comma-separated weekday indices, only set when [recurrence] is
  /// [RoutineRecurrence.custom].
  TextColumn get customDays => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

@DataClassName('RoutineCompletionRow')
class RoutineCompletions extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get routineId => integer().references(Routines, #id)();

  /// Date only (normalized to midnight) — a routine is done-for-the-day,
  /// not timestamped to the minute.
  DateTimeColumn get completedAt => dateTime()();
}
