import 'package:apatie/design_system/components/app_button.dart';
import 'package:apatie/design_system/components/app_card.dart';
import 'package:apatie/design_system/components/app_component_states.dart';
import 'package:apatie/design_system/components/app_input_field.dart';
import 'package:apatie/design_system/components/app_notification.dart';
import 'package:apatie/design_system/foundations/radii.dart';
import 'package:apatie/design_system/foundations/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

import '../components/golden_test_utils.dart';
import '../config/golden_config.dart';

void main() {
  group('Design patterns – Floating window', () {
    for (final surface in <GoldenSurface>[GoldenSurfaces.light, GoldenSurfaces.dark]) {
      testGoldens('renders ${surface.name} variant', (tester) async {
        await GoldenConfig.pumpGoldenWidget(
          tester,
          name: 'test/design_system/goldens/patterns/floating_window_${surface.name}',
          widget: const _FloatingWindowPreview(),
          surfaces: <GoldenSurface>[surface],
          device: GoldenDevices.phoneSmall,
        );
      });
    }
  });
}

class _FloatingWindowPreview extends StatefulWidget {
  const _FloatingWindowPreview();

  @override
  State<_FloatingWindowPreview> createState() => _FloatingWindowPreviewState();
}

class _FloatingWindowPreviewState extends State<_FloatingWindowPreview> {
  final FocusNode _messageFocusNode = FocusNode(debugLabel: 'پیام فوری');

  @override
  void dispose() {
    _messageFocusNode.dispose();
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
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[
                  theme.colorScheme.surfaceVariant.withOpacity(0.3),
                  theme.colorScheme.surfaceVariant.withOpacity(0.05),
                ],
              ),
            ),
          ),
        ),
        Align(
          alignment: AlignmentDirectional.bottomEnd,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 340),
              child: Material(
                color: theme.colorScheme.surface,
                elevation: 8,
                borderRadius: AppRadii.lgRadius,
                clipBehavior: Clip.antiAlias,
                child: AppCard(
                  compact: true,
                  child: _FloatingWindowBody(
                    focusNode: _messageFocusNode,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _FloatingWindowBody extends StatelessWidget {
  const _FloatingWindowBody({
    required this.focusNode,
  });

  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            const Icon(Icons.drag_handle, size: 20),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                'پنجرهٔ شناور هماهنگی',
                style: theme.textTheme.titleSmall,
                textAlign: TextAlign.right,
              ),
            ),
            IconButton(
              tooltip: 'بستن پنجرهٔ شناور',
              // Fake close handler – the capture only needs to demonstrate the
              // chroming and focus order of the floating window.
              onPressed: () {},
              icon: const Icon(Icons.close),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        // Simulated review ticket used to contextualise the floating window.
        AppNotification(
          title: 'پیام رسمی سامانه',
          message:
              'فرم در حال بررسی است. لطفاً نتیجهٔ بازبینی مستندات را برای کارشناس پاسخ دهید تا درخواست متوقف نشود.',
          tone: AppComponentStatus.warning,
          compact: true,
        ),
        const SizedBox(height: AppSpacing.md),
        GoldenFocusActivator(
          focusNode: focusNode,
          child: AppInputField(
            label: 'پاسخ فوری',
            helperText: 'از لحنی کاملاً رسمی استفاده کنید.',
            maxLines: 3,
            focusNode: focusNode,
            placeholder: 'شرح تصمیم کمیتهٔ ارزیابی...',
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Wrap(
          alignment: WrapAlignment.end,
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            AppButton(
              label: 'لغو',
              onPressed: () {},
              tone: AppComponentStatus.neutral,
              compact: true,
            ),
            AppButton(
              label: 'ارسال پاسخ رسمی',
              onPressed: () {},
              tone: AppComponentStatus.info,
              compact: true,
            ),
          ],
        ),
      ],
    );
  }
}
