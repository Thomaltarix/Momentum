import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../domain/weight_entry.dart';
import 'health_sync_providers.dart';

/// Add or edit a manually-entered weigh-in. Editing re-saves the same date
/// (weight is one entry per day, upsert — see WeightEntries table), so this
/// screen doubles as both.
class AddWeightEntryScreen extends ConsumerStatefulWidget {
  const AddWeightEntryScreen({super.key, this.existing});

  final WeightEntry? existing;

  @override
  ConsumerState<AddWeightEntryScreen> createState() =>
      _AddWeightEntryScreenState();
}

class _AddWeightEntryScreenState extends ConsumerState<AddWeightEntryScreen> {
  late final _weightController = TextEditingController(
    text: widget.existing == null
        ? ''
        : widget.existing!.kilograms.toStringAsFixed(1).replaceAll('.', ','),
  );
  late DateTime _date = widget.existing == null
      ? DateTime.now()
      : widget.existing!.date;

  @override
  void dispose() {
    _weightController.dispose();
    super.dispose();
  }

  double? get _parsedKilograms =>
      double.tryParse(_weightController.text.trim().replaceAll(',', '.'));

  bool get _canSave {
    final kg = _parsedKilograms;
    return kg != null && kg > 0;
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
    final kg = _parsedKilograms;
    if (kg == null) return;

    await ref
        .read(healthSyncRepositoryProvider)
        .addManualWeightEntry(date: _date, kilograms: kg);

    if (mounted) Navigator.of(context).pop(true);
  }

  Future<void> _delete() async {
    final existing = widget.existing;
    if (existing == null) return;

    await ref
        .read(healthSyncRepositoryProvider)
        .deleteManualWeightEntry(existing.date);

    if (mounted) Navigator.of(context).pop(true);
  }

  String _formatDate(DateTime date) =>
      '${date.day.toString().padLeft(2, '0')}/'
      '${date.month.toString().padLeft(2, '0')}/${date.year}';

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.existing != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Modifier la pesée' : 'Nouvelle pesée'),
        actions: [
          if (isEditing)
            IconButton(onPressed: _delete, icon: const Icon(Icons.delete_outline)),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Poids (kg)',
            style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 6),
          TextField(
            controller: _weightController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            style: const TextStyle(color: AppColors.textPrimary),
            decoration: const InputDecoration(hintText: 'ex : 75,2'),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 20),
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
