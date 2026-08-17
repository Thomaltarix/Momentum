import 'package:drift/drift.dart';

// Single row, always at id 0 — same rationale as GamificationStates and
// DataSourceSettings. Defaults match DailyGoals.defaults so a fresh row
// (via insertOnConflictUpdate) never leaves a column unset.
@DataClassName('GoalsRow')
class Goals extends Table {
  IntColumn get id => integer().withDefault(const Constant(0))();
  IntColumn get stepGoal => integer().withDefault(const Constant(5000))();
  IntColumn get calorieGoal => integer().withDefault(const Constant(2200))();
  RealColumn get proteinGoal => real().withDefault(const Constant(200))();
  RealColumn get carbsGoal => real().withDefault(const Constant(300))();
  RealColumn get fatGoal => real().withDefault(const Constant(100))();

  @override
  Set<Column> get primaryKey => {id};
}
