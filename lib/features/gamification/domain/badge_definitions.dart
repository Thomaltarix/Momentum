import 'gamification_state.dart';

class BadgeDefinition {
  const BadgeDefinition({
    required this.code,
    required this.name,
    required this.description,
    required this.isUnlocked,
  });

  final String code;
  final String name;
  final String description;
  final bool Function(GamificationState state) isUnlocked;
}

bool _streakAtLeast7(GamificationState state) => state.currentStreak >= 7;
bool _streakAtLeast30(GamificationState state) => state.currentStreak >= 30;
bool _levelAtLeast5(GamificationState state) => state.currentLevel >= 5;

// Fixed list, not user-editable — only the fact that one was unlocked is
// persisted (see claude/data-model.md). Add new badges here; existing
// unlocks are keyed by `code` and never re-checked once earned.
const List<BadgeDefinition> badgeDefinitions = [
  BadgeDefinition(
    code: 'streak_7',
    name: 'Une semaine de suite',
    description: '7 jours d\'affilée réussis.',
    isUnlocked: _streakAtLeast7,
  ),
  BadgeDefinition(
    code: 'streak_30',
    name: 'Un mois de suite',
    description: '30 jours d\'affilée réussis.',
    isUnlocked: _streakAtLeast30,
  ),
  BadgeDefinition(
    code: 'level_5',
    name: 'Niveau 5',
    description: 'A atteint le niveau 5.',
    isUnlocked: _levelAtLeast5,
  ),
];
