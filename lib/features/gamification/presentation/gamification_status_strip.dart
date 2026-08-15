import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'badges_screen.dart';
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
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Row(
        children: [
          Text(
            'Niveau ${state.currentLevel} · ${state.currentXp} XP',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(width: 16),
          Text(
            'Série : ${state.currentStreak} j',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.emoji_events_outlined),
            tooltip: 'Badges',
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const BadgesScreen()),
            ),
          ),
        ],
      ),
    );
  }
}
