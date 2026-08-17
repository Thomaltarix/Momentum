import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/notifications/notification_service.dart';
import '../../../core/theme/app_colors.dart';
import '../domain/routine.dart';
import '../domain/routine_recurrence.dart';
import 'add_routine_screen.dart';
import 'routines_providers.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool? _notificationsEnabled;

  @override
  void initState() {
    super.initState();
    _checkNotifications();
  }

  Future<void> _checkNotifications() async {
    final enabled = await ref.read(notificationServiceProvider).hasPermission();
    if (mounted) setState(() => _notificationsEnabled = enabled);
  }

  Future<void> _enableNotifications() async {
    await ref.read(notificationServiceProvider).requestPermission();
    await _checkNotifications();
  }

  static const _sectionTitleStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  @override
  Widget build(BuildContext context) {
    final routinesAsync = ref.watch(routinesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Réglages')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text('Notifications', style: _sectionTitleStyle),
          const SizedBox(height: 12),
          _NotificationStatusRow(
            enabled: _notificationsEnabled,
            onEnable: _enableNotifications,
          ),
          const SizedBox(height: 28),
          const Text('Routines', style: _sectionTitleStyle),
          const SizedBox(height: 12),
          routinesAsync.when(
            data: (routines) {
              if (routines.isEmpty) {
                return const Text(
                  'Aucune routine pour l\'instant.',
                  style: TextStyle(color: AppColors.textSecondary),
                );
              }
              return Column(
                children: routines
                    .map((routine) => _SettingsRoutineTile(routine: routine))
                    .toList(),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => Text(
              'Erreur: $error',
              style: const TextStyle(color: AppColors.danger),
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationStatusRow extends StatelessWidget {
  const _NotificationStatusRow({required this.enabled, required this.onEnable});

  final bool? enabled;
  final VoidCallback onEnable;

  @override
  Widget build(BuildContext context) {
    if (enabled == null) {
      return const SizedBox(
        height: 56,
        child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(
            enabled!
                ? Icons.notifications_active_outlined
                : Icons.notifications_off_outlined,
            color: enabled! ? AppColors.success : AppColors.textSecondary,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              enabled! ? 'Notifications activées' : 'Notifications désactivées',
              style: const TextStyle(color: AppColors.textPrimary),
            ),
          ),
          if (!enabled!)
            TextButton(onPressed: onEnable, child: const Text('Réactiver')),
        ],
      ),
    );
  }
}

class _SettingsRoutineTile extends ConsumerWidget {
  const _SettingsRoutineTile({required this.routine});

  final Routine routine;

  static const _dayLabels = {
    DateTime.monday: 'Lun',
    DateTime.tuesday: 'Mar',
    DateTime.wednesday: 'Mer',
    DateTime.thursday: 'Jeu',
    DateTime.friday: 'Ven',
    DateTime.saturday: 'Sam',
    DateTime.sunday: 'Dim',
  };

  String get _recurrenceLabel {
    switch (routine.recurrence) {
      case RoutineRecurrence.daily:
        return 'Tous les jours';
      case RoutineRecurrence.weekdays:
        return 'Semaine';
      case RoutineRecurrence.custom:
        final days = [...?routine.customDays]..sort();
        return days.map((day) => _dayLabels[day]).join(', ');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Dismissible(
        key: ValueKey(routine.id),
        direction: DismissDirection.endToStart,
        background: Container(
          decoration: BoxDecoration(
            color: AppColors.danger.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(16),
          ),
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: const Icon(Icons.delete_outline, color: AppColors.danger),
        ),
        onDismissed: (_) =>
            ref.read(routinesRepositoryProvider).deleteRoutine(routine.id),
        child: Material(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => AddRoutineScreen.edit(routine)),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          routine.title,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${routine.scheduledTime ?? ''} · $_recurrenceLabel',
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right,
                    size: 20,
                    color: AppColors.textSecondary,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
