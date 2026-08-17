import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../domain/daily_goals.dart';
import '../domain/macro_calculator.dart';
import '../domain/macro_calculator_input.dart';
import 'health_sync_providers.dart';

/// Mifflin-St Jeor based macro calculator. Loads the last-used profile and
/// the current tracked weight, recomputes a suggestion live as profile
/// fields change, and lets the calories/macros themselves be edited by
/// hand before applying — the formula is a starting point, not the final
/// word (see _resultsEdited below).
class MacroCalculatorScreen extends ConsumerStatefulWidget {
  const MacroCalculatorScreen({super.key});

  @override
  ConsumerState<MacroCalculatorScreen> createState() =>
      _MacroCalculatorScreenState();
}

class _MacroCalculatorScreenState
    extends ConsumerState<MacroCalculatorScreen> {
  static const double _fallbackWeightKg = 70;

  Sex _sex = Sex.male;
  ActivityLevel _activityLevel = ActivityLevel.moderate;
  NutritionObjective _objective = NutritionObjective.maintain;
  final _ageController = TextEditingController();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();

  final _calorieGoalController = TextEditingController();
  final _proteinGoalController = TextEditingController();
  final _carbsGoalController = TextEditingController();
  final _fatGoalController = TextEditingController();

  /// True once the user has typed into one of the result fields directly —
  /// from then on, changing the profile no longer overwrites their edit.
  bool _resultsEdited = false;

  bool _loaded = false;
  bool _applying = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final repository = ref.read(healthSyncRepositoryProvider);
    final profile = await repository.fetchCalculatorProfile();
    final weightHistory = await repository.fetchWeightHistory(90);
    final double weightKg = weightHistory.isNotEmpty
        ? weightHistory.first.kilograms
        : _fallbackWeightKg;

    if (!mounted) return;
    setState(() {
      _sex = profile.sex;
      _activityLevel = profile.activityLevel;
      _objective = profile.objective;
      _ageController.text = profile.age.toString();
      _weightController.text = weightKg.toStringAsFixed(1).replaceAll(
        '.',
        ',',
      );
      _heightController.text = profile.heightCm.toStringAsFixed(0);
      _loaded = true;
      _syncResultFieldsToSuggestion();
    });
  }

  @override
  void dispose() {
    _ageController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    _calorieGoalController.dispose();
    _proteinGoalController.dispose();
    _carbsGoalController.dispose();
    _fatGoalController.dispose();
    super.dispose();
  }

  int? get _age => int.tryParse(_ageController.text.trim());
  double? get _weightKg =>
      double.tryParse(_weightController.text.trim().replaceAll(',', '.'));
  double? get _heightCm => double.tryParse(_heightController.text.trim());

  /// The live suggestion computed from the profile fields — shown as a
  /// reference, and used to seed the editable result fields until the user
  /// overrides them.
  MacroTargets? get _suggestion {
    final age = _age;
    final weightKg = _weightKg;
    final heightCm = _heightCm;
    if (age == null || age <= 0) return null;
    if (weightKg == null || weightKg <= 0) return null;
    if (heightCm == null || heightCm <= 0) return null;

    return computeMacroTargets(
      MacroCalculatorInput(
        sex: _sex,
        age: age,
        weightKg: weightKg,
        heightCm: heightCm,
        activityLevel: _activityLevel,
        objective: _objective,
      ),
    );
  }

  void _syncResultFieldsToSuggestion() {
    final suggestion = _suggestion;
    if (suggestion == null) return;
    _calorieGoalController.text = suggestion.calorieGoal.toString();
    _proteinGoalController.text = suggestion.proteinGoal.toStringAsFixed(0);
    _carbsGoalController.text = suggestion.carbsGoal.toStringAsFixed(0);
    _fatGoalController.text = suggestion.fatGoal.toStringAsFixed(0);
  }

  void _onProfileChanged() {
    setState(() {
      if (!_resultsEdited) _syncResultFieldsToSuggestion();
    });
  }

  void _resetResultsToSuggestion() {
    setState(() {
      _resultsEdited = false;
      _syncResultFieldsToSuggestion();
    });
  }

  int? get _calorieGoal => int.tryParse(_calorieGoalController.text.trim());
  double? get _proteinGoal =>
      double.tryParse(_proteinGoalController.text.trim());
  double? get _carbsGoal => double.tryParse(_carbsGoalController.text.trim());
  double? get _fatGoal => double.tryParse(_fatGoalController.text.trim());

  bool get _canApply =>
      (_calorieGoal ?? 0) > 0 &&
      (_proteinGoal ?? 0) > 0 &&
      (_carbsGoal ?? 0) > 0 &&
      (_fatGoal ?? 0) > 0;

  Future<void> _apply() async {
    if (!_canApply) return;

    setState(() => _applying = true);
    final repository = ref.read(healthSyncRepositoryProvider);

    final age = _age;
    final heightCm = _heightCm;
    if (age != null && heightCm != null) {
      await repository.updateCalculatorProfile(
        MacroCalculatorProfile(
          sex: _sex,
          age: age,
          heightCm: heightCm,
          activityLevel: _activityLevel,
          objective: _objective,
        ),
      );
    }

    final currentGoals = await repository.fetchGoals();
    await repository.updateGoals(
      DailyGoals(
        stepGoal: currentGoals.stepGoal,
        calorieGoal: _calorieGoal!,
        proteinGoal: _proteinGoal!,
        carbsGoal: _carbsGoal!,
        fatGoal: _fatGoal!,
      ),
    );

    if (mounted) Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final suggestion = _suggestion;

    return Scaffold(
      appBar: AppBar(title: const Text('Calculateur de macros')),
      body: !_loaded
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(20),
              children: [
                const Text(
                  'Basé sur la formule de Mifflin-St Jeor. Les protéines et lipides sont calculés par kilo de poids de corps, les glucides comblent le reste — ajuste librement le résultat avant d\'appliquer.',
                  style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Sexe',
                  style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                ),
                const SizedBox(height: 8),
                SegmentedButton<Sex>(
                  segments: const [
                    ButtonSegment(
                      value: Sex.male,
                      label: FittedBox(child: Text('Homme')),
                    ),
                    ButtonSegment(
                      value: Sex.female,
                      label: FittedBox(child: Text('Femme')),
                    ),
                  ],
                  selected: {_sex},
                  onSelectionChanged: (selection) {
                    _sex = selection.first;
                    _onProfileChanged();
                  },
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: _NumberField(
                        label: 'Âge',
                        controller: _ageController,
                        onChanged: _onProfileChanged,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _NumberField(
                        label: 'Poids (kg)',
                        controller: _weightController,
                        onChanged: _onProfileChanged,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _NumberField(
                        label: 'Taille (cm)',
                        controller: _heightController,
                        onChanged: _onProfileChanged,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                  'Niveau d\'activité',
                  style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                ),
                const SizedBox(height: 6),
                DropdownButtonFormField<ActivityLevel>(
                  initialValue: _activityLevel,
                  dropdownColor: AppColors.surface,
                  style: const TextStyle(color: AppColors.textPrimary),
                  items: ActivityLevel.values
                      .map(
                        (level) => DropdownMenuItem(
                          value: level,
                          child: Text(level.label),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value == null) return;
                    _activityLevel = value;
                    _onProfileChanged();
                  },
                ),
                const SizedBox(height: 4),
                Text(
                  _activityLevel.description,
                  style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Objectif',
                  style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                ),
                const SizedBox(height: 8),
                SegmentedButton<NutritionObjective>(
                  segments: const [
                    ButtonSegment(
                      value: NutritionObjective.loseWeight,
                      label: FittedBox(child: Text('Perte de poids')),
                    ),
                    ButtonSegment(
                      value: NutritionObjective.maintain,
                      label: FittedBox(child: Text('Maintien')),
                    ),
                    ButtonSegment(
                      value: NutritionObjective.gainMuscle,
                      label: FittedBox(child: Text('Prise de masse')),
                    ),
                  ],
                  selected: {_objective},
                  onSelectionChanged: (selection) {
                    _objective = selection.first;
                    _onProfileChanged();
                  },
                ),
                const SizedBox(height: 28),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Objectifs à appliquer',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    if (_resultsEdited && suggestion != null)
                      TextButton(
                        onPressed: _resetResultsToSuggestion,
                        child: const Text('Reprendre la suggestion'),
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                _EditableResultCard(
                  calorieController: _calorieGoalController,
                  proteinController: _proteinGoalController,
                  carbsController: _carbsGoalController,
                  fatController: _fatGoalController,
                  onChanged: () => setState(() => _resultsEdited = true),
                ),
                const SizedBox(height: 28),
                FilledButton(
                  onPressed: _canApply && !_applying ? _apply : null,
                  child: Text(
                    _applying ? 'Application...' : 'Appliquer aux objectifs',
                  ),
                ),
              ],
            ),
    );
  }
}

class _NumberField extends StatelessWidget {
  const _NumberField({
    required this.label,
    required this.controller,
    required this.onChanged,
  });

  final String label;
  final TextEditingController controller;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          style: const TextStyle(color: AppColors.textPrimary),
          onChanged: (_) => onChanged(),
        ),
      ],
    );
  }
}

class _EditableResultCard extends StatelessWidget {
  const _EditableResultCard({
    required this.calorieController,
    required this.proteinController,
    required this.carbsController,
    required this.fatController,
    required this.onChanged,
  });

  final TextEditingController calorieController;
  final TextEditingController proteinController;
  final TextEditingController carbsController;
  final TextEditingController fatController;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Column(
              children: [
                SizedBox(
                  width: 140,
                  child: TextField(
                    controller: calorieController,
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      color: AppColors.accent,
                    ),
                    decoration: const InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(vertical: 8),
                    ),
                    onChanged: (_) => onChanged(),
                  ),
                ),
                const Text(
                  'KCAL / JOUR',
                  style: TextStyle(
                    fontSize: 12,
                    letterSpacing: 1,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _MacroField(
            label: 'Protéines (g)',
            controller: proteinController,
            onChanged: onChanged,
          ),
          const SizedBox(height: 12),
          _MacroField(
            label: 'Glucides (g)',
            controller: carbsController,
            onChanged: onChanged,
          ),
          const SizedBox(height: 12),
          _MacroField(
            label: 'Lipides (g)',
            controller: fatController,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

class _MacroField extends StatelessWidget {
  const _MacroField({
    required this.label,
    required this.controller,
    required this.onChanged,
  });

  final String label;
  final TextEditingController controller;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
          ),
        ),
        SizedBox(
          width: 90,
          child: TextField(
            controller: controller,
            textAlign: TextAlign.end,
            keyboardType: TextInputType.number,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
            decoration: const InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.symmetric(vertical: 8),
            ),
            onChanged: (_) => onChanged(),
          ),
        ),
      ],
    );
  }
}
