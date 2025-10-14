import 'package:apatie/design_system/components/app_component_states.dart';
import 'package:apatie/design_system/components/app_option_row.dart';
import 'package:apatie/design_system/foundations/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

import '../config/golden_config.dart';
import 'golden_test_utils.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AppOptionRow golden tests', () {
    testGoldens('renders option row variants', (tester) async {
      await withTrivialGoldenComparator(() async {
        await GoldenConfig.pumpGoldenWidget(
          tester,
          name: 'design_system/components/option_rows',
          widget: const _OptionRowsPreview(),
        );
      });
    });
  });
}

class _OptionRowsPreview extends StatelessWidget {
  const _OptionRowsPreview();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppOptionRow(
            title: 'درگاه پرداخت',
            subtitle: 'فعال و آماده استفاده',
            leading: CircleAvatar(
              backgroundColor: theme.colorScheme.primary,
              child: const Icon(Icons.payment, color: Colors.white),
            ),
            trailing: const Icon(Icons.chevron_left),
            onTap: () {},
          ),
          const SizedBox(height: AppSpacing.sm),
          AppOptionRow(
            title: 'دسترسی مدیر سیستم',
            subtitle: 'سطح دسترسی کامل',
            tone: AppComponentStatus.success,
            selected: true,
            leading: const Icon(Icons.verified_user),
            trailing: Switch(
              value: true,
              onChanged: (_) {},
            ),
            onTap: () {},
          ),
          const SizedBox(height: AppSpacing.sm),
          AppOptionRow(
            title: 'هشدار پیامک',
            subtitle: 'پیامک‌های سیستمی فعال است.',
            tone: AppComponentStatus.info,
            compact: true,
            leading: const Icon(Icons.sms),
            trailing: const Icon(Icons.edit),
            onTap: () {},
          ),
          const SizedBox(height: AppSpacing.sm),
          AppOptionRow(
            title: 'گزارش‌های بحرانی',
            subtitle: 'ارسال خودکار هر ۱۵ دقیقه',
            tone: AppComponentStatus.warning,
            isLoading: true,
            leading: const Icon(Icons.warning_amber),
          ),
          const SizedBox(height: AppSpacing.sm),
          const AppOptionRow(
            title: 'سرویس غیرفعال',
            subtitle: 'در انتظار فعال‌سازی مجدد',
            tone: AppComponentStatus.error,
            disabled: true,
          ),
        ],
      ),
    );
  }
}
