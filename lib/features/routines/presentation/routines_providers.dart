import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/db/app_database.dart';
import '../../../core/notifications/notification_service.dart';
import '../data/routine_notification_scheduler.dart';
import '../data/routines_repository.dart';
import '../domain/routine.dart';

final Provider<RoutinesRepository> routinesRepositoryProvider =
    Provider<RoutinesRepository>((ref) {
      final scheduler = RoutineNotificationScheduler(
        ref.watch(notificationServiceProvider),
      );
      return RoutinesRepository(ref.watch(databaseProvider), scheduler);
    });

final StreamProvider<List<Routine>> routinesProvider =
    StreamProvider<List<Routine>>((ref) {
      return ref.watch(routinesRepositoryProvider).watchRoutines();
    });

final StreamProvider<Set<int>> todayCompletedRoutineIdsProvider =
    StreamProvider<Set<int>>((ref) {
      return ref
          .watch(routinesRepositoryProvider)
          .watchCompletedRoutineIdsForDate(DateTime.now());
    });
