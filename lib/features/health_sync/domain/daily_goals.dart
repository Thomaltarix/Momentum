/// What the user wants to reach in a day, editable via GoalsScreen. Used
/// wherever the app previously showed a fixed placeholder (step ring,
/// macro bar scale, gamification's step-goal check) — see
/// claude/data-model.md.
class DailyGoals {
  const DailyGoals({
    required this.stepGoal,
    required this.calorieGoal,
    required this.proteinGoal,
    required this.carbsGoal,
    required this.fatGoal,
  });

  final int stepGoal;
  final int calorieGoal;
  final double proteinGoal;
  final double carbsGoal;
  final double fatGoal;

  /// Seeds a fresh install and the goals form the first time it opens —
  /// the same numbers this app displayed before goals were configurable,
  /// so nothing jumps on upgrade.
  static const DailyGoals defaults = DailyGoals(
    stepGoal: 5000,
    calorieGoal: 2200,
    proteinGoal: 200,
    carbsGoal: 300,
    fatGoal: 100,
  );
}
