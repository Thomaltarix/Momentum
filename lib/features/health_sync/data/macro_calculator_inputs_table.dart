import 'package:drift/drift.dart';

// Single row, always at id 0 — remembers the last values typed into
// MacroCalculatorScreen so reopening it doesn't start blank. Weight is
// deliberately not stored here: it's read live from weight tracking (see
// HealthSyncRepository.fetchWeightHistory) so it never drifts from the
// real tracked value.
//
// Enum columns are plain text (converted manually in the repository, like
// DataSourceSettings) rather than textEnum, to keep the withDefault clause
// simple and unambiguous.
@DataClassName('MacroCalculatorInputsRow')
class MacroCalculatorInputs extends Table {
  IntColumn get id => integer().withDefault(const Constant(0))();
  TextColumn get sex => text().withDefault(const Constant('male'))();
  IntColumn get age => integer().withDefault(const Constant(30))();
  RealColumn get heightCm => real().withDefault(const Constant(175))();
  TextColumn get activityLevel =>
      text().withDefault(const Constant('moderate'))();
  TextColumn get objective =>
      text().withDefault(const Constant('maintain'))();

  @override
  Set<Column> get primaryKey => {id};
}
