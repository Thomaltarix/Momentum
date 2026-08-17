import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../domain/workout_category.dart';
import '../domain/workout_entry.dart';
import 'health_sync_providers.dart';

/// Add or edit a manually-entered workout session. Duration is entered
/// directly in minutes rather than picking a start and end time — closer to
/// how someone actually remembers a session ("45 min of strength at 6pm").
class AddWorkoutEntryScreen extends ConsumerStatefulWidget {
  const AddWorkoutEntryScreen({super.key, this.existing});

  final WorkoutEntry? existing;

  @override
  ConsumerState<AddWorkoutEntryScreen> createState() =>
      _AddWorkoutEntryScreenState();
}

class _AddWorkoutEntryScreenState
    extends ConsumerState<AddWorkoutEntryScreen> {
  late WorkoutCategory _category =
      widget.existing?.category ?? WorkoutCategory.strength;
  late DateTime _date = widget.existing?.start ?? DateTime.now();
  late TimeOfDay _time = widget.existing == null
      ? TimeOfDay.now()
      : TimeOfDay.fromDateTime(widget.existing!.start);
  late final _durationController = TextEditingController(
    text: widget.existing == null
        ? ''
        : widget.existing!.duration.inMinutes.toString(),
  );
  late final _caloriesController = TextEditingController(
    text: widget.existing?.caloriesBurned?.toString() ?? '',
  );

  @override
  void dispose() {
    _durationController.dispose();
    _caloriesController.dispose();
    super.dispose();
  }

  int? get _parsedDuration => int.tryParse(_durationController.text.trim());

  bool get _canSave {
    final duration = _parsedDuration;
    return duration != null && duration > 0;
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

  Future<void> _pickTime() async {
    final picked = await showTimePicker(context: context, initialTime: _time);
    if (picked != null) setState(() => _time = picked);
  }

  Future<void> _save() async {
    final duration = _parsedDuration;
    if (duration == null) return;

    final start = DateTime(
      _date.year,
      _date.month,
      _date.day,
      _time.hour,
      _time.minute,
    );
    final end = start.add(Duration(minutes: duration));
    final calories = int.tryParse(_caloriesController.text.trim());
    final repository = ref.read(healthSyncRepositoryProvider);
    final existing = widget.existing;

    if (existing == null) {
      await repository.addManualWorkoutEntry(
        category: _category,
        start: start,
        end: end,
        caloriesBurned: calories,
      );
    } else {
      await repository.updateManualWorkoutEntry(
        id: existing.id!,
        category: _category,
        start: start,
        end: end,
        caloriesBurned: calories,
      );
    }

    if (mounted) Navigator.of(context).pop(true);
  }

  Future<void> _delete() async {
    final existing = widget.existing;
    if (existing == null) return;

    await ref
        .read(healthSyncRepositoryProvider)
        .deleteManualWorkoutEntry(existing.id!);

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
        title: Text(isEditing ? 'Modifier la séance' : 'Nouvelle séance'),
        actions: [
          if (isEditing)
            IconButton(onPressed: _delete, icon: const Icon(Icons.delete_outline)),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Type de séance',
            style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 6),
          DropdownButtonFormField<WorkoutCategory>(
            initialValue: _category,
            dropdownColor: AppColors.surface,
            style: const TextStyle(color: AppColors.textPrimary),
            items: WorkoutCategory.values
                .map(
                  (category) => DropdownMenuItem(
                    value: category,
                    child: Text(category.label),
                  ),
                )
                .toList(),
            onChanged: (value) {
              if (value != null) setState(() => _category = value);
            },
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _PickerTile(
                  label: 'Date',
                  value: _formatDate(_date),
                  onTap: _pickDate,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _PickerTile(
                  label: 'Heure',
                  value: _time.format(context),
                  onTap: _pickTime,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            'Durée (minutes)',
            style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 6),
          TextField(
            controller: _durationController,
            keyboardType: TextInputType.number,
            style: const TextStyle(color: AppColors.textPrimary),
            decoration: const InputDecoration(hintText: 'ex : 45'),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 20),
          const Text(
            'Calories brûlées (optionnel)',
            style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 6),
          TextField(
            controller: _caloriesController,
            keyboardType: TextInputType.number,
            style: const TextStyle(color: AppColors.textPrimary),
            decoration: const InputDecoration(hintText: 'ex : 320'),
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

class _PickerTile extends StatelessWidget {
  const _PickerTile({
    required this.label,
    required this.value,
    required this.onTap,
  });

  final String label;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  color: AppColors.accent,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
