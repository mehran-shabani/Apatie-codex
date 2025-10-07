import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import '../theme/theme_cubit.dart';
import '../widgets/app_navigation_bar.dart';

class AppShell extends StatelessWidget {
  const AppShell({
    super.key,
    required this.navigationShell,
  });

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.appTitle),
        actions: [
          IconButton(
            tooltip: localizations.themeToggleTooltip,
            icon: Icon(isDark ? Icons.dark_mode : Icons.light_mode),
            onPressed: () => context.read<ThemeCubit>().toggleTheme(),
          ),
        ],
      ),
      body: navigationShell,
      bottomNavigationBar: AppNavigationBar(
        currentIndex: navigationShell.currentIndex,
        onItemSelected: (index) => navigationShell.goBranch(
          index,
          initialLocation: index == navigationShell.currentIndex,
        ),
      ),
    );
  }
}
