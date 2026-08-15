import 'package:drift/drift.dart';

// Single row, always at id 0 — there's only ever one user (see
// claude/data-model.md).
@DataClassName('GamificationStateRow')
class GamificationStates extends Table {
  IntColumn get id => integer().withDefault(const Constant(0))();
  IntColumn get currentXp => integer().withDefault(const Constant(0))();
  IntColumn get currentLevel => integer().withDefault(const Constant(1))();
  IntColumn get currentStreak => integer().withDefault(const Constant(0))();
  IntColumn get longestStreak => integer().withDefault(const Constant(0))();
  DateTimeColumn get lastEvaluatedDate => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('BadgeRow')
class Badges extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get code => text().unique()();
  DateTimeColumn get unlockedAt => dateTime()();
}
