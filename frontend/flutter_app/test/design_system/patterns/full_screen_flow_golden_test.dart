import 'package:apatie/design_system/components/app_button.dart';
import 'package:apatie/design_system/components/app_card.dart';
import 'package:apatie/design_system/components/app_component_states.dart';
import 'package:apatie/design_system/components/app_input_field.dart';
import 'package:apatie/design_system/components/app_navigation_bar.dart';
import 'package:apatie/design_system/components/app_notification.dart';
import 'package:apatie/design_system/components/app_progress_indicator.dart';
import 'package:apatie/design_system/foundations/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

import '../components/golden_test_utils.dart';
import '../config/golden_config.dart';

void main() {
  group('Design patterns – Full screen flow', () {
    for (final surface in <GoldenSurface>[GoldenSurfaces.light, GoldenSurfaces.dark]) {
      testGoldens('renders ${surface.name} variant', (tester) async {
        await GoldenConfig.pumpGoldenWidget(
          tester,
          name: 'test/design_system/goldens/patterns/full_screen_flow_${surface.name}',
          widget: const _FullScreenFlowPreview(),
          surfaces: <GoldenSurface>[surface],
          device: GoldenDevices.phoneSmall,
          padding: EdgeInsets.zero,
        );
      });
    }
  });
}

class _FullScreenFlowPreview extends StatefulWidget {
  const _FullScreenFlowPreview();

  @override
  State<_FullScreenFlowPreview> createState() => _FullScreenFlowPreviewState();
}

class _FullScreenFlowPreviewState extends State<_FullScreenFlowPreview> {
  final FocusNode _nameFocusNode = FocusNode(debugLabel: 'نام');
  final FocusNode _emailFocusNode = FocusNode(debugLabel: 'ایمیل');

  @override
  void dispose() {
    _nameFocusNode.dispose();
    _emailFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: AppNotification(
                title: 'تکمیل ثبت‌نام سازمانی',
                message:
                    'لطفاً پیش از ادامهٔ جریان، اطلاعات خواسته‌شده را با دقت و به‌صورت رسمی تکمیل کنید. زمان باقی‌مانده برای ارسال مدارک پنج دقیقه است.',
                tone: AppComponentStatus.info,
                actions: const <Widget>[],
              ),
            ),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final horizontal = constraints.maxWidth > 400;
                  // Mock payload representing API response for the current
                  // onboarding step; using constants keeps the golden
                  // deterministic while documenting the flow assumptions.
                  final cardChild = Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'جزئیات نمایندهٔ قانونی',
                        style: theme.textTheme.titleMedium,
                        textAlign: TextAlign.right,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      GoldenFocusActivator(
                        focusNode: _nameFocusNode,
                        child: AppInputField(
                          label: 'نام و نام خانوادگی',
                          placeholder: 'مثال: محمدرضا رضایی',
                          helperText: 'نام باید مطابق کارت ملی باشد.',
                          focusNode: _nameFocusNode,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      GoldenFocusActivator(
                        focusNode: _emailFocusNode,
                        child: AppInputField(
                          label: 'ایمیل کاری',
                          placeholder: 'مثال: info@example.ir',
                          helperText: 'از ایمیل سازمانی معتبر استفاده کنید.',
                          focusNode: _emailFocusNode,
                          keyboardType: TextInputType.emailAddress,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      _linearProgressIndicator(
                        semanticLabel: 'پیشرفت تکمیل فرم',
                        value: 0.6,
                      ),
                    ],
                  );

                  return SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: horizontal ? AppSpacing.xl : AppSpacing.lg,
                      vertical: AppSpacing.lg,
                    ),
                    child: AppCard(
                      header: Text(
                        'گام ۲ از ۳',
                        style: theme.textTheme.labelLarge,
                        textAlign: TextAlign.right,
                      ),
                      footer: Text(
                        'مدارک بارگذاری‌شده باید حداکثر تا پایان امروز تأیید شوند.',
                        style: theme.textTheme.bodySmall,
                        textAlign: TextAlign.right,
                      ),
                      child: cardChild,
                    ),
                  );
                },
              ),
            ),
            _FullScreenActionBar(
              primaryLabel: 'ثبت و ادامه',
              secondaryLabel: 'ذخیرهٔ پیش‌نویس',
              tertiaryLabel: 'بازگشت',
            ),
          ],
        ),
      ),
      bottomNavigationBar: AppNavigationBar(
        destinations: const <AppNavigationDestination>[
          AppNavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'نمای کلی',
          ),
          AppNavigationDestination(
            icon: Icon(Icons.people_alt_outlined),
            selectedIcon: Icon(Icons.people_alt),
            label: 'اعضا',
          ),
          AppNavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'تنظیمات',
          ),
        ],
        currentIndex: 1,
        // Mock navigation callback – the golden simply verifies layout so we
        // document the stubbed handler here for future flows.
        onDestinationSelected: (_) {},
        isLoading: false,
      ),
    );
  }

  Widget _linearProgressIndicator({
    double? value,
    String? description,
    AppComponentStatus tone = AppComponentStatus.neutral,
    bool compact = false,
    String? semanticLabel,
  }) {
    return AppProgressIndicator(
      value: value,
      description: description,
      tone: tone,
      compact: compact,
      circular: false,
      semanticLabel: semanticLabel,
    );
  }
}

class _FullScreenActionBar extends StatelessWidget {
  const _FullScreenActionBar({
    required this.primaryLabel,
    required this.secondaryLabel,
    required this.tertiaryLabel,
  });

  final String primaryLabel;
  final String secondaryLabel;
  final String tertiaryLabel;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final wrap = constraints.maxWidth < 420;
            final children = <Widget>[
              AppButton(
                label: tertiaryLabel,
                onPressed: () {},
                tone: AppComponentStatus.neutral,
                compact: wrap,
              ),
              AppButton(
                label: secondaryLabel,
                onPressed: () {},
                tone: AppComponentStatus.info,
                compact: wrap,
              ),
              AppButton(
                label: primaryLabel,
                onPressed: () {},
                tone: AppComponentStatus.success,
                compact: wrap,
              ),
            ];

            return Wrap(
              alignment: WrapAlignment.end,
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: children,
            );
          },
        ),
      ),
    );
  }
}
