import 'package:apatie/design_system/components/app_button.dart';
import 'package:apatie/design_system/components/app_card.dart';
import 'package:apatie/design_system/components/app_component_states.dart';
import 'package:apatie/design_system/components/app_dialog.dart';
import 'package:apatie/design_system/components/app_input_field.dart';
import 'package:apatie/design_system/components/app_label.dart';
import 'package:apatie/design_system/foundations/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

import '../components/golden_test_utils.dart';
import '../config/golden_config.dart';

void main() {
  group('Design patterns – Card inside dialog', () {
    for (final surface in <GoldenSurface>[GoldenSurfaces.light, GoldenSurfaces.dark]) {
      testGoldens('renders ${surface.name} variant', (tester) async {
        await GoldenConfig.pumpGoldenWidget(
          tester,
          name: 'test/design_system/goldens/patterns/card_in_dialog_${surface.name}',
          widget: const _CardInDialogPreview(),
          surfaces: <GoldenSurface>[surface],
        );
      });
    }
  });
}

class _CardInDialogPreview extends StatefulWidget {
  const _CardInDialogPreview();

  @override
  State<_CardInDialogPreview> createState() => _CardInDialogPreviewState();
}

class _CardInDialogPreviewState extends State<_CardInDialogPreview> {
  final FocusNode _noteFocusNode = FocusNode(debugLabel: 'یادداشت مدیر');

  @override
  void dispose() {
    _noteFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Stack(
      children: [
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceVariant.withOpacity(0.4),
            ),
          ),
        ),
        Center(
          child: AppDialog(
            title: 'جزئیات قرارداد',
            content: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: AppCard(
                compact: true,
                header: Text(
                  'اطلاعات کارگروه',
                  style: theme.textTheme.titleSmall,
                  textAlign: TextAlign.right,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Mock API response summarised for reviewers.
                    const AppLabel(
                      tone: AppComponentStatus.info,
                      text: 'اولویت: ثبت رسمی فوری',
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      'لطفاً مفاد بندهای مالی قرارداد شمارهٔ ۹۲۳۰ را بررسی و نتیجه را برای مدیرعامل ارسال کنید.',
                      style: theme.textTheme.bodyMedium,
                      textAlign: TextAlign.right,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    GoldenFocusActivator(
                      focusNode: _noteFocusNode,
                      child: AppInputField(
                        label: 'یادداشت رسمی مدیر',
                        helperText: 'برای جلوگیری از ابطال، توضیحات را کاملاً رسمی ثبت کنید.',
                        focusNode: _noteFocusNode,
                        maxLines: 4,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              AppButton(
                label: 'لغو',
                // Documented stub: dialog dismissal handled by host flow.
                onPressed: () {},
                tone: AppComponentStatus.neutral,
              ),
              AppButton(
                label: 'ارسال برای تأیید نهایی',
                // Mock submission endpoint – replace with Navigator.pop once the
                // end-to-end approval flow is wired.
                onPressed: () {},
                tone: AppComponentStatus.success,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
