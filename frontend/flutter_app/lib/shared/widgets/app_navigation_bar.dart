import 'package:flutter/material.dart';
import 'package:flutter_app/design_system/components/app_component_states.dart';
import 'package:flutter_app/design_system/components/app_navigation_bar.dart'
    as design_system;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AppNavigationBar extends StatelessWidget {
  const AppNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onItemSelected,
    this.tone = AppComponentStatus.neutral,
    this.compact = false,
    this.isLoading = false,
  });

  final int currentIndex;
  final ValueChanged<int> onItemSelected;
  final AppComponentStatus tone;
  final bool compact;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return design_system.AppNavigationBar(
      currentIndex: currentIndex,
      onDestinationSelected: onItemSelected,
      tone: tone,
      compact: compact,
      isLoading: isLoading,
      destinations: [
        design_system.AppNavigationDestination(
          icon: const Icon(Icons.event_outlined),
          selectedIcon: const Icon(Icons.event),
          label: localizations.appointmentsTab,
          semanticLabel: 'نمایش نوبت‌ها',
        ),
        design_system.AppNavigationDestination(
          icon: const Icon(Icons.storefront_outlined),
          selectedIcon: const Icon(Icons.storefront),
          label: localizations.marketplaceTab,
          semanticLabel: 'نمایش بازار',
        ),
        design_system.AppNavigationDestination(
          icon: const Icon(Icons.miscellaneous_services_outlined),
          selectedIcon: const Icon(Icons.miscellaneous_services),
          label: localizations.servicesTab,
          semanticLabel: 'نمایش خدمات',
        ),
      ],
    );
  }
}
