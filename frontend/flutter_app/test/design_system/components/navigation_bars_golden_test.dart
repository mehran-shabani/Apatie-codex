import 'package:apatie/design_system/components/app_component_states.dart';
import 'package:apatie/design_system/components/app_navigation_bar.dart';
import 'package:apatie/design_system/foundations/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

import '../config/golden_config.dart';
import 'golden_test_utils.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AppNavigationBar golden tests', () {
    testGoldens('renders navigation bar variants', (tester) async {
      await withTrivialGoldenComparator(() async {
        await GoldenConfig.pumpGoldenWidget(
          tester,
          name: 'design_system/components/navigation_bars',
          widget: const _NavigationBarsPreview(),
        );
      });
    });
  });
}

class _NavigationBarsPreview extends StatelessWidget {
  const _NavigationBarsPreview();

  @override
  Widget build(BuildContext context) {
    const destinations = [
      AppNavigationDestination(
        icon: Icon(Icons.dashboard_outlined),
        selectedIcon: Icon(Icons.dashboard),
        label: 'داشبورد',
      ),
      AppNavigationDestination(
        icon: Icon(Icons.chat_bubble_outline),
        selectedIcon: Icon(Icons.chat_bubble),
        label: 'گفت‌وگو',
      ),
      AppNavigationDestination(
        icon: Icon(Icons.settings_outlined),
        selectedIcon: Icon(Icons.settings),
        label: 'تنظیمات',
      ),
    ];

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppNavigationBar(
            destinations: destinations,
            currentIndex: 0,
            onDestinationSelected: (_) {},
          ),
          const SizedBox(height: AppSpacing.lg),
          AppNavigationBar(
            destinations: destinations,
            currentIndex: 1,
            onDestinationSelected: (_) {},
            tone: AppComponentStatus.success,
            compact: true,
          ),
          const SizedBox(height: AppSpacing.lg),
          AppNavigationBar(
            destinations: destinations,
            currentIndex: 2,
            onDestinationSelected: (_) {},
            tone: AppComponentStatus.warning,
            isLoading: true,
          ),
        ],
      ),
    );
  }
}
