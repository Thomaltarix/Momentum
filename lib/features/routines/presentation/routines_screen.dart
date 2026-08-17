import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../gamification/presentation/badges_screen.dart';
import '../../gamification/presentation/gamification_status_strip.dart';
import '../../health_sync/presentation/goals_screen.dart';
import '../../health_sync/presentation/status_screen.dart';
import '../../health_sync/presentation/today_summary_card.dart';
import '../domain/routine.dart';
import '../domain/routine_schedule.dart';
import 'add_routine_screen.dart';
import 'routines_providers.dart';

class RoutinesScreen extends ConsumerWidget {
  const RoutinesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final routinesAsync = ref.watch(routinesProvider);
    final completedAsync = ref.watch(todayCompletedRoutineIdsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Momentum'),
        actions: [
          IconButton(
            icon: const Icon(Icons.flag_outlined),
            tooltip: 'Objectifs',
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const GoalsScreen()),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.monitor_weight_outlined),
            tooltip: 'Statut',
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const StatusScreen()),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: IconButton(
              icon: const Icon(Icons.emoji_events_outlined),
              tooltip: 'Badges',
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const BadgesScreen()),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          const GamificationStatusStrip(),
          const TodaySummaryCard(),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
            child: Row(
              children: const [
                Text(
                  'Routines',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: routinesAsync.when(
              data: (routines) {
                final today = DateTime.now();
                final dueToday = routines
                    .where((routine) => isRoutineDueOn(routine, today))
                    .toList()
                  ..sort(
                    (a, b) => (a.scheduledTime ?? '').compareTo(
                      b.scheduledTime ?? '',
                    ),
                  );

                if (dueToday.isEmpty) {
                  return const Center(
                    child: Text(
                      'Aucune routine aujourd\'hui.',
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                  );
                }

                final completedIds = completedAsync.value ?? const <int>{};

                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                  itemCount: dueToday.length,
                  itemBuilder: (context, index) {
                    final routine = dueToday[index];
                    final isCompleted = completedIds.contains(routine.id);
                    return _RoutineTile(
                      routine: routine,
                      isCompleted: isCompleted,
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stackTrace) => Center(
                child: Text(
                  'Erreur: $error',
                  style: const TextStyle(color: AppColors.danger),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const AddRoutineScreen()),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _RoutineTile extends ConsumerWidget {
  const _RoutineTile({required this.routine, required this.isCompleted});

  final Routine routine;
  final bool isCompleted;

  void _toggle(WidgetRef ref) {
    final repository = ref.read(routinesRepositoryProvider);
    final today = DateTime.now();
    if (isCompleted) {
      repository.markIncomplete(routine.id, today);
    } else {
      repository.markCompleted(routine.id, today);
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
            onTap: () => _toggle(ref),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  _CheckCircle(checked: isCompleted),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          routine.title,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: isCompleted
                                ? FontWeight.w400
                                : FontWeight.w500,
                            color: isCompleted
                                ? AppColors.textSecondary
                                : AppColors.textPrimary,
                          ),
                        ),
                        if (routine.scheduledTime != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            routine.scheduledTime!,
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ],
                    ),
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

class _CheckCircle extends StatelessWidget {
  const _CheckCircle({required this.checked});

  final bool checked;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: checked ? AppColors.accent : Colors.transparent,
        border: checked
            ? null
            : Border.all(color: AppColors.border, width: 1.5),
      ),
      child: checked
          ? const Icon(Icons.check, size: 14, color: AppColors.accentOn)
          : null,
    );
  }
}
