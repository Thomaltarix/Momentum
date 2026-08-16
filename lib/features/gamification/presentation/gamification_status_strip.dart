import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import 'gamification_providers.dart';

class GamificationStatusStrip extends ConsumerWidget {
  const GamificationStatusStrip({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Triggers the day-by-day evaluation once per app session; the result
    // isn't read here, gamificationStateProvider below already reflects it.
    ref.watch(gamificationEvaluationProvider);

    final stateAsync = ref.watch(gamificationStateProvider);
    final state = stateAsync.value;
    if (state == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
      child: Row(
        children: [
          Text(
            'Niveau ${state.currentLevel} · ${state.currentXp} XP',
            style: const TextStyle(fontSize: 15, color: AppColors.textSecondary),
          ),
          const SizedBox(width: 16),
          const Icon(Icons.local_fire_department, size: 16, color: AppColors.accent),
          const SizedBox(width: 4),
          Text(
            '${state.currentStreak} jours',
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: AppColors.accent,
            ),
          ),
        ],
      ),
    );
  }
}
