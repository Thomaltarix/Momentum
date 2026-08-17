import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../domain/daily_goals.dart';
import 'health_sync_providers.dart';

/// Edits the daily targets shown on the home summary card and in the
/// Nutrition/Pas history screens — replaces the fixed placeholders that
/// used to be hardcoded there.
class GoalsScreen extends ConsumerStatefulWidget {
  const GoalsScreen({super.key});

  @override
  ConsumerState<GoalsScreen> createState() => _GoalsScreenState();
}

class _GoalsScreenState extends ConsumerState<GoalsScreen> {
  final _stepController = TextEditingController();
  final _calorieController = TextEditingController();
  final _proteinController = TextEditingController();
  final _carbsController = TextEditingController();
  final _fatController = TextEditingController();
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final goals = await ref.read(healthSyncRepositoryProvider).fetchGoals();
    if (!mounted) return;
    _stepController.text = goals.stepGoal.toString();
    _calorieController.text = goals.calorieGoal.toString();
    _proteinController.text = goals.proteinGoal.toStringAsFixed(0);
    _carbsController.text = goals.carbsGoal.toStringAsFixed(0);
    _fatController.text = goals.fatGoal.toStringAsFixed(0);
    setState(() => _loaded = true);
  }

  @override
  void dispose() {
    _stepController.dispose();
    _calorieController.dispose();
    _proteinController.dispose();
    _carbsController.dispose();
    _fatController.dispose();
    super.dispose();
  }

  int? get _steps => int.tryParse(_stepController.text.trim());
  int? get _calories => int.tryParse(_calorieController.text.trim());
  double? get _protein => double.tryParse(_proteinController.text.trim());
  double? get _carbs => double.tryParse(_carbsController.text.trim());
  double? get _fat => double.tryParse(_fatController.text.trim());

  bool get _canSave =>
      (_steps ?? 0) > 0 &&
      (_calories ?? 0) > 0 &&
      (_protein ?? 0) > 0 &&
      (_carbs ?? 0) > 0 &&
      (_fat ?? 0) > 0;

  Future<void> _save() async {
    await ref
        .read(healthSyncRepositoryProvider)
        .updateGoals(
          DailyGoals(
            stepGoal: _steps!,
            calorieGoal: _calories!,
            proteinGoal: _protein!,
            carbsGoal: _carbs!,
            fatGoal: _fat!,
          ),
        );
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Objectifs')),
      body: !_loaded
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(20),
              children: [
                const Text(
                  'Ces valeurs remplacent les repères par défaut sur l\'accueil et les écrans Pas/Nutrition.',
                  style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                ),
                const SizedBox(height: 24),
                _GoalField(
                  label: 'Pas par jour',
                  controller: _stepController,
                  hint: 'ex : 5000',
                  onChanged: () => setState(() {}),
                ),
                const SizedBox(height: 20),
                _GoalField(
                  label: 'Calories (kcal)',
                  controller: _calorieController,
                  hint: 'ex : 2200',
                  onChanged: () => setState(() {}),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: _GoalField(
                        label: 'Protéines (g)',
                        controller: _proteinController,
                        hint: '—',
                        onChanged: () => setState(() {}),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _GoalField(
                        label: 'Glucides (g)',
                        controller: _carbsController,
                        hint: '—',
                        onChanged: () => setState(() {}),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _GoalField(
                        label: 'Lipides (g)',
                        controller: _fatController,
                        hint: '—',
                        onChanged: () => setState(() {}),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                FilledButton(
                  onPressed: _canSave ? _save : null,
                  child: const Text('Enregistrer'),
                ),
              ],
            ),
    );
  }
}

class _GoalField extends StatelessWidget {
  const _GoalField({
    required this.label,
    required this.controller,
    required this.hint,
    required this.onChanged,
  });

  final String label;
  final TextEditingController controller;
  final String hint;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          style: const TextStyle(color: AppColors.textPrimary),
          decoration: InputDecoration(hintText: hint),
          onChanged: (_) => onChanged(),
        ),
      ],
    );
  }
}
