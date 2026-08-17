import 'macro_calculator_input.dart';

/// The nutrition slice of DailyGoals — deliberately not the full DailyGoals
/// type, since this calculator has no opinion on stepGoal.
class MacroTargets {
  const MacroTargets({
    required this.calorieGoal,
    required this.proteinGoal,
    required this.carbsGoal,
    required this.fatGoal,
  });

  final int calorieGoal;
  final double proteinGoal;
  final double carbsGoal;
  final double fatGoal;
}

/// Mifflin-St Jeor BMR → TDEE → goal-adjusted calories → macros.
///
/// Protein and fat are set per kilogram of bodyweight (2.0 g/kg and
/// 0.9 g/kg — standard sports-nutrition baselines that hold up whether
/// cutting, maintaining, or bulking), and carbs absorb whatever calories
/// are left. This keeps the split transparent instead of picking
/// per-objective ratios that would be harder to justify.
MacroTargets computeMacroTargets(MacroCalculatorInput input) {
  final double bmr = input.sex == Sex.male
      ? 10 * input.weightKg + 6.25 * input.heightCm - 5 * input.age + 5
      : 10 * input.weightKg + 6.25 * input.heightCm - 5 * input.age - 161;

  final double tdee = bmr * input.activityLevel.multiplier;
  final int calorieGoal = (tdee + input.objective.calorieAdjustment).round();

  final double proteinGoal = input.weightKg * 2.0;
  final double fatGoal = input.weightKg * 0.9;

  final double proteinCalories = proteinGoal * 4;
  final double fatCalories = fatGoal * 9;
  final double carbsGoal =
      ((calorieGoal - proteinCalories - fatCalories) / 4).clamp(
        0,
        double.infinity,
      );

  return MacroTargets(
    calorieGoal: calorieGoal,
    proteinGoal: proteinGoal,
    carbsGoal: carbsGoal,
    fatGoal: fatGoal,
  );
}
