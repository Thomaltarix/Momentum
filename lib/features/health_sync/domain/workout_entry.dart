import 'workout_category.dart';

class WorkoutEntry {
  const WorkoutEntry({
    required this.category,
    required this.label,
    required this.start,
    required this.end,
    this.caloriesBurned,
  });

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
