import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AppNavigationBar extends StatelessWidget {
  const AppNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onItemSelected,
  });

  final int currentIndex;
  final ValueChanged<int> onItemSelected;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: onItemSelected,
      destinations: [
        NavigationDestination(
          icon: const Icon(Icons.event_outlined),
          selectedIcon: const Icon(Icons.event),
          label: localizations.appointmentsTab,
        ),
        NavigationDestination(
          icon: const Icon(Icons.storefront_outlined),
          selectedIcon: const Icon(Icons.storefront),
          label: localizations.marketplaceTab,
        ),
        NavigationDestination(
          icon: const Icon(Icons.miscellaneous_services_outlined),
          selectedIcon: const Icon(Icons.miscellaneous_services),
          label: localizations.servicesTab,
        ),
      ],
    );
  }
}
