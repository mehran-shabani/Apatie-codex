// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:apatie/design_system/components/app_component_states.dart';
import 'package:apatie/design_system/foundations/spacing.dart';
import 'package:apatie/design_system/foundations/touch_targets.dart';

class AppNavigationDestination {
  const AppNavigationDestination({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    this.semanticLabel,
  });

  final Widget icon;
  final Widget selectedIcon;
  final String label;
  final String? semanticLabel;
}

class AppNavigationBar extends StatefulWidget {
  const AppNavigationBar({
    super.key,
    required this.destinations,
    required this.currentIndex,
    required this.onDestinationSelected,
    this.tone = AppComponentStatus.neutral,
    this.compact = false,
    this.isLoading = false,
    this.onEventAnnounced,
  });

  final List<AppNavigationDestination> destinations;
  final int currentIndex;
  final ValueChanged<int> onDestinationSelected;
  final AppComponentStatus tone;
  final bool compact;
  final bool isLoading;
  final ValueChanged<String>? onEventAnnounced;

  @override
  State<AppNavigationBar> createState() => _AppNavigationBarState();
}

class _AppNavigationBarState extends State<AppNavigationBar> {
  void _announce(String message) {
    if (widget.onEventAnnounced != null) {
      widget.onEventAnnounced!(message);
    } else {
      SemanticsService.announce(message, Directionality.of(context));
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = resolveComponentColors(
      context,
      status: widget.tone,
      highlighted: false,
      disabled: false,
    );
    final theme = Theme.of(context);

    final destinations = <NavigationDestination>[
      for (final destination in widget.destinations)
        NavigationDestination(
          icon: destination.icon,
          selectedIcon: destination.selectedIcon,
          label: destination.label,
          tooltip: destination.semanticLabel ?? 'بخش ${destination.label}',
        ),
    ];

    final navBar = NavigationBarTheme(
      data: NavigationBarThemeData(
        height:
            widget.compact ? AppTouchTargets.denseToolbarHeight : AppTouchTargets.toolbarHeight,
        backgroundColor: colors.background,
        surfaceTintColor: colors.background,
        indicatorColor: colors.border.withOpacity(0.2),
        labelTextStyle: MaterialStateProperty.all(
          theme.textTheme.labelMedium?.copyWith(color: colors.foreground),
        ),
        iconTheme: MaterialStateProperty.resolveWith<IconThemeData?>((states) {
          if (states.contains(MaterialState.selected)) {
            return IconThemeData(color: colors.border);
          }
          return IconThemeData(color: colors.foreground.withOpacity(0.8));
        }),
      ),
      child: NavigationBar(
        selectedIndex: widget.currentIndex,
        elevation: 0,
        destinations: destinations,
        onDestinationSelected: (index) {
          _announce('بخش ${widget.destinations[index].label} انتخاب شد.');
          widget.onDestinationSelected(index);
        },
        labelBehavior: widget.compact
            ? NavigationDestinationLabelBehavior.onlyShowSelected
            : NavigationDestinationLabelBehavior.alwaysShow,
      ),
    );

    return Semantics(
      container: true,
      label: 'نوار ناوبری اصلی',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.isLoading)
            LinearProgressIndicator(
              minHeight: 2,
              color: colors.border,
              backgroundColor: colors.background,
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
            child: navBar,
          ),
        ],
      ),
    );
  }
}
