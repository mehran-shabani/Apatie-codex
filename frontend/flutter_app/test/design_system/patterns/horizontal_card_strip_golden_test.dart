import 'package:apatie/design_system/components/app_button.dart';
import 'package:apatie/design_system/components/app_card.dart';
import 'package:apatie/design_system/components/app_component_states.dart';
import 'package:apatie/design_system/components/app_input_field.dart';
import 'package:apatie/design_system/components/app_label.dart';
import 'package:apatie/design_system/foundations/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

import '../components/golden_test_utils.dart';
import '../config/golden_config.dart';

void main() {
  group('Design patterns – Horizontal card strip', () {
    for (final surface in <GoldenSurface>[GoldenSurfaces.light, GoldenSurfaces.dark]) {
      testGoldens('renders ${surface.name} variant', (tester) async {
        await GoldenConfig.pumpGoldenWidget(
          tester,
          name: 'test/design_system/goldens/patterns/horizontal_card_strip_${surface.name}',
          widget: const _HorizontalCardStripPreview(),
          surfaces: <GoldenSurface>[surface],
        );
      });
    }
  });
}

class _HorizontalCardStripPreview extends StatefulWidget {
  const _HorizontalCardStripPreview();

  @override
  State<_HorizontalCardStripPreview> createState() => _HorizontalCardStripPreviewState();
}

class _HorizontalCardStripPreviewState extends State<_HorizontalCardStripPreview> {
  final FocusNode _filterFocusNode = FocusNode(debugLabel: 'فیلتر نوار کارت');

  @override
  void dispose() {
    _filterFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'پیگیری طرح‌های جاری',
          style: theme.textTheme.titleLarge,
          textAlign: TextAlign.right,
        ),
        const SizedBox(height: AppSpacing.sm),
        GoldenFocusActivator(
          focusNode: _filterFocusNode,
          child: AppInputField(
            label: 'فیلتر رسمی طرح‌ها',
            helperText: 'برای محدود کردن نوار کارت، عنوان یا کد طرح را جست‌وجو کنید.',
            focusNode: _filterFocusNode,
            placeholder: 'مثال: طرح تحول دیجیتال',
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        SizedBox(
          height: 220,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final showTwoRows = constraints.maxWidth > 600;
              final cards = _buildCards(theme, wrap: showTwoRows);
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                reverse: true,
                padding: const EdgeInsetsDirectional.only(start: AppSpacing.lg),
                child: Wrap(
                  spacing: AppSpacing.lg,
                  runSpacing: AppSpacing.lg,
                  children: cards,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  List<Widget> _buildCards(ThemeData theme, {required bool wrap}) {
    final cards = <Widget>[];

    // Mock backlog items – in production they come from the orchestration API.
    final mockStates = <(String title, String description, AppComponentStatus tone)>[
      (
        'در انتظار تصویب',
        'کمیتهٔ عالی باید تا ساعت ۱۷ نظر خود را اعلام کند.',
        AppComponentStatus.info,
      ),
      (
        'نیازمند بازنگری',
        'گزارش مالی بند سوم ناقص است. لطفاً توضیحات تکمیلی بارگذاری شود.',
        AppComponentStatus.warning,
      ),
      (
        'تأیید نهایی شد',
        'مصوبهٔ شمارهٔ ۲۱۸۴ ثبت شد و برای ابلاغ رسمی ارسال گردید.',
        AppComponentStatus.success,
      ),
    ];

    for (final state in mockStates) {
      cards.add(
        SizedBox(
          width: wrap ? 280 : 300,
          child: AppCard(
            compact: true,
            header: Text(
              state.$1,
              style: theme.textTheme.titleSmall,
              textAlign: TextAlign.right,
            ),
            footer: Wrap(
              alignment: WrapAlignment.end,
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                AppButton(
                  label: 'جزئیات',
                  // Stubbed to keep the capture deterministic while documenting
                  // the intended navigation hook.
                  onPressed: () {},
                  tone: AppComponentStatus.neutral,
                  compact: true,
                ),
                AppButton(
                  label: 'اقدام رسمی',
                  onPressed: () {},
                  tone: state.$3,
                  compact: true,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppLabel(
                  tone: state.$3,
                  text: state.$1,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  state.$2,
                  style: theme.textTheme.bodyMedium,
                  textAlign: TextAlign.right,
                ),
              ],
            ),
          ),
        ),
      );
    }

    return cards;
  }
}
