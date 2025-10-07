import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../l10n/app_localizations.dart';
import '../../appointments/presentation/appointments_page.dart';
import '../../marketplace/presentation/marketplace_page.dart';
import '../../services/presentation/services_page.dart';
import '../bloc/home_tab_cubit.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const String routeName = 'home';
  static const String routePath = '/';

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);
    final tabs = [
      _TabConfig(localization.appointmentsTab, const AppointmentsPage(), Icons.event),
      _TabConfig(localization.marketplaceTab, const MarketplacePage(), Icons.storefront),
      _TabConfig(localization.servicesTab, const ServicesPage(), Icons.build),
    ];

    return BlocBuilder<HomeTabCubit, HomeTabState>(
      builder: (context, state) {
        return Scaffold(
          body: tabs[state.index].view,
          bottomNavigationBar: NavigationBar(
            selectedIndex: state.index,
            destinations: tabs
                .map(
                  (tab) => NavigationDestination(
                    icon: Icon(tab.icon),
                    label: tab.label,
                  ),
                )
                .toList(),
            onDestinationSelected: context.read<HomeTabCubit>().setTab,
          ),
        );
      },
    );
  }
}

class _TabConfig {
  const _TabConfig(this.label, this.view, this.icon);

  final String label;
  final Widget view;
  final IconData icon;
}
