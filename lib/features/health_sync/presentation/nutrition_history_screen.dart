import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../domain/daily_nutrition.dart';
import '../domain/data_source_mode.dart';
import 'add_nutrition_entry_screen.dart';
import 'data_source_toggle.dart';
import 'health_sync_providers.dart';
import 'macro_bar.dart';

class NutritionHistoryScreen extends ConsumerStatefulWidget {
  const NutritionHistoryScreen({super.key});

  @override
  ConsumerState<NutritionHistoryScreen> createState() =>
      _NutritionHistoryScreenState();
}

class _NutritionHistoryScreenState
    extends ConsumerState<NutritionHistoryScreen> {
  List<DailyNutrition>? _history;
  DataSourceMode _mode = DataSourceMode.healthConnect;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final repository = ref.read(healthSyncRepositoryProvider);
    final mode = await repository.fetchNutritionSourceMode();
    final history = await repository.fetchNutritionHistory(14);
    if (mounted) {
      setState(() {
        _mode = mode;
        _history = history;
      });
    }
  }

  Future<void> _setMode(DataSourceMode mode) async {
    await ref.read(healthSyncRepositoryProvider).setNutritionSourceMode(mode);
    await _load();
  }

  Future<void> _openEntry([DailyNutrition? existing]) async {
    final saved = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => AddNutritionEntryScreen(existing: existing),
      ),
    );
    if (saved == true) await _load();
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

  @override
  Widget build(BuildContext context) {
    final history = _history;
    final isManual = _mode == DataSourceMode.manual;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nutrition'),
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
          : Builder(
              builder: (context) {
                final today = history.first;
                return ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    DataSourceToggle(mode: _mode, onChanged: _setMode),
                    const SizedBox(height: 20),
                    InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: isManual ? () => _openEntry(today) : null,
                      child: Center(
                        child: Column(
                          children: [
                            Text(
                              today.calories?.toString() ?? '—',
                              style: const TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.w700,
                                color: AppColors.accent,
                              ),
                            ),
                            const Text(
                              'KCAL',
                              style: TextStyle(
                                fontSize: 12,
                                letterSpacing: 1,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),
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
                            'Macronutriments',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 16),
                          MacroBar(
                            label: 'Protéines',
                            grams: today.proteinGrams,
                            maxGrams: 200,
                          ),
                          const SizedBox(height: 12),
                          MacroBar(
                            label: 'Glucides',
                            grams: today.carbsGrams,
                            maxGrams: 300,
                          ),
                          const SizedBox(height: 12),
                          MacroBar(
                            label: 'Lipides',
                            grams: today.fatGrams,
                            maxGrams: 100,
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
                    ...history.skip(1).map(
                      (day) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Material(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(16),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(16),
                            onTap: isManual ? () => _openEntry(day) : null,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
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
                                    day.calories != null
                                        ? '${day.calories} kcal'
                                        : '—',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
    );
  }
}
