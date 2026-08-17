import 'package:flutter_test/flutter_test.dart';
import 'package:momentum/features/health_sync/domain/macro_calculator.dart';
import 'package:momentum/features/health_sync/domain/macro_calculator_input.dart';

void main() {
  MacroCalculatorInput input({
    Sex sex = Sex.male,
    int age = 30,
    double weightKg = 80,
    double heightCm = 180,
    ActivityLevel activityLevel = ActivityLevel.sedentary,
    NutritionObjective objective = NutritionObjective.maintain,
  }) {
    return MacroCalculatorInput(
      sex: sex,
      age: age,
      weightKg: weightKg,
      heightCm: heightCm,
      activityLevel: activityLevel,
      objective: objective,
    );
  }

  test('Mifflin-St Jeor BMR/TDEE matches the known formula for men', () {
    // BMR = 10*80 + 6.25*180 - 5*30 + 5 = 800 + 1125 - 150 + 5 = 1780
    // TDEE (sedentary, x1.2) = 2136 -> maintain adjustment (0) -> 2136
    final result = computeMacroTargets(input());
    expect(result.calorieGoal, 2136);
  });

  test('women get the -161 offset instead of +5', () {
    // BMR = 10*80 + 6.25*180 - 5*30 - 161 = 800 + 1125 - 150 - 161 = 1614
    // TDEE (sedentary, x1.2) = 1936.8 -> round = 1937
    final result = computeMacroTargets(input(sex: Sex.female));
    expect(result.calorieGoal, 1937);
  });

  test('higher activity level raises the calorie goal', () {
    final sedentary = computeMacroTargets(
      input(activityLevel: ActivityLevel.sedentary),
    );
    final veryActive = computeMacroTargets(
      input(activityLevel: ActivityLevel.veryActive),
    );
    expect(veryActive.calorieGoal, greaterThan(sedentary.calorieGoal));
  });

  test('losing weight subtracts 500 kcal, gaining muscle adds 300', () {
    final maintain = computeMacroTargets(
      input(objective: NutritionObjective.maintain),
    );
    final lose = computeMacroTargets(
      input(objective: NutritionObjective.loseWeight),
    );
    final gain = computeMacroTargets(
      input(objective: NutritionObjective.gainMuscle),
    );

    expect(lose.calorieGoal, maintain.calorieGoal - 500);
    expect(gain.calorieGoal, maintain.calorieGoal + 300);
  });

  test('protein and fat scale with bodyweight, carbs absorb the rest', () {
    final result = computeMacroTargets(input(weightKg: 80));

    expect(result.proteinGoal, 160); // 80 * 2.0
    expect(result.fatGoal, 72); // 80 * 0.9
    final double expectedCarbsCalories =
        result.calorieGoal - result.proteinGoal * 4 - result.fatGoal * 9;
    expect(result.carbsGoal, closeTo(expectedCarbsCalories / 4, 0.001));
  });

  test('carbs never go negative for a very low calorie goal', () {
    // Small, older, sedentary, cutting: protein+fat calories
    // (45*2*4 + 45*0.9*9 = 724.5) exceed the calorie goal (~552) before
    // clamping — carbs should floor at 0, not go negative.
    final result = computeMacroTargets(
      input(
        sex: Sex.female,
        age: 70,
        weightKg: 45,
        heightCm: 150,
        activityLevel: ActivityLevel.sedentary,
        objective: NutritionObjective.loseWeight,
      ),
    );

    expect(result.calorieGoal, lessThan(45 * 2 * 4 + 45 * 0.9 * 9));
    expect(result.carbsGoal, 0);
  });
}
