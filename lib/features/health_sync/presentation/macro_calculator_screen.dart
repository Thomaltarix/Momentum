import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../domain/daily_goals.dart';
import '../domain/macro_calculator.dart';
import '../domain/macro_calculator_input.dart';
import 'health_sync_providers.dart';

/// Mifflin-St Jeor based macro calculator. Loads the last-used profile and
/// the current tracked weight, recomputes live as fields change, and can
/// apply the result straight onto DailyGoals (keeping stepGoal untouched —
/// see macro_calculator.dart).
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
    });
  }

  @override
  void dispose() {
    _ageController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  int? get _age => int.tryParse(_ageController.text.trim());
  double? get _weightKg =>
      double.tryParse(_weightController.text.trim().replaceAll(',', '.'));
  double? get _heightCm => double.tryParse(_heightController.text.trim());

  MacroTargets? get _targets {
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

  Future<void> _apply() async {
    final targets = _targets;
    if (targets == null) return;

    setState(() => _applying = true);
    final repository = ref.read(healthSyncRepositoryProvider);

    await repository.updateCalculatorProfile(
      MacroCalculatorProfile(
        sex: _sex,
        age: _age!,
        heightCm: _heightCm!,
        activityLevel: _activityLevel,
        objective: _objective,
      ),
    );

    final currentGoals = await repository.fetchGoals();
    await repository.updateGoals(
      DailyGoals(
        stepGoal: currentGoals.stepGoal,
        calorieGoal: targets.calorieGoal,
        proteinGoal: targets.proteinGoal,
        carbsGoal: targets.carbsGoal,
        fatGoal: targets.fatGoal,
      ),
    );

    if (mounted) Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final targets = _targets;

    return Scaffold(
      appBar: AppBar(title: const Text('Calculateur de macros')),
      body: !_loaded
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(20),
              children: [
                const Text(
                  'Basé sur la formule de Mifflin-St Jeor. Les protéines et lipides sont calculés par kilo de poids de corps, les glucides comblent le reste.',
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
                  onSelectionChanged: (selection) =>
                      setState(() => _sex = selection.first),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: _NumberField(
                        label: 'Âge',
                        controller: _ageController,
                        onChanged: () => setState(() {}),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _NumberField(
                        label: 'Poids (kg)',
                        controller: _weightController,
                        onChanged: () => setState(() {}),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _NumberField(
                        label: 'Taille (cm)',
                        controller: _heightController,
                        onChanged: () => setState(() {}),
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
                    if (value != null) setState(() => _activityLevel = value);
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
                  onSelectionChanged: (selection) =>
                      setState(() => _objective = selection.first),
                ),
                const SizedBox(height: 28),
                if (targets != null) _ResultCard(targets: targets),
                const SizedBox(height: 28),
                FilledButton(
                  onPressed: targets != null && !_applying ? _apply : null,
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

class _ResultCard extends StatelessWidget {
  const _ResultCard({required this.targets});

  final MacroTargets targets;

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
                Text(
                  '${targets.calorieGoal}',
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    color: AppColors.accent,
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
          _MacroLine(label: 'Protéines', grams: targets.proteinGoal),
          const SizedBox(height: 10),
          _MacroLine(label: 'Glucides', grams: targets.carbsGoal),
          const SizedBox(height: 10),
          _MacroLine(label: 'Lipides', grams: targets.fatGoal),
        ],
      ),
    );
  }
}

class _MacroLine extends StatelessWidget {
  const _MacroLine({required this.label, required this.grams});

  final String label;
  final double grams;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
        ),
        Text(
          '${grams.round()} g',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
