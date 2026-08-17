enum Sex { male, female }

/// Standard Mifflin-St Jeor activity multipliers.
enum ActivityLevel { sedentary, light, moderate, active, veryActive }

extension ActivityLevelDetails on ActivityLevel {
  double get multiplier => switch (this) {
    ActivityLevel.sedentary => 1.2,
    ActivityLevel.light => 1.375,
    ActivityLevel.moderate => 1.55,
    ActivityLevel.active => 1.725,
    ActivityLevel.veryActive => 1.9,
  };

  String get label => switch (this) {
    ActivityLevel.sedentary => 'Sédentaire',
    ActivityLevel.light => 'Légèrement actif',
    ActivityLevel.moderate => 'Modérément actif',
    ActivityLevel.active => 'Très actif',
    ActivityLevel.veryActive => 'Extrêmement actif',
  };

  String get description => switch (this) {
    ActivityLevel.sedentary => 'Peu ou pas d\'exercice',
    ActivityLevel.light => 'Exercice léger, 1 à 3 jours/semaine',
    ActivityLevel.moderate => 'Exercice modéré, 3 à 5 jours/semaine',
    ActivityLevel.active => 'Exercice intense, 6 à 7 jours/semaine',
    ActivityLevel.veryActive => 'Exercice très intense ou travail physique',
  };
}

enum NutritionObjective { loseWeight, maintain, gainMuscle }

extension NutritionObjectiveDetails on NutritionObjective {
  /// kcal/day added to (or removed from) TDEE — a moderate, sustainable
  /// deficit/surplus rather than an aggressive one.
  int get calorieAdjustment => switch (this) {
    NutritionObjective.loseWeight => -500,
    NutritionObjective.maintain => 0,
    NutritionObjective.gainMuscle => 300,
  };

  String get label => switch (this) {
    NutritionObjective.loseWeight => 'Perte de poids',
    NutritionObjective.maintain => 'Maintien',
    NutritionObjective.gainMuscle => 'Prise de masse',
  };
}

/// Inputs to the Mifflin-St Jeor calculation (see macro_calculator.dart).
class MacroCalculatorInput {
  const MacroCalculatorInput({
    required this.sex,
    required this.age,
    required this.weightKg,
    required this.heightCm,
    required this.activityLevel,
    required this.objective,
  });

  final Sex sex;
  final int age;
  final double weightKg;
  final double heightCm;
  final ActivityLevel activityLevel;
  final NutritionObjective objective;
}

/// Everything MacroCalculatorScreen persists between visits — weight is
/// deliberately excluded, since it's read live from weight tracking
/// instead (see HealthSyncRepository.fetchWeightHistory).
class MacroCalculatorProfile {
  const MacroCalculatorProfile({
    required this.sex,
    required this.age,
    required this.heightCm,
    required this.activityLevel,
    required this.objective,
  });

  final Sex sex;
  final int age;
  final double heightCm;
  final ActivityLevel activityLevel;
  final NutritionObjective objective;

  static const MacroCalculatorProfile defaults = MacroCalculatorProfile(
    sex: Sex.male,
    age: 30,
    heightCm: 175,
    activityLevel: ActivityLevel.moderate,
    objective: NutritionObjective.maintain,
  );

  MacroCalculatorInput withWeight(double weightKg) => MacroCalculatorInput(
    sex: sex,
    age: age,
    weightKg: weightKg,
    heightCm: heightCm,
    activityLevel: activityLevel,
    objective: objective,
  );
}
