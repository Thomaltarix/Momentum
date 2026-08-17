import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../domain/daily_goals.dart';
import '../domain/health_snapshot.dart';
import 'health_sync_providers.dart';
import 'macro_bar.dart';
import 'nutrition_history_screen.dart';
import 'steps_history_screen.dart';
import 'steps_ring.dart';
import 'workouts_history_screen.dart';

class TodaySummaryCard extends ConsumerStatefulWidget {
  const TodaySummaryCard({super.key});

  @override
  ConsumerState<TodaySummaryCard> createState() => _TodaySummaryCardState();
}

class _TodaySummaryCardState extends ConsumerState<TodaySummaryCard> {
  bool? _hasPermissions;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _checkPermissions();
  }

  Future<void> _checkPermissions() async {
    final granted = await ref
        .read(healthSyncRepositoryProvider)
        .hasPermissions();
    if (!mounted) return;
    setState(() => _hasPermissions = granted);
    if (granted) await _refresh();
  }

  Future<void> _connect() async {
    setState(() => _busy = true);
    final granted = await ref
        .read(healthSyncRepositoryProvider)
        .requestPermissions();
    if (!mounted) return;
    setState(() {
      _hasPermissions = granted;
      _busy = false;
    });
    if (granted) await _refresh();
  }

  Future<void> _refresh() async {
    setState(() => _busy = true);
    await ref.read(healthSyncRepositoryProvider).refreshToday();
    if (mounted) setState(() => _busy = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_hasPermissions == null) {
      return const SizedBox.shrink();
    }

    if (!_hasPermissions!) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: Material(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: _busy ? null : _connect,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Connecter Health Connect',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Pour voir tes pas, séances et calories ici.',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _busy
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(
                          Icons.chevron_right,
                          color: AppColors.textSecondary,
                        ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    final snapshotAsync = ref.watch(todayHealthSnapshotProvider);
    final DailyGoals goals =
        ref.watch(dailyGoalsProvider).valueOrNull ?? DailyGoals.defaults;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
        ),
        child: snapshotAsync.when(
          data: (snapshot) => _SummaryRow(snapshot: snapshot, goals: goals),
          loading: () => const Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (error, _) =>
              Text('Erreur: $error', style: const TextStyle(color: AppColors.danger)),
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.snapshot, required this.goals});

  final HealthSnapshot? snapshot;
  final DailyGoals goals;

  @override
  Widget build(BuildContext context) {
    final int steps = snapshot?.steps ?? 0;
    final bool workoutDone = (snapshot?.workoutsCompleted ?? 0) > 0;
    final int? caloriesBurned = snapshot?.caloriesBurned;
    final int? caloriesConsumed = snapshot?.caloriesConsumed;

    void openWorkouts() => Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const WorkoutsHistoryScreen()),
    );
    void openNutrition() => Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const NutritionHistoryScreen()),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const StepsHistoryScreen()),
              ),
              child: StepsRing(steps: steps, goal: goals.stepGoal),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _StatRow(
                    label: 'Séance',
                    value: workoutDone ? 'Faite' : '—',
                    showCheck: workoutDone,
                    onTap: openWorkouts,
                  ),
                  const SizedBox(height: 14),
                  _StatRow(
                    label: 'Dépensées',
                    value: caloriesBurned != null ? '$caloriesBurned kcal' : '—',
                    onTap: openWorkouts,
                  ),
                  const SizedBox(height: 14),
                  _StatRow(
                    label: 'Consommées',
                    value: caloriesConsumed != null
                        ? '$caloriesConsumed / ${goals.calorieGoal} kcal'
                        : '—',
                    onTap: openNutrition,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        const Divider(height: 1),
        const SizedBox(height: 20),
        GestureDetector(
          onTap: openNutrition,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MacroBar(
                label: 'Protéines',
                grams: snapshot?.proteinGrams,
                maxGrams: goals.proteinGoal,
              ),
              const SizedBox(height: 12),
              MacroBar(
                label: 'Glucides',
                grams: snapshot?.carbsGrams,
                maxGrams: goals.carbsGoal,
              ),
              const SizedBox(height: 12),
              MacroBar(
                label: 'Lipides',
                grams: snapshot?.fatGrams,
                maxGrams: goals.fatGoal,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _StatRow extends StatelessWidget {
  const _StatRow({
    required this.label,
    required this.value,
    this.showCheck = false,
    this.onTap,
  });

  final String label;
  final String value;
  final bool showCheck;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final row = Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
          ),
        ),
        if (showCheck) ...[
          const Icon(Icons.check, size: 14, color: AppColors.success),
          const SizedBox(width: 6),
        ],
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );

    if (onTap == null) return row;
    return GestureDetector(onTap: onTap, child: row);
  }
}
