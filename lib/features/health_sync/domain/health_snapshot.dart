class HealthSnapshot {
  const HealthSnapshot({
    required this.date,
    required this.steps,
    required this.workoutsCompleted,
    required this.syncedAt,
    this.caloriesConsumed,
    this.proteinGrams,
    this.carbsGrams,
    this.fatGrams,
  });

  final DateTime date;
  final int steps;
  final int workoutsCompleted;
  final DateTime syncedAt;
  final int? caloriesConsumed;
  final double? proteinGrams;
  final double? carbsGrams;
  final double? fatGrams;
}
