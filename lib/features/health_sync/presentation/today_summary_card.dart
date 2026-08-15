import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/health_snapshot.dart';
import '../domain/step_goal.dart';
import 'health_sync_providers.dart';

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
      return Card(
        margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        child: ListTile(
          title: const Text('Connecter Health Connect'),
          subtitle: const Text(
            'Pour voir tes pas, séances et calories ici.',
          ),
          trailing: _busy
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.chevron_right),
          onTap: _busy ? null : _connect,
        ),
      );
    }

    final snapshotAsync = ref.watch(todayHealthSnapshotProvider);

    return Card(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: snapshotAsync.when(
          data: (snapshot) => _SummaryRow(
            snapshot: snapshot,
            busy: _busy,
            onRefresh: _refresh,
          ),
          loading: () => const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (error, _) => Text('Erreur: $error'),
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
    final steps = snapshot?.steps ?? 0;
    final workoutDone = (snapshot?.workoutsCompleted ?? 0) > 0;
    final calories = snapshot?.caloriesConsumed;

    return Row(
      children: [
        Expanded(
          child: _Stat(
            label: 'Pas',
            value: '$steps / $defaultDailyStepGoal',
          ),
        ),
        Expanded(
          child: _Stat(label: 'Séance', value: workoutDone ? 'Faite' : '—'),
        ),
        Expanded(
          child: _Stat(
            label: 'Calories',
            value: calories != null ? '$calories kcal' : '—',
          ),
        ),
        IconButton(
          icon: busy
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.refresh),
          onPressed: busy ? null : onRefresh,
        ),
      ],
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodySmall),
        Text(value, style: Theme.of(context).textTheme.titleMedium),
      ],
    );
  }
}
