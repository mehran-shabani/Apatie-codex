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
    testGoldens('captures layout, hover, and status variants', (tester) async {
      await withTrivialGoldenComparator(() async {
        await GoldenConfig.pumpGoldenWidget(
          tester,
          name: 'test/design_system/goldens/components/cards_state_matrix',
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
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: ComponentStateGallery(
        sections: [
          ComponentStateSection(
            title: 'حالات تعاملی کارت',
            tiles: [
              ComponentStateTile(
                label: 'کارت استاندارد',
                child: AppCard(
                  onTap: () {},
                  child: const _CardBody(text: 'خلاصهٔ وضعیت پروژه'),
                ),
              ),
              ComponentStateTile(
                label: 'در حالت شناور',
                child: GoldenHoverActivator(
                  child: AppCard(
                    onTap: () {},
                    child: const _CardBody(text: 'گزارش لحظه‌ای'),
                  ),
                ),
              ),
              ComponentStateTile(
                label: 'فشرده',
                child: AppCard(
                  onTap: () {},
                  compact: true,
                  child: const _CardBody(text: 'کارت فشرده'),
                ),
              ),
              ComponentStateTile(
                label: 'غیرفعال',
                child: AppCard(
                  onTap: () {},
                  disabled: true,
                  child: const _CardBody(text: 'دسترسی محدود'),
                ),
              ),
              ComponentStateTile(
                label: 'نمایش بارگذاری',
                child: AppCard(
                  onTap: () {},
                  isLoading: true,
                  child: const _CardBody(text: 'در حال به‌روزرسانی داده‌ها'),
                ),
              ),
            ],
          ),
          ComponentStateSection(
            title: 'حالات وضعیت',
            tiles: [
              ComponentStateTile(
                label: 'موفق',
                child: AppCard(
                  onTap: () {},
                  tone: AppComponentStatus.success,
                  child: const _CardBody(text: 'تأیید شده'),
                ),
              ),
              ComponentStateTile(
                label: 'هشدار',
                child: AppCard(
                  onTap: () {},
                  tone: AppComponentStatus.warning,
                  child: const _CardBody(text: 'نیاز به بررسی'),
                ),
              ),
              ComponentStateTile(
                label: 'خطا',
                child: AppCard(
                  onTap: () {},
                  tone: AppComponentStatus.error,
                  child: const _CardBody(text: 'با خطا مواجه شد'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CardBody extends StatelessWidget {
  const _CardBody({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          text,
          textAlign: TextAlign.right,
          style: theme.textTheme.titleMedium,
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'این کارت جزییات مهم را نمایش می‌دهد و برای تراکم‌های مختلف '
          'بهینه شده است.',
          textAlign: TextAlign.right,
          style: theme.textTheme.bodyMedium,
        ),
      ],
    );
  }
}
