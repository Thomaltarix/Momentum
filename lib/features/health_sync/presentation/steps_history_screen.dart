import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../domain/daily_goals.dart';
import '../domain/daily_steps.dart';
import 'health_sync_providers.dart';
import 'steps_ring.dart';

class StepsHistoryScreen extends ConsumerStatefulWidget {
  const StepsHistoryScreen({super.key});

  @override
  ConsumerState<StepsHistoryScreen> createState() =>
      _StepsHistoryScreenState();
}

class _StepsHistoryScreenState extends ConsumerState<StepsHistoryScreen> {
  static const _dayLetters = ['L', 'M', 'M', 'J', 'V', 'S', 'D'];

  List<DailySteps>? _history;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final history = await ref
        .read(healthSyncRepositoryProvider)
        .fetchStepsHistory(7);
    if (mounted) setState(() => _history = history);
  }

  @override
  Widget build(BuildContext context) {
    final history = _history;
    final int goal =
        (ref.watch(dailyGoalsProvider).valueOrNull ?? DailyGoals.defaults)
            .stepGoal;

    return Scaffold(
      appBar: AppBar(title: const Text('Pas')),
      body: history == null
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Center(
                  child: StepsRing(
                    steps: history.last.steps,
                    goal: goal,
                    size: 160,
                    strokeWidth: 12,
                  ),
                ),
                const SizedBox(height: 32),
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '7 derniers jours',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 140,
                        child: _StepsBarChart(history: history, goal: goal),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Historique',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                ...history.reversed.map(
                  (day) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              _formatDay(day.date),
                              style: const TextStyle(
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                          Text(
                            '${day.steps}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          if (day.steps >= goal) ...[
                            const SizedBox(width: 8),
                            const Icon(
                              Icons.check_circle,
                              size: 16,
                              color: AppColors.success,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  String _formatDay(DateTime date) {
    final today = DateTime.now();
    final normalizedToday = DateTime(today.year, today.month, today.day);
    if (date == normalizedToday) return 'Aujourd\'hui';
    if (date == normalizedToday.subtract(const Duration(days: 1))) {
      return 'Hier';
    }
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}';
  }
}

class _StepsBarChart extends StatelessWidget {
  const _StepsBarChart({required this.history, required this.goal});

  final List<DailySteps> history;
  final int goal;

  @override
  Widget build(BuildContext context) {
    final maxSteps = history.fold<int>(
      goal,
      (max, day) => day.steps > max ? day.steps : max,
    );

    return BarChart(
      BarChartData(
        maxY: maxSteps * 1.15,
        alignment: BarChartAlignment.spaceAround,
        gridData: const FlGridData(show: false),
        borderData: FlBorderData(show: false),
        barTouchData: BarTouchData(enabled: false),
        titlesData: FlTitlesData(
          leftTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 24,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                final label = index >= 0 && index < history.length
                    ? _StepsHistoryScreenState._dayLetters[history[index]
                              .date
                              .weekday -
                          1]
                    : '';
                return Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    label,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        barGroups: [
          for (int i = 0; i < history.length; i++)
            BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  toY: history[i].steps.toDouble(),
                  color: history[i].steps >= goal
                      ? AppColors.accent
                      : AppColors.border,
                  width: 18,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
