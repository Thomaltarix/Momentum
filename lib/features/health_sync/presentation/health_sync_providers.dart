import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/db/app_database.dart';
import '../data/health_connect_client.dart';
import '../data/health_sync_repository.dart';
import '../domain/health_snapshot.dart';

final Provider<HealthSyncRepository> healthSyncRepositoryProvider =
    Provider<HealthSyncRepository>((ref) {
      return HealthSyncRepository(
        ref.watch(databaseProvider),
        HealthConnectClient(),
      );
    });

final StreamProvider<HealthSnapshot?> todayHealthSnapshotProvider =
    StreamProvider<HealthSnapshot?>((ref) {
      return ref.watch(healthSyncRepositoryProvider).watchToday();
    });
