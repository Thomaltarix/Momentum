import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/notifications/notification_service.dart';
import '../domain/routine_recurrence.dart';
import 'routines_providers.dart';

class AddRoutineScreen extends ConsumerStatefulWidget {
  const AddRoutineScreen({super.key});

  @override
  ConsumerState<AddRoutineScreen> createState() => _AddRoutineScreenState();
}

class _AddRoutineScreenState extends ConsumerState<AddRoutineScreen> {
  final _titleController = TextEditingController();
  TimeOfDay _time = const TimeOfDay(hour: 8, minute: 0);
  RoutineRecurrence _recurrence = RoutineRecurrence.daily;
  final Set<int> _customDays = {};

  static const _dayLabels = {
    DateTime.monday: 'Lun',
    DateTime.tuesday: 'Mar',
    DateTime.wednesday: 'Mer',
    DateTime.thursday: 'Jeu',
    DateTime.friday: 'Ven',
    DateTime.saturday: 'Sam',
    DateTime.sunday: 'Dim',
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

    await ref
        .read(routinesRepositoryProvider)
        .addRoutine(
          title: _titleController.text.trim(),
          scheduledTime: scheduledTime,
          recurrence: _recurrence,
          customDays: _recurrence == RoutineRecurrence.custom
              ? _customDays.toList()
              : null,
        );

    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nouvelle routine')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Momentum te notifiera à l\'heure choisie pour cette routine.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(labelText: 'Titre'),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 24),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Heure'),
            trailing: Text(_time.format(context)),
            onTap: _pickTime,
          ),
          const SizedBox(height: 24),
          const Text('Récurrence'),
          const SizedBox(height: 8),
          SegmentedButton<RoutineRecurrence>(
            segments: const [
              ButtonSegment(
                value: RoutineRecurrence.daily,
                label: Text('Tous les jours'),
              ),
              ButtonSegment(
                value: RoutineRecurrence.weekdays,
                label: Text('Semaine'),
              ),
              ButtonSegment(
                value: RoutineRecurrence.custom,
                label: Text('Personnalisé'),
              ),
            ],
            selected: {_recurrence},
            onSelectionChanged: (selection) =>
                setState(() => _recurrence = selection.first),
          ),
          if (_recurrence == RoutineRecurrence.custom) ...[
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              children: _dayLabels.entries.map((entry) {
                final selected = _customDays.contains(entry.key);
                return FilterChip(
                  label: Text(entry.value),
                  selected: selected,
                  onSelected: (value) => setState(() {
                    if (value) {
                      _customDays.add(entry.key);
                    } else {
                      _customDays.remove(entry.key);
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
