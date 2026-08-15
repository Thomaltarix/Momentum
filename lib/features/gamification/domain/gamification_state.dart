class GamificationState {
  const GamificationState({
    required this.currentXp,
    required this.currentLevel,
    required this.currentStreak,
    required this.longestStreak,
    required this.lastEvaluatedDate,
  });

  /// The day before [today] — nothing has been evaluated yet, so the first
  /// call to the evaluator has no completed days to look back on.
  factory GamificationState.initial(DateTime today) => GamificationState(
    currentXp: 0,
    currentLevel: 1,
    currentStreak: 0,
    longestStreak: 0,
    lastEvaluatedDate: DateTime(today.year, today.month, today.day - 1),
  );

  final int currentXp;
  final int currentLevel;
  final int currentStreak;
  final int longestStreak;
  final DateTime lastEvaluatedDate;

  GamificationState copyWith({
    int? currentXp,
    int? currentLevel,
    int? currentStreak,
    int? longestStreak,
    DateTime? lastEvaluatedDate,
  }) {
    return GamificationState(
      currentXp: currentXp ?? this.currentXp,
      currentLevel: currentLevel ?? this.currentLevel,
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      lastEvaluatedDate: lastEvaluatedDate ?? this.lastEvaluatedDate,
    );
  }
}
