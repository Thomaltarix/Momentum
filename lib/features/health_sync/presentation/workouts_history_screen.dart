import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../domain/workout_category.dart';
import '../domain/workout_entry.dart';
import 'health_sync_providers.dart';

class WorkoutsHistoryScreen extends ConsumerStatefulWidget {
  const WorkoutsHistoryScreen({super.key});

  @override
  ConsumerState<WorkoutsHistoryScreen> createState() =>
      _WorkoutsHistoryScreenState();
}

class _WorkoutsHistoryScreenState extends ConsumerState<WorkoutsHistoryScreen> {
  List<WorkoutEntry>? _workouts;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final workouts = await ref
        .read(healthSyncRepositoryProvider)
        .fetchWorkoutsHistory(30);
    if (mounted) setState(() => _workouts = workouts);
  }

  String _groupLabel(DateTime date) {
    final today = DateTime.now();
    final normalizedToday = DateTime(today.year, today.month, today.day);
    final normalizedDate = DateTime(date.year, date.month, date.day);
    if (normalizedDate == normalizedToday) return 'Aujourd\'hui';
    if (normalizedDate == normalizedToday.subtract(const Duration(days: 1))) {
      return 'Hier';
    }
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}';
  }

  IconData _iconFor(WorkoutCategory category) {
    switch (category) {
      case WorkoutCategory.running:
        return Icons.directions_run;
      case WorkoutCategory.walking:
        return Icons.directions_walk;
      case WorkoutCategory.hiking:
        return Icons.terrain;
      case WorkoutCategory.cycling:
        return Icons.directions_bike;
      case WorkoutCategory.swimming:
        return Icons.pool;
      case WorkoutCategory.strength:
        return Icons.fitness_center;
      case WorkoutCategory.yoga:
        return Icons.self_improvement;
      case WorkoutCategory.rowing:
        return Icons.rowing;
      case WorkoutCategory.cardio:
        return Icons.favorite;
      case WorkoutCategory.other:
        return Icons.sports_gymnastics;
    }
  }

  @override
  Widget build(BuildContext context) {
    final workouts = _workouts;

    return Scaffold(
      appBar: AppBar(title: const Text('Séances')),
      body: workouts == null
          ? const Center(child: CircularProgressIndicator())
          : workouts.isEmpty
          ? const Center(
              child: Text(
                'Aucune séance sur les 30 derniers jours.',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(20),
              children: _buildGroupedList(workouts),
            ),
    );
  }

  List<Widget> _buildGroupedList(List<WorkoutEntry> workouts) {
    final widgets = <Widget>[];
    String? lastGroup;

    for (final workout in workouts) {
      final group = _groupLabel(workout.start);
      if (group != lastGroup) {
        if (lastGroup != null) widgets.add(const SizedBox(height: 12));
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              group.toUpperCase(),
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
                letterSpacing: 0.5,
              ),
            ),
          ),
        );
        lastGroup = group;
      }

      final hour = workout.start.hour.toString().padLeft(2, '0');
      final minute = workout.start.minute.toString().padLeft(2, '0');

      widgets.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.border,
                  ),
                  child: Icon(
                    _iconFor(workout.category),
                    size: 20,
                    color: AppColors.accent,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        workout.label,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${workout.duration.inMinutes} min · $hour:$minute',
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                if (workout.caloriesBurned != null)
                  Text(
                    '${workout.caloriesBurned} kcal',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppColors.success,
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
    }

    return widgets;
  }
}
