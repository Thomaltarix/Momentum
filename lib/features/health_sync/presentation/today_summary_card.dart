import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../domain/health_snapshot.dart';
import '../domain/step_goal.dart';
import 'health_sync_providers.dart';
import 'steps_ring.dart';

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

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
        ),
        child: snapshotAsync.when(
          data: (snapshot) =>
              _SummaryRow(snapshot: snapshot, busy: _busy, onRefresh: _refresh),
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
  const _SummaryRow({
    required this.snapshot,
    required this.busy,
    required this.onRefresh,
  });

  final HealthSnapshot? snapshot;
  final bool busy;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    final int steps = snapshot?.steps ?? 0;
    final bool workoutDone = (snapshot?.workoutsCompleted ?? 0) > 0;
    final int? calories = snapshot?.caloriesConsumed;

    return Stack(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            StepsRing(steps: steps, goal: defaultDailyStepGoal),
            const SizedBox(width: 24),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _StatRow(
                    label: 'Séance',
                    value: workoutDone ? 'Faite' : '—',
                    showCheck: workoutDone,
                  ),
                  const SizedBox(height: 14),
                  _StatRow(
                    label: 'Calories',
                    value: calories != null ? '$calories kcal' : '—',
                  ),
                ],
              ),
            ),
          ],
        ),
        Positioned(
          top: -4,
          right: -4,
          child: busy
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : IconButton(
                  visualDensity: VisualDensity.compact,
                  icon: const Icon(Icons.refresh, size: 18),
                  color: AppColors.textSecondary,
                  style: const ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(Colors.transparent),
                  ),
                  onPressed: onRefresh,
                ),
        ),
      ],
    );
  }
}

class _StatRow extends StatelessWidget {
  const _StatRow({required this.label, required this.value, this.showCheck = false});

  final String label;
  final String value;
  final bool showCheck;

  @override
  Widget build(BuildContext context) {
    return Row(
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
  }
}
