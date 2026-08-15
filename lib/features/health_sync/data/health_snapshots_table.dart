import 'package:drift/drift.dart';

@DataClassName('HealthSnapshotRow')
class HealthSnapshots extends Table {
  DateTimeColumn get date => dateTime()();
  IntColumn get steps => integer().withDefault(const Constant(0))();
  IntColumn get workoutsCompleted => integer().withDefault(const Constant(0))();
  DateTimeColumn get syncedAt => dateTime()();
  IntColumn get caloriesConsumed => integer().nullable()();
  RealColumn get proteinGrams => real().nullable()();
  RealColumn get carbsGrams => real().nullable()();
  RealColumn get fatGrams => real().nullable()();

  @override
  Set<Column> get primaryKey => {date};
}
