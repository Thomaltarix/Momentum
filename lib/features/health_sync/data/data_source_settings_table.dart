import 'package:drift/drift.dart';

// Single row, always at id 0 — one source choice per metric, same rationale
// as GamificationStates (there's only ever one user). Stored as plain text
// rather than textEnum so an unset/legacy value defaults cleanly to
// "healthConnect" without a Drift enum-default subtlety.
@DataClassName('DataSourceSettingRow')
class DataSourceSettings extends Table {
  IntColumn get id => integer().withDefault(const Constant(0))();
  TextColumn get weightSource =>
      text().withDefault(const Constant('healthConnect'))();
  TextColumn get workoutSource =>
      text().withDefault(const Constant('healthConnect'))();
  TextColumn get nutritionSource =>
      text().withDefault(const Constant('healthConnect'))();

  @override
  Set<Column> get primaryKey => {id};
}
