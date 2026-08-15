import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/db/app_database.dart';
import '../../health_sync/presentation/health_sync_providers.dart';
import '../../routines/presentation/routines_providers.dart';
import '../data/gamification_repository.dart';
import '../domain/badge.dart';
import '../domain/gamification_state.dart';

final Provider<GamificationRepository> gamificationRepositoryProvider = Provider<GamificationRepository>((ref) {
  return GamificationRepository(
    ref.watch(databaseProvider),
    ref.watch(routinesRepositoryProvider),
    ref.watch(healthSyncRepositoryProvider),
  );
});

final StreamProvider<GamificationState> gamificationStateProvider = StreamProvider<GamificationState>((ref) {
  return ref.watch(gamificationRepositoryProvider).watchState();
});

final StreamProvider<List<Badge>> unlockedBadgesProvider = StreamProvider<List<Badge>>((ref) {
  return ref.watch(gamificationRepositoryProvider).watchUnlockedBadges();
});

/// Watched once from the home screen to trigger evaluation on app open —
/// see GamificationRepository.evaluateUpToYesterday.
final FutureProvider<void> gamificationEvaluationProvider = FutureProvider<void>((ref) {
  return ref.watch(gamificationRepositoryProvider).evaluateUpToYesterday();
});
