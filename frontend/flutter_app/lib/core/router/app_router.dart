import 'package:go_router/go_router.dart';

import '../../features/appointments/presentation/appointments_page.dart';
import '../../features/home/bloc/home_tab_cubit.dart';
import '../../features/home/presentation/home_page.dart';
import '../../features/marketplace/presentation/marketplace_page.dart';
import '../../features/services/presentation/services_page.dart';

class AppRouter {
  AppRouter({required HomeTabCubit homeTabCubit})
      : config = GoRouter(
          initialLocation: HomePage.routePath,
          refreshListenable: GoRouterRefreshStream(homeTabCubit.stream),
          routes: [
            GoRoute(
              path: HomePage.routePath,
              name: HomePage.routeName,
              builder: (context, state) => const HomePage(),
              routes: [
                GoRoute(
                  path: AppointmentsPage.routeName,
                  name: AppointmentsPage.routeName,
                  builder: (context, state) => const AppointmentsPage(),
                ),
                GoRoute(
                  path: MarketplacePage.routeName,
                  name: MarketplacePage.routeName,
                  builder: (context, state) => const MarketplacePage(),
                ),
                GoRoute(
                  path: ServicesPage.routeName,
                  name: ServicesPage.routeName,
                  builder: (context, state) => const ServicesPage(),
                ),
              ],
            ),
          ],
        );

  final GoRouter config;
}
