import 'package:apatie/design_system/components/app_button.dart';
import 'package:apatie/design_system/components/app_card.dart';
import 'package:apatie/design_system/components/app_component_states.dart';
import 'package:apatie/design_system/foundations/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

import '../config/golden_config.dart';
import 'golden_test_utils.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AppCard golden tests', () {
    testGoldens('renders card variants', (tester) async {
      await withTrivialGoldenComparator(() async {
        await GoldenConfig.pumpGoldenWidget(
          tester,
          name: 'design_system/components/cards',
          widget: const _CardsPreview(),
        );
      });
    });
  });
}

class _CardsPreview extends StatelessWidget {
  const _CardsPreview();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppCard(
            header: Text(
              'گزارش وضعیت',
              style: theme.textTheme.titleMedium,
            ),
            child: Text(
              'این کارت حالت پیش‌فرض را با سربرگ، محتوای متنی و دکمهٔ کنش نشان می‌دهد.',
              style: theme.textTheme.bodyMedium,
            ),
            footer: Align(
              alignment: AlignmentDirectional.centerStart,
              child: AppButton(
                label: 'اقدام',
                onPressed: () {},
                compact: true,
              ),
            ),
            onTap: () {},
          ),
          const SizedBox(height: AppSpacing.lg),
          AppCard(
            compact: true,
            tone: AppComponentStatus.success,
            header: Text(
              'تأیید پرداخت',
              style: theme.textTheme.titleSmall,
            ),
            child: Text(
              'پرداخت شما با موفقیت ثبت شد.',
              style: theme.textTheme.bodyMedium,
            ),
            footer: Text(
              'کد پیگیری: ۱۲۳۴۵۶',
              style: theme.textTheme.bodySmall,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          AppCard(
            tone: AppComponentStatus.warning,
            isLoading: true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'بررسی اطلاعات',
                  style: theme.textTheme.titleMedium,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'در حال بارگذاری داده‌های تکمیلی هستیم. لطفاً کمی صبر کنید.',
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          const AppCard(
            child: Text('کارت غیرفعال بدون کنش'),
            disabled: true,
          ),
        ],
      ),
    );
  }
}
