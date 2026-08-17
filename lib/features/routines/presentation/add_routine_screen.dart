import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/notifications/notification_service.dart';
import '../../../core/theme/app_colors.dart';
import '../domain/routine.dart';
import '../domain/routine_recurrence.dart';
import 'routines_providers.dart';

class AddRoutineScreen extends ConsumerStatefulWidget {
  const AddRoutineScreen({super.key})
    : existing = null,
      suggestedTitle = null,
      suggestedTime = null;

  /// Pre-fills every field from [routine] and saves via an update instead
  /// of an insert.
  const AddRoutineScreen.edit(Routine routine, {super.key})
    : existing = routine,
      suggestedTitle = null,
      suggestedTime = null;

  /// Pre-fills just the title/time (daily recurrence, the common case) —
  /// used by the home screen's first-run suggestions. Still a normal add;
  /// the user reviews/adjusts before saving, same as any other routine.
  const AddRoutineScreen.suggested({
    required String title,
    required TimeOfDay time,
    super.key,
  }) : existing = null,
       suggestedTitle = title,
       suggestedTime = time;

  final Routine? existing;
  final String? suggestedTitle;
  final TimeOfDay? suggestedTime;

  @override
  ConsumerState<AddRoutineScreen> createState() => _AddRoutineScreenState();
}

class _AddRoutineScreenState extends ConsumerState<AddRoutineScreen> {
  late final _titleController = TextEditingController(text: _initialTitle);
  late TimeOfDay _time = _initialTime;
  late RoutineRecurrence _recurrence = widget.existing?.recurrence ?? RoutineRecurrence.daily;
  late final Set<int> _customDays = {...?widget.existing?.customDays};

  bool get _isEditing => widget.existing != null;

  String get _initialTitle =>
      widget.existing?.title ?? widget.suggestedTitle ?? '';

  TimeOfDay get _initialTime {
    if (widget.existing?.scheduledTime case final String hhmm?) {
      final parts = hhmm.split(':');
      return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
    }
    return widget.suggestedTime ?? const TimeOfDay(hour: 8, minute: 0);
  }

  static const _dayLabels = {
    DateTime.monday: 'L',
    DateTime.tuesday: 'M',
    DateTime.wednesday: 'M',
    DateTime.thursday: 'J',
    DateTime.friday: 'V',
    DateTime.saturday: 'S',
    DateTime.sunday: 'D',
  };

  @override
  void initState() {
    super.initState();
    // Asked here, not at app launch, so the OS prompt has context: the user
    // just opened the screen for creating a reminder.
    ref.read(notificationServiceProvider).requestPermission();
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(context: context, initialTime: _time);
    if (picked != null) {
      setState(() => _time = picked);
    }
  }

  bool get _canSave =>
      _titleController.text.trim().isNotEmpty &&
      (_recurrence != RoutineRecurrence.custom || _customDays.isNotEmpty);

  Future<void> _save() async {
    final scheduledTime =
        '${_time.hour.toString().padLeft(2, '0')}:'
        '${_time.minute.toString().padLeft(2, '0')}';
    final title = _titleController.text.trim();
    final customDays = _recurrence == RoutineRecurrence.custom
        ? _customDays.toList()
        : null;

    final repository = ref.read(routinesRepositoryProvider);
    if (_isEditing) {
      await repository.updateRoutine(
        id: widget.existing!.id,
        title: title,
        scheduledTime: scheduledTime,
        recurrence: _recurrence,
        customDays: customDays,
      );
    } else {
      await repository.addRoutine(
        title: title,
        scheduledTime: scheduledTime,
        recurrence: _recurrence,
        customDays: customDays,
      );
    }

    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Modifier la routine' : 'Nouvelle routine'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Momentum te notifiera à l\'heure choisie pour cette routine.',
            style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 20),
          const Text(
            'Titre',
            style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 6),
          TextField(
            controller: _titleController,
            style: const TextStyle(color: AppColors.textPrimary),
            decoration: const InputDecoration(hintText: 'ex : Méditation'),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 20),
          Material(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: _pickTime,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Heure',
                        style: TextStyle(color: AppColors.textPrimary),
                      ),
                    ),
                    Text(
                      _time.format(context),
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
          const SizedBox(height: 24),
          const Text(
            'Récurrence',
            style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 8),
          SegmentedButton<RoutineRecurrence>(
            segments: const [
              ButtonSegment(
                value: RoutineRecurrence.daily,
                label: FittedBox(child: Text('Tous les jours')),
              ),
              ButtonSegment(
                value: RoutineRecurrence.weekdays,
                label: FittedBox(child: Text('Semaine')),
              ),
              ButtonSegment(
                value: RoutineRecurrence.custom,
                label: FittedBox(child: Text('Personnalisé')),
              ),
            ],
            selected: {_recurrence},
            onSelectionChanged: (selection) =>
                setState(() => _recurrence = selection.first),
          ),
          if (_recurrence == RoutineRecurrence.custom) ...[
            const SizedBox(height: 20),
            const Text(
              'Jours spécifiques',
              style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: _dayLabels.entries.map((entry) {
                final selected = _customDays.contains(entry.key);
                return _DayChip(
                  label: entry.value,
                  selected: selected,
                  onTap: () => setState(() {
                    if (selected) {
                      _customDays.remove(entry.key);
                    } else {
                      _customDays.add(entry.key);
                    }
                  }),
                );
              }).toList(),
            ),
          ],
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

class _DayChip extends StatelessWidget {
  const _DayChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      customBorder: const CircleBorder(),
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: selected ? AppColors.accent : AppColors.surface,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: selected ? AppColors.accentOn : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
