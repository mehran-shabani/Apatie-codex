import 'package:apatie/design_system/components/app_component_states.dart';
import 'package:apatie/design_system/components/app_list.dart';
import 'package:apatie/design_system/foundations/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

import '../config/golden_config.dart';
import 'golden_test_utils.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AppList golden tests', () {
    testGoldens('renders list variants', (tester) async {
      await withTrivialGoldenComparator(() async {
        await GoldenConfig.pumpGoldenWidget(
          tester,
          name: 'design_system/components/lists',
          widget: const _ListsPreview(),
        );
      });
    });
  });
}

class _ListsPreview extends StatelessWidget {
  const _ListsPreview();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppList(
            semanticLabel: 'فهرست اصلی',
            items: [
              AppListItem(
                title: 'گزارش فروش',
                subtitle: 'آخرین به‌روزرسانی: ۳ دقیقه پیش',
                leading: CircleAvatar(
                  backgroundColor: theme.colorScheme.primary,
                  child: const Icon(Icons.bar_chart, color: Colors.white),
                ),
                trailing: const Icon(Icons.chevron_left),
                tone: AppComponentStatus.info,
                selected: true,
                onTap: () {},
              ),
              AppListItem(
                title: 'درخواست‌های پشتیبانی',
                subtitle: '۲ مورد جدید',
                leading: CircleAvatar(
                  backgroundColor: theme.colorScheme.secondary,
                  child: const Icon(Icons.support_agent, color: Colors.white),
                ),
                trailing: const Icon(Icons.arrow_back),
                tone: AppComponentStatus.warning,
                onTap: () {},
              ),
              const AppListItem(
                title: 'آرشیو اسناد',
                subtitle: 'دسترسی فقط خواندنی',
                disabled: true,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          AppList(
            separated: false,
            semanticLabel: 'فهرست فشرده',
            items: const [
              AppListItem(
                title: 'حساب اصلی',
                subtitle: 'فعال',
                compact: true,
                tone: AppComponentStatus.success,
              ),
              AppListItem(
                title: 'حساب فرعی',
                subtitle: 'غیرفعال',
                compact: true,
                tone: AppComponentStatus.error,
                isLoading: true,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
