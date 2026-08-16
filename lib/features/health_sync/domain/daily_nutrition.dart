class DailyNutrition {
  const DailyNutrition({
    required this.date,
    this.calories,
    this.proteinGrams,
    this.carbsGrams,
    this.fatGrams,
  });

  final DateTime date;
  final int? calories;
  final double? proteinGrams;
  final double? carbsGrams;
  final double? fatGrams;
}
