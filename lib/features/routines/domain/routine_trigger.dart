// afterWake/beforeSleep are modeled now (see claude/data-model.md) but not
// yet schedulable — they need a "wake" signal the app doesn't have. Only
// fixedTime is wired to a real notification today (routine_notification_scheduler.dart).
enum RoutineTrigger { fixedTime, afterWake, beforeSleep }
