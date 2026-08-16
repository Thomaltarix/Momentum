import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
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
        padding: const EdgeInsets.all(20),
        itemCount: badgeDefinitions.length,
        itemBuilder: (context, index) {
          final definition = badgeDefinitions[index];
          final unlocked = unlockedCodes.contains(definition.code);
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: unlocked
                          ? AppColors.accent.withValues(alpha: 0.16)
                          : AppColors.border,
                    ),
                    child: Icon(
                      Icons.emoji_events,
                      size: 22,
                      color: unlocked
                          ? AppColors.accent
                          : AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          definition.name,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: unlocked
                                ? AppColors.textPrimary
                                : AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          definition.description,
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
