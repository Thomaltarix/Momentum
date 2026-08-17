import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../domain/daily_nutrition.dart';
import 'health_sync_providers.dart';

/// Add or edit a day's manually-entered nutrition total. A raw daily number,
/// not a food diary — Momentum doesn't build its own nutrition database (see
/// claude/CLAUDE.md). Editing re-saves the same date (one entry per day,
/// upsert — see NutritionEntries table), so this screen doubles as both.
class AddNutritionEntryScreen extends ConsumerStatefulWidget {
  const AddNutritionEntryScreen({super.key, this.existing});

  final DailyNutrition? existing;

  @override
  ConsumerState<AddNutritionEntryScreen> createState() =>
      _AddNutritionEntryScreenState();
}

class _AddNutritionEntryScreenState
    extends ConsumerState<AddNutritionEntryScreen> {
  late DateTime _date = widget.existing?.date ?? DateTime.now();
  late final _caloriesController = TextEditingController(
    text: widget.existing?.calories?.toString() ?? '',
  );
  late final _proteinController = TextEditingController(
    text: _formatGrams(widget.existing?.proteinGrams),
  );
  late final _carbsController = TextEditingController(
    text: _formatGrams(widget.existing?.carbsGrams),
  );
  late final _fatController = TextEditingController(
    text: _formatGrams(widget.existing?.fatGrams),
  );

  static String _formatGrams(double? grams) =>
      grams == null ? '' : grams.toStringAsFixed(0);

  @override
  void dispose() {
    _caloriesController.dispose();
    _proteinController.dispose();
    _carbsController.dispose();
    _fatController.dispose();
    super.dispose();
  }

  int? get _parsedCalories => int.tryParse(_caloriesController.text.trim());

  bool get _canSave {
    final calories = _parsedCalories;
    return calories != null && calories > 0;
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _save() async {
    final calories = _parsedCalories;
    if (calories == null) return;

    await ref
        .read(healthSyncRepositoryProvider)
        .addManualNutritionEntry(
          date: _date,
          calories: calories,
          proteinGrams: double.tryParse(_proteinController.text.trim()),
          carbsGrams: double.tryParse(_carbsController.text.trim()),
          fatGrams: double.tryParse(_fatController.text.trim()),
        );

    if (mounted) Navigator.of(context).pop(true);
  }

  Future<void> _delete() async {
    final existing = widget.existing;
    if (existing == null) return;

    await ref
        .read(healthSyncRepositoryProvider)
        .deleteManualNutritionEntry(existing.date);

    if (mounted) Navigator.of(context).pop(true);
  }

  String _formatDate(DateTime date) =>
      '${date.day.toString().padLeft(2, '0')}/'
      '${date.month.toString().padLeft(2, '0')}/${date.year}';

  /// True only when there's an actual entry to edit/delete — tapping an
  /// empty day still passes an `existing` (to prefill the date) but with a
  /// null `calories`, which shouldn't offer a delete button for nothing.
  bool get _hasExistingData => widget.existing?.calories != null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _hasExistingData ? 'Modifier la journée' : 'Nouvelle journée',
        ),
        actions: [
          if (_hasExistingData)
            IconButton(onPressed: _delete, icon: const Icon(Icons.delete_outline)),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Material(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: _pickDate,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Date',
                        style: TextStyle(color: AppColors.textPrimary),
                      ),
                    ),
                    Text(
                      _formatDate(_date),
                      style: const TextStyle(
                        color: AppColors.accent,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.chevron_right,
                      color: AppColors.textSecondary,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Calories (kcal)',
            style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 6),
          TextField(
            controller: _caloriesController,
            keyboardType: TextInputType.number,
            style: const TextStyle(color: AppColors.textPrimary),
            decoration: const InputDecoration(hintText: 'ex : 2200'),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _MacroField(
                  label: 'Protéines (g)',
                  controller: _proteinController,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _MacroField(
                  label: 'Glucides (g)',
                  controller: _carbsController,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _MacroField(
                  label: 'Lipides (g)',
                  controller: _fatController,
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

class _MacroField extends StatelessWidget {
  const _MacroField({required this.label, required this.controller});

  final String label;
  final TextEditingController controller;

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
          keyboardType: TextInputType.number,
          style: const TextStyle(color: AppColors.textPrimary),
          decoration: const InputDecoration(hintText: '—'),
        ),
      ],
    );
  }
}
