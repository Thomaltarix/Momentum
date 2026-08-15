import 'package:go_router/go_router.dart';

import '../../features/routines/presentation/routines_screen.dart';

final GoRouter appRouter = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const RoutinesScreen()),
  ],
);
