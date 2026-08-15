import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/badge_definitions.dart';
import 'gamification_providers.dart';

class BadgesScreen extends ConsumerWidget {
  const BadgesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unlockedAsync = ref.watch(unlockedBadgesProvider);
    final unlockedCodes = {
      for (final badge in unlockedAsync.value ?? const []) badge.code,
    };

    return Scaffold(
      appBar: AppBar(title: const Text('Badges')),
      body: ListView.builder(
        itemCount: badgeDefinitions.length,
        itemBuilder: (context, index) {
          final definition = badgeDefinitions[index];
          final unlocked = unlockedCodes.contains(definition.code);
          return ListTile(
            leading: Icon(
              unlocked ? Icons.emoji_events : Icons.emoji_events_outlined,
              color: unlocked ? Theme.of(context).colorScheme.primary : null,
            ),
            title: Text(definition.name),
            subtitle: Text(definition.description),
            enabled: unlocked,
          );
        },
      ),
    );
  }
}
