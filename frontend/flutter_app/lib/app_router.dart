import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'modules/appointments/ui/screens/appointments_page.dart';
import 'modules/marketplace/ui/screens/marketplace_page.dart';
import 'modules/services/ui/screens/services_page.dart';
import 'shared/layout/app_shell.dart';

class AppRouter {
  AppRouter();

  late final GoRouter router = GoRouter(
    initialLocation: AppointmentsPage.routePath,
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            AppShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppointmentsPage.routeName,
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: AppointmentsPage(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: MarketplacePage.routeName,
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: MarketplacePage(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: ServicesPage.routeName,
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: ServicesPage(),
                ),
              ),
            ],
          ),
        ],
      ),
    ],
    debugLogDiagnostics: kDebugMode,
  );
}
