import 'package:apatie/design_system/components/app_button.dart';
import 'package:apatie/design_system/components/app_card.dart';
import 'package:apatie/design_system/components/app_component_states.dart';
import 'package:apatie/design_system/components/app_label.dart';
import 'package:apatie/design_system/components/app_progress_indicator.dart';
import 'package:apatie/design_system/foundations/radii.dart';
import 'package:apatie/design_system/foundations/spacing.dart';
import 'package:apatie/design_system/utils/accessibility.dart';
import 'package:flutter/material.dart';

class ServicesFloatingWindowPattern extends StatefulWidget {
  const ServicesFloatingWindowPattern({super.key});

  @override
  State<ServicesFloatingWindowPattern> createState() =>
      _ServicesFloatingWindowPatternState();
}

class _ServicesFloatingWindowPatternState
    extends State<ServicesFloatingWindowPattern> {
  Offset _offset = const Offset(AppSpacing.lg, AppSpacing.lg);
  bool _minimized = false;

  void _toggleMinimize() {
    setState(() => _minimized = !_minimized);
  }

  void _finishMonitoring(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('پایش زنده با موفقیت پایان یافت.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final reduceMotion = AccessibilityUtils.reduceMotion(context);
    final windowAnimationDuration =
        AccessibilityUtils.motionAwareDuration(context, milliseconds: 180);

    return LayoutBuilder(
      builder: (context, constraints) {
        const double windowWidth = 320;
        final double windowHeight = _minimized ? 140 : 260;
        final double maxX = (constraints.maxWidth - windowWidth).clamp(0.0, double.infinity);
        final double maxY = (constraints.maxHeight - windowHeight).clamp(0.0, double.infinity);
        final Offset effectiveOffset = Offset(
          _offset.dx.clamp(0, maxX),
          _offset.dy.clamp(0, maxY),
        );

        return Stack(
          children: [
            AppCard(
              header: Text(
                'پایش زندهٔ سرویس‌های فعال',
                style: theme.textTheme.titleLarge
                    ?.copyWith(fontWeight: FontWeight.w600),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'در این نما وضعیت سرویس‌های حیاتی به شکل رسمی و قابل‌اتکا نمایش داده می‌شود. '
                    'برای مشاهدهٔ جزئیات یک سرویس، پنجرهٔ شناور را جابه‌جا کنید.',
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AppLabel(
                    text: 'آخرین به‌روزرسانی: کمتر از ۳۰ ثانیه پیش',
                    tone: AppComponentStatus.success,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  AppProgressIndicator(
                    value: 0.75,
                    description: 'پایش کلی سامانه با اطمینان ۷۵ درصد تکمیل شده است.',
                  ),
                ],
              ),
            ),
            Positioned(
              left: effectiveOffset.dx,
              top: effectiveOffset.dy,
              child: GestureDetector(
                onPanUpdate: (details) {
                  setState(() {
                    final double nextX = (_offset.dx + details.delta.dx).clamp(0, maxX);
                    final double nextY = (_offset.dy + details.delta.dy).clamp(0, maxY);
                    _offset = Offset(nextX, nextY);
                  });
                },
                child: Semantics(
                  container: true,
                  label: 'پنجرهٔ شناور برای پایش زنده',
                  child: AnimatedContainer(
                    duration: windowAnimationDuration,
                    curve: reduceMotion ? Curves.linear : Curves.easeInOut,
                    width: windowWidth,
                    height: windowHeight,
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceVariant,
                      borderRadius: AppRadii.lgRadius,
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 16,
                          offset: Offset(0, 4),
                          color: Color(0x33000000),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'پایش زندهٔ سرویس پشتیبانی',
                              style: theme.textTheme.titleSmall
                                  ?.copyWith(fontWeight: FontWeight.w600),
                            ),
                            AppLabel(
                              text: _minimized ? 'حالت فشرده' : 'فعال',
                              tone: _minimized
                                  ? AppComponentStatus.warning
                                  : AppComponentStatus.success,
                              compact: true,
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Expanded(
                          child: _minimized
                              ? Center(
                                  child: Text(
                                    'پنجره در حالت فشرده قرار دارد. برای مشاهدهٔ جزئیات روی «بازگشایی» بزنید.',
                                    style: theme.textTheme.bodySmall,
                                    textAlign: TextAlign.center,
                                  ),
                                )
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'زمان پاسخ‌گویی متوسط: ۱ دقیقه و ۴۵ ثانیه',
                                      style: theme.textTheme.bodyMedium,
                                    ),
                                    const SizedBox(height: AppSpacing.sm),
                                    AppProgressIndicator(
                                      value: 0.45,
                                      compact: true,
                                      description:
                                          'در حال پردازش درخواست‌های فوری کاربران سازمانی.',
                                      tone: AppComponentStatus.info,
                                    ),
                                    const SizedBox(height: AppSpacing.sm),
                                    Text(
                                      'آخرین پیام رسمی: «درخواست شماره ۹۸۶ در حال بررسی نهایی است.»',
                                      style: theme.textTheme.bodySmall,
                                    ),
                                  ],
                                ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            AppButton(
                              label: _minimized ? 'بازگشایی پنجره' : 'کوچک‌سازی',
                              compact: true,
                              onPressed: _toggleMinimize,
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            AppButton(
                              label: 'پایان پایش',
                              compact: true,
                              tone: AppComponentStatus.error,
                              onPressed: () => _finishMonitoring(context),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class ServicesFloatingWindowPatternPage extends StatelessWidget {
  const ServicesFloatingWindowPatternPage({super.key});

  static const String routeName = 'servicesFloatingWindow';
  static const String routePath = 'floating-window';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: const ServicesFloatingWindowPattern(),
      ),
    );
  }
}
