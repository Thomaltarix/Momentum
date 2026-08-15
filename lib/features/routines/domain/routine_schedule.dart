import 'routine.dart';
import 'routine_recurrence.dart';

bool isRoutineDueOn(Routine routine, DateTime date) {
  switch (routine.recurrence) {
    case RoutineRecurrence.daily:
      return true;
    case RoutineRecurrence.weekdays:
      return date.weekday >= DateTime.monday && date.weekday <= DateTime.friday;
    case RoutineRecurrence.custom:
      return routine.customDays?.contains(date.weekday) ?? false;
  }
}
