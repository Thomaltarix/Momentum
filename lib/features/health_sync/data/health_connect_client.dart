import 'package:health/health.dart';

import '../domain/daily_nutrition.dart';
import '../domain/daily_steps.dart';
import '../domain/health_snapshot.dart';
import '../domain/workout_category.dart';
import '../domain/workout_entry.dart';

// The only file that imports package:health (see claude/features.md). Every
// other feature reads health data through health_sync's domain model /
// cached Drift snapshot, never by calling this package directly.
class HealthConnectClient {
  HealthConnectClient() : _health = Health() {
    _health.configure();
  }

  final Health _health;

  static const List<HealthDataType> _types = [
    HealthDataType.STEPS,
    HealthDataType.WORKOUT,
    HealthDataType.NUTRITION,
  ];

  Future<bool> isHealthConnectAvailable() => _health.isHealthConnectAvailable();

  Future<bool> hasPermissions() async =>
      await _health.hasPermissions(_types) ?? false;

  Future<bool> requestPermissions() => _health.requestAuthorization(_types);

  Future<HealthSnapshot> fetchToday() async {
    final DateTime now = DateTime.now();
    final DateTime midnight = DateTime(now.year, now.month, now.day);

    final int steps =
        await _health.getTotalStepsInInterval(midnight, now) ?? 0;

    final List<HealthDataPoint> workoutPoints = await _health
        .getHealthDataFromTypes(
          types: const [HealthDataType.WORKOUT],
          startTime: midnight,
          endTime: now,
        );

    final List<HealthDataPoint> nutritionPoints = await _health
        .getHealthDataFromTypes(
          types: const [HealthDataType.NUTRITION],
          startTime: midnight,
          endTime: now,
        );

    double? calories;
    double? protein;
    double? carbs;
    double? fat;
    for (final HealthDataPoint point in nutritionPoints) {
      final value = point.value;
      if (value is NutritionHealthValue) {
        calories = (calories ?? 0) + (value.calories ?? 0);
        protein = (protein ?? 0) + (value.protein ?? 0);
        carbs = (carbs ?? 0) + (value.carbs ?? 0);
        fat = (fat ?? 0) + (value.fat ?? 0);
      }
    }

    return HealthSnapshot(
      date: midnight,
      steps: steps,
      workoutsCompleted: workoutPoints.length,
      syncedAt: now,
      caloriesConsumed: calories?.round(),
      proteinGrams: protein,
      carbsGrams: carbs,
      fatGrams: fat,
    );
  }

  /// Most recent first. Same rationale as [fetchStepsHistory]: queries
  /// Health Connect directly rather than the local cache, since past
  /// workouts were already recorded by Lyfta regardless of whether Momentum
  /// was open.
  Future<List<WorkoutEntry>> fetchWorkoutsHistory(int days) async {
    final DateTime now = DateTime.now();
    final DateTime start = DateTime(
      now.year,
      now.month,
      now.day,
    ).subtract(Duration(days: days - 1));

    final List<HealthDataPoint> points = await _health.getHealthDataFromTypes(
      types: const [HealthDataType.WORKOUT],
      startTime: start,
      endTime: now,
    );

    final List<WorkoutEntry> entries = points
        .map((point) {
          final value = point.value;
          if (value is! WorkoutHealthValue) return null;
          final (WorkoutCategory category, String label) = _describeActivity(
            value.workoutActivityType,
          );
          return WorkoutEntry(
            category: category,
            label: label,
            start: point.dateFrom,
            end: point.dateTo,
            caloriesBurned: value.totalEnergyBurned,
          );
        })
        .whereType<WorkoutEntry>()
        .toList()
      ..sort((a, b) => b.start.compareTo(a.start));

    return entries;
  }

  (WorkoutCategory, String) _describeActivity(HealthWorkoutActivityType type) {
    switch (type) {
      case HealthWorkoutActivityType.RUNNING:
      case HealthWorkoutActivityType.RUNNING_TREADMILL:
        return (WorkoutCategory.running, 'Course à pied');
      case HealthWorkoutActivityType.WALKING:
        return (WorkoutCategory.walking, 'Marche');
      case HealthWorkoutActivityType.HIKING:
        return (WorkoutCategory.hiking, 'Randonnée');
      case HealthWorkoutActivityType.BIKING:
        return (WorkoutCategory.cycling, 'Vélo');
      case HealthWorkoutActivityType.SWIMMING:
      case HealthWorkoutActivityType.SWIMMING_POOL:
      case HealthWorkoutActivityType.SWIMMING_OPEN_WATER:
        return (WorkoutCategory.swimming, 'Natation');
      case HealthWorkoutActivityType.STRENGTH_TRAINING:
      case HealthWorkoutActivityType.TRADITIONAL_STRENGTH_TRAINING:
      case HealthWorkoutActivityType.FUNCTIONAL_STRENGTH_TRAINING:
        return (WorkoutCategory.strength, 'Musculation');
      case HealthWorkoutActivityType.YOGA:
        return (WorkoutCategory.yoga, 'Yoga');
      case HealthWorkoutActivityType.ROWING:
        return (WorkoutCategory.rowing, 'Aviron');
      case HealthWorkoutActivityType.ELLIPTICAL:
      case HealthWorkoutActivityType.HIGH_INTENSITY_INTERVAL_TRAINING:
        return (WorkoutCategory.cardio, 'Cardio');
      default:
        return (WorkoutCategory.other, 'Séance');
    }
  }

  /// Most recent first. One range query, bucketed by day client-side —
  /// unlike steps, nutrition has no platform "total in interval" helper.
  Future<List<DailyNutrition>> fetchNutritionHistory(int days) async {
    final DateTime now = DateTime.now();
    final DateTime today = DateTime(now.year, now.month, now.day);
    final DateTime start = today.subtract(Duration(days: days - 1));

    final List<HealthDataPoint> points = await _health.getHealthDataFromTypes(
      types: const [HealthDataType.NUTRITION],
      startTime: start,
      endTime: now,
    );

    final Map<DateTime, _NutritionTotals> totalsByDay = {};
    for (final HealthDataPoint point in points) {
      final value = point.value;
      if (value is! NutritionHealthValue) continue;
      final DateTime day = DateTime(
        point.dateFrom.year,
        point.dateFrom.month,
        point.dateFrom.day,
      );
      final totals = totalsByDay.putIfAbsent(day, _NutritionTotals.new);
      totals.calories += value.calories ?? 0;
      totals.protein += value.protein ?? 0;
      totals.carbs += value.carbs ?? 0;
      totals.fat += value.fat ?? 0;
    }

    return List.generate(days, (i) {
      final DateTime day = start.add(Duration(days: i));
      final totals = totalsByDay[day];
      if (totals == null) return DailyNutrition(date: day);
      return DailyNutrition(
        date: day,
        calories: totals.calories.round(),
        proteinGrams: totals.protein,
        carbsGrams: totals.carbs,
        fatGrams: totals.fat,
      );
    }).reversed.toList();
  }

  /// Oldest first. Queries Health Connect directly rather than the local
  /// cache — the cache only ever holds "today" (see health_sync_repository),
  /// but steps for past days were already recorded by the phone regardless
  /// of whether Momentum was open to cache them.
  Future<List<DailySteps>> fetchStepsHistory(int days) async {
    final DateTime now = DateTime.now();
    final DateTime today = DateTime(now.year, now.month, now.day);

    final List<DateTime> dayStarts = List.generate(
      days,
      (i) => today.subtract(Duration(days: days - 1 - i)),
    );

    return Future.wait(
      dayStarts.map((dayStart) async {
        final DateTime dayEnd = dayStart == today
            ? now
            : dayStart.add(const Duration(days: 1));
        final int steps =
            await _health.getTotalStepsInInterval(dayStart, dayEnd) ?? 0;
        return DailySteps(date: dayStart, steps: steps);
      }),
    );
  }
}

class _NutritionTotals {
  double calories = 0;
  double protein = 0;
  double carbs = 0;
  double fat = 0;
}
