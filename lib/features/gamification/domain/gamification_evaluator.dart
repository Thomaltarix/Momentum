import 'gamification_state.dart';

// Placeholder values, same footing as health_sync's defaultDailyStepGoal —
// revisit once Phase 5 lets any of this be configured.
const int xpPerSuccessfulDay = 20;
const int xpPerLevel = 100;

int computeLevel(int xp) => xp ~/ xpPerLevel + 1;

typedef DaySuccessCheck = Future<bool> Function(DateTime day);

/// Replays every day between [state.lastEvaluatedDate] (exclusive) and
/// [asOf] (exclusive — "today" is still in progress, never evaluated) via
/// [wasDaySuccessful], updating XP/streak one day at a time. Async because
/// the caller needs to hit the database per day, but the logic itself is
/// deterministic and doesn't touch Flutter or Drift directly — see
/// test/features/gamification/domain for coverage that doesn't need either.
Future<GamificationState> evaluatePendingDays({
  required GamificationState state,
  required DateTime asOf,
  required DaySuccessCheck wasDaySuccessful,
}) async {
  DateTime cursor = _nextDay(state.lastEvaluatedDate);
  GamificationState updated = state;

  while (cursor.isBefore(asOf)) {
    final bool successful = await wasDaySuccessful(cursor);
    final int newStreak = successful ? updated.currentStreak + 1 : 0;
    final int newXp = successful
        ? updated.currentXp + xpPerSuccessfulDay
        : updated.currentXp;

    updated = updated.copyWith(
      currentXp: newXp,
      currentLevel: computeLevel(newXp),
      currentStreak: newStreak,
      longestStreak: newStreak > updated.longestStreak
          ? newStreak
          : updated.longestStreak,
      lastEvaluatedDate: cursor,
    );

    cursor = _nextDay(cursor);
  }

  return updated;
}

DateTime _nextDay(DateTime date) =>
    DateTime(date.year, date.month, date.day + 1);
