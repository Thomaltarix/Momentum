import 'workout_category.dart';

class WorkoutEntry {
  const WorkoutEntry({
    this.id,
    required this.category,
    required this.label,
    required this.start,
    required this.end,
    this.caloriesBurned,
  });

  /// Row id for a manually-entered workout, so it can be edited/deleted.
  /// Null for entries read from Health Connect — Momentum never writes back
  /// to it, so there's nothing to edit.
  final int? id;

  final WorkoutCategory category;

  /// French display name, e.g. "Course à pied" — resolved once in the data
  /// layer so presentation never needs to know about Health Connect's
  /// activity-type enum.
  final String label;
  final DateTime start;
  final DateTime end;
  final int? caloriesBurned;

  Duration get duration => end.difference(start);
}
