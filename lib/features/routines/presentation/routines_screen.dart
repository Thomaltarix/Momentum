import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
      appBar: AppBar(title: const Text('Momentum')),
      body: routinesAsync.when(
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
            return const Center(child: Text('Aucune routine aujourd\'hui.'));
          }

          final completedIds = completedAsync.value ?? const <int>{};

          return ListView.builder(
            itemCount: dueToday.length,
            itemBuilder: (context, index) {
              final routine = dueToday[index];
              final isCompleted = completedIds.contains(routine.id);
              return _RoutineTile(routine: routine, isCompleted: isCompleted);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text('Erreur: $error')),
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Dismissible(
      key: ValueKey(routine.id),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Theme.of(context).colorScheme.errorContainer,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: const Icon(Icons.delete_outline),
      ),
      onDismissed: (_) =>
          ref.read(routinesRepositoryProvider).deleteRoutine(routine.id),
      child: CheckboxListTile(
        value: isCompleted,
        title: Text(routine.title),
        subtitle: Text(routine.scheduledTime ?? ''),
        onChanged: (value) {
          final repository = ref.read(routinesRepositoryProvider);
          final today = DateTime.now();
          if (value ?? false) {
            repository.markCompleted(routine.id, today);
          } else {
            repository.markIncomplete(routine.id, today);
          }
        },
      ),
    );
  }
}
