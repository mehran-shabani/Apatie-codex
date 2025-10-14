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
    testGoldens('covers compact, loading, and tone variations', (tester) async {
      await withTrivialGoldenComparator(() async {
        await GoldenConfig.pumpGoldenWidget(
          tester,
          name:
              'test/design_system/goldens/components/navigation_bars_variants',
          widget: const _NavigationBarsPreview(),
        );
      });
    });
  });
}

class _NavigationBarsPreview extends StatelessWidget {
  const _NavigationBarsPreview();

  static const List<AppNavigationDestination> _destinations = [
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

  @override
  Widget build(BuildContext context) {
    return ComponentStateGallery(
      sections: [
        ComponentStateSection(
          title: 'پیکربندی‌های اصلی',
          tiles: [
            ComponentStateTile(
              label: 'حالت استاندارد',
              child: _buildBar(currentIndex: 0),
            ),
            ComponentStateTile(
              label: 'انتخاب مقصد دوم',
              child: _buildBar(currentIndex: 1),
            ),
            ComponentStateTile(
              label: 'نسخهٔ فشرده',
              child: _buildBar(currentIndex: 2, compact: true),
            ),
            ComponentStateTile(
              label: 'نمایش بارگذاری',
              child: _buildBar(currentIndex: 0, isLoading: true),
            ),
          ],
        ),
        ComponentStateSection(
          title: 'حالت‌های وضعیت',
          tiles: [
            ComponentStateTile(
              label: 'موفق',
              child: _buildBar(
                currentIndex: 0,
                tone: AppComponentStatus.success,
              ),
            ),
            ComponentStateTile(
              label: 'هشدار',
              child: _buildBar(
                currentIndex: 1,
                tone: AppComponentStatus.warning,
              ),
            ),
            ComponentStateTile(
              label: 'خطا',
              child: _buildBar(
                currentIndex: 2,
                tone: AppComponentStatus.error,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBar({
    required int currentIndex,
    AppComponentStatus tone = AppComponentStatus.neutral,
    bool compact = false,
    bool isLoading = false,
  }) {
    return AppNavigationBar(
      destinations: _destinations,
      currentIndex: currentIndex,
      tone: tone,
      compact: compact,
      isLoading: isLoading,
      onDestinationSelected: (_) {},
    );
  }
}
