import 'package:health/health.dart';

import '../domain/health_snapshot.dart';

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
}
