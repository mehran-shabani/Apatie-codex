import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';

import 'modules/appointments/ui/patterns/full_screen_flow/appointments_full_screen_flow.dart';
import 'modules/appointments/ui/screens/appointments_page.dart';
import 'modules/marketplace/ui/patterns/dialog_card/marketplace_dialog_card_pattern.dart';
import 'modules/marketplace/ui/patterns/horizontal_card_bar/marketplace_horizontal_card_bar.dart';
import 'modules/marketplace/ui/screens/marketplace_page.dart';
import 'modules/services/ui/patterns/floating_window/services_floating_window_pattern.dart';
import 'modules/services/ui/screens/services_page.dart';
import 'shared/layout/app_shell.dart';

class AppRouter {
  AppRouter();

  late final GoRouter router = GoRouter(
    initialLocation: AppointmentsPage.routePath,
    routes: [
      GoRoute(
        path: '/',
        redirect: (context, state) => AppointmentsPage.routePath,
      ),
      GoRoute(
        path: '/home',
        redirect: (context, state) => AppointmentsPage.routePath,
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            AppShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppointmentsPage.routePath,
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: AppointmentsPage(),
                ),
                routes: [
                  GoRoute(
                    path: AppointmentsFullScreenFlowPage.routePath,
                    name: AppointmentsFullScreenFlowPage.routeName,
                    pageBuilder: (context, state) => const NoTransitionPage(
                      child: AppointmentsFullScreenFlowPage(),
                    ),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: MarketplacePage.routePath,
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: MarketplacePage(),
                ),
                routes: [
                  GoRoute(
                    path: MarketplaceHorizontalCardBarPage.routePath,
                    name: MarketplaceHorizontalCardBarPage.routeName,
                    pageBuilder: (context, state) => const NoTransitionPage(
                      child: MarketplaceHorizontalCardBarPage(),
                    ),
                  ),
                  GoRoute(
                    path: MarketplaceDialogCardPatternPage.routePath,
                    name: MarketplaceDialogCardPatternPage.routeName,
                    pageBuilder: (context, state) => const NoTransitionPage(
                      child: MarketplaceDialogCardPatternPage(),
                    ),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: ServicesPage.routePath,
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: ServicesPage(),
                ),
                routes: [
                  GoRoute(
                    path: ServicesFloatingWindowPatternPage.routePath,
                    name: ServicesFloatingWindowPatternPage.routeName,
                    pageBuilder: (context, state) => const NoTransitionPage(
                      child: ServicesFloatingWindowPatternPage(),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
    debugLogDiagnostics: kDebugMode,
  );
}
