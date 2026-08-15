import 'package:flutter_test/flutter_test.dart';
import 'package:momentum/features/gamification/domain/gamification_evaluator.dart';
import 'package:momentum/features/gamification/domain/gamification_state.dart';

void main() {
  final DateTime day1 = DateTime(2026, 1, 1);
  final DateTime day2 = DateTime(2026, 1, 2);
  final DateTime day3 = DateTime(2026, 1, 3);
  final DateTime day4 = DateTime(2026, 1, 4);

  GamificationState stateEndingOn(DateTime lastEvaluatedDate) {
    return GamificationState(
      currentXp: 0,
      currentLevel: 1,
      currentStreak: 0,
      longestStreak: 0,
      lastEvaluatedDate: lastEvaluatedDate,
    );
  }

  test('computeLevel is 1 up to the first threshold, then increments per xpPerLevel', () {
    expect(computeLevel(0), 1);
    expect(computeLevel(xpPerLevel - 1), 1);
    expect(computeLevel(xpPerLevel), 2);
    expect(computeLevel(xpPerLevel * 4), 5);
  });

  test('does nothing when there are no days between lastEvaluatedDate and asOf', () async {
    final state = stateEndingOn(day1);

    final result = await evaluatePendingDays(
      state: state,
      asOf: day2, // day1 -> day2 is exactly one day away, so day1+1=day2 is not before day2
      wasDaySuccessful: (day) async => fail('should not be called'),
    );

    expect(result.lastEvaluatedDate, day1);
    expect(result.currentXp, 0);
  });

  test('a single successful day increments streak, xp and longestStreak', () async {
    final state = stateEndingOn(day1);

    final result = await evaluatePendingDays(
      state: state,
      asOf: day3, // evaluates day2 only (day3 itself is excluded)
      wasDaySuccessful: (day) async => day == day2,
    );

    expect(result.currentStreak, 1);
    expect(result.currentXp, xpPerSuccessfulDay);
    expect(result.longestStreak, 1);
    expect(result.lastEvaluatedDate, day2);
  });

  test('a failed day resets the current streak but keeps the longest one', () async {
    final state = GamificationState(
      currentXp: xpPerSuccessfulDay * 3,
      currentLevel: computeLevel(xpPerSuccessfulDay * 3),
      currentStreak: 3,
      longestStreak: 3,
      lastEvaluatedDate: day1,
    );

    final result = await evaluatePendingDays(
      state: state,
      asOf: day3,
      wasDaySuccessful: (day) async => false,
    );

    expect(result.currentStreak, 0);
    expect(result.longestStreak, 3);
    expect(result.currentXp, xpPerSuccessfulDay * 3);
  });

  test('replays multiple missed days in order, one at a time', () async {
    final state = stateEndingOn(day1);

    final result = await evaluatePendingDays(
      state: state,
      asOf: day4,
      wasDaySuccessful: (day) async => day != day3, // day2 ok, day3 missed
    );

    expect(result.currentStreak, 0); // broke on day3, nothing since
    expect(result.longestStreak, 1); // day2 alone was the best run
    expect(result.currentXp, xpPerSuccessfulDay); // only day2 counted
    expect(result.lastEvaluatedDate, day3);
  });
}
