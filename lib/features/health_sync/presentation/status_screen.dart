import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../domain/data_source_mode.dart';
import '../domain/weight_entry.dart';
import 'add_weight_entry_screen.dart';
import 'health_sync_providers.dart';
import 'data_source_toggle.dart';

class StatusScreen extends ConsumerStatefulWidget {
  const StatusScreen({super.key});

  @override
  ConsumerState<StatusScreen> createState() => _StatusScreenState();
}

class _StatusScreenState extends ConsumerState<StatusScreen> {
  List<WeightEntry>? _history;
  DataSourceMode _mode = DataSourceMode.healthConnect;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final repository = ref.read(healthSyncRepositoryProvider);
    final mode = await repository.fetchWeightSourceMode();
    final history = await repository.fetchWeightHistory(30);
    if (mounted) {
      setState(() {
        _mode = mode;
        _history = history;
      });
    }
  }

  Future<void> _setMode(DataSourceMode mode) async {
    await ref.read(healthSyncRepositoryProvider).setWeightSourceMode(mode);
    await _load();
  }

  Future<void> _openEntry([WeightEntry? existing]) async {
    final saved = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => AddWeightEntryScreen(existing: existing),
      ),
    );
    if (saved == true) await _load();
  }

  String _formatKg(double kg) => kg.toStringAsFixed(1).replaceAll('.', ',');

  String _formatDay(DateTime date) {
    final today = DateTime.now();
    final normalizedToday = DateTime(today.year, today.month, today.day);
    if (date == normalizedToday) return 'Aujourd\'hui';
    if (date == normalizedToday.subtract(const Duration(days: 1))) {
      return 'Hier';
    }
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final history = _history;
    final isManual = _mode == DataSourceMode.manual;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Statut'),
        actions: [
          if (isManual)
            IconButton(
              onPressed: () => _openEntry(),
              icon: const Icon(Icons.add),
            ),
        ],
      ),
      body: history == null
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(20),
              children: [
                DataSourceToggle(mode: _mode, onChanged: _setMode),
                const SizedBox(height: 20),
                if (history.isEmpty)
                  const Padding(
                    padding: EdgeInsets.only(top: 40),
                    child: Center(
                      child: Text(
                        'Aucune pesée enregistrée sur les 30 derniers jours.',
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                    ),
                  )
                else
                  _StatusBody(
                    history: history,
                    formatKg: _formatKg,
                    formatDay: _formatDay,
                    editable: isManual,
                    onTapEntry: _openEntry,
                  ),
              ],
            ),
    );
  }
}

class _StatusBody extends StatelessWidget {
  const _StatusBody({
    required this.history,
    required this.formatKg,
    required this.formatDay,
    required this.editable,
    required this.onTapEntry,
  });

  final List<WeightEntry> history;
  final String Function(double) formatKg;
  final String Function(DateTime) formatDay;
  final bool editable;
  final ValueChanged<WeightEntry> onTapEntry;

  @override
  Widget build(BuildContext context) {
    final latest = history.first;
    final double? delta = history.length > 1
        ? latest.kilograms - history[1].kilograms
        : null;
    final chronological = history.reversed.toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Poids actuel',
                style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 6),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${formatKg(latest.kilograms)} kg',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  if (delta != null) ...[
                    const SizedBox(width: 10),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: (delta < 0 ? AppColors.success : AppColors.border)
                              .withValues(alpha: delta < 0 ? 0.16 : 1),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              delta < 0 ? Icons.arrow_downward : Icons.arrow_upward,
                              size: 12,
                              color: delta < 0
                                  ? AppColors.success
                                  : AppColors.textSecondary,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              '${formatKg(delta.abs())} kg',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: delta < 0
                                    ? AppColors.success
                                    : AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(height: 140, child: _WeightLineChart(history: chronological)),
            ],
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'Historique des pesées',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        ...history.map(
          (entry) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Material(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: editable ? () => onTapEntry(entry) : null,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          formatDay(entry.date),
                          style: const TextStyle(color: AppColors.textPrimary),
                        ),
                      ),
                      Text(
                        '${formatKg(entry.kilograms)} kg',
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      if (editable) ...[
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.chevron_right,
                          color: AppColors.textSecondary,
                          size: 18,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _WeightLineChart extends StatelessWidget {
  const _WeightLineChart({required this.history});

  /// Chronological order (oldest first).
  final List<WeightEntry> history;

  @override
  Widget build(BuildContext context) {
    final spots = [
      for (int i = 0; i < history.length; i++)
        FlSpot(i.toDouble(), history[i].kilograms),
    ];

    return LineChart(
      LineChartData(
        gridData: const FlGridData(show: false),
        borderData: FlBorderData(show: false),
        titlesData: const FlTitlesData(show: false),
        lineTouchData: const LineTouchData(enabled: false),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: AppColors.accent,
            barWidth: 2.5,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, bar, index) =>
                  FlDotCirclePainter(
                    radius: index == spots.length - 1 ? 4 : 0,
                    color: AppColors.accent,
                    strokeWidth: 0,
                  ),
            ),
            belowBarData: BarAreaData(show: false),
          ),
        ],
      ),
    );
  }
}
