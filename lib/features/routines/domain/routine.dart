import 'routine_recurrence.dart';
import 'routine_trigger.dart';

class Routine {
  const Routine({
    required this.id,
    required this.title,
    required this.trigger,
    required this.recurrence,
    required this.createdAt,
    this.scheduledTime,
    this.customDays,
  });

  final int id;
  final String title;
  final RoutineTrigger trigger;

  /// "HH:mm", set only when [trigger] is [RoutineTrigger.fixedTime].
  final String? scheduledTime;
  final RoutineRecurrence recurrence;

  /// Weekday indices (DateTime.monday..DateTime.sunday), set only when
  /// [recurrence] is [RoutineRecurrence.custom].
  final List<int>? customDays;
  final DateTime createdAt;
}
