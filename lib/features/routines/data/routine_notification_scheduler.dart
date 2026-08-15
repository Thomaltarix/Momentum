import '../../../core/notifications/notification_service.dart';
import '../domain/routine.dart';
import '../domain/routine_recurrence.dart';
import '../domain/routine_trigger.dart';

// Decides *when* a routine should notify and calls the core notification
// primitives to do it. core/notifications knows nothing about routines;
// this is where that domain-specific decision lives (see claude/features.md).
class RoutineNotificationScheduler {
  RoutineNotificationScheduler(this._notifications);

  final NotificationService _notifications;

  static const List<int> _weekdays = [
    DateTime.monday,
    DateTime.tuesday,
    DateTime.wednesday,
    DateTime.thursday,
    DateTime.friday,
    DateTime.saturday,
    DateTime.sunday,
  ];

  Future<void> reschedule(Routine routine) async {
    await cancel(routine.id);

    if (routine.trigger != RoutineTrigger.fixedTime ||
        routine.scheduledTime == null) {
      return;
    }

    final (hour, minute) = _parseTime(routine.scheduledTime!);

    switch (routine.recurrence) {
      case RoutineRecurrence.daily:
        await _notifications.scheduleDailyAt(
          id: routine.id,
          title: routine.title,
          body: 'Il est temps.',
          hour: hour,
          minute: minute,
        );
      case RoutineRecurrence.weekdays:
        for (final weekday in _weekdays.take(5)) {
          await _notifications.scheduleWeeklyAt(
            id: _weeklyNotificationId(routine.id, weekday),
            title: routine.title,
            body: 'Il est temps.',
            weekday: weekday,
            hour: hour,
            minute: minute,
          );
        }
      case RoutineRecurrence.custom:
        for (final weekday in routine.customDays ?? const <int>[]) {
          await _notifications.scheduleWeeklyAt(
            id: _weeklyNotificationId(routine.id, weekday),
            title: routine.title,
            body: 'Il est temps.',
            weekday: weekday,
            hour: hour,
            minute: minute,
          );
        }
    }
  }

  Future<void> cancel(int routineId) async {
    await _notifications.cancel(routineId);
    for (final weekday in _weekdays) {
      await _notifications.cancel(_weeklyNotificationId(routineId, weekday));
    }
  }

  int _weeklyNotificationId(int routineId, int weekday) =>
      routineId * 10 + weekday;

  (int, int) _parseTime(String hhmm) {
    final parts = hhmm.split(':');
    return (int.parse(parts[0]), int.parse(parts[1]));
  }
}
