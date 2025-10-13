import 'package:apatie/design_system/components/app_button.dart';
import 'package:apatie/design_system/components/app_card.dart';
import 'package:apatie/design_system/components/app_input_field.dart';
import 'package:apatie/design_system/components/app_list.dart';
import 'package:apatie/design_system/components/app_progress_indicator.dart';
import 'package:apatie/design_system/foundations/radii.dart';
import 'package:apatie/design_system/foundations/spacing.dart';
import 'package:apatie/design_system/utils/accessibility.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppointmentsFullScreenFlow extends StatefulWidget {
  const AppointmentsFullScreenFlow({super.key});

  @override
  State<AppointmentsFullScreenFlow> createState() =>
      _AppointmentsFullScreenFlowState();
}

class _AppointmentsFullScreenFlowState
    extends State<AppointmentsFullScreenFlow> {
  int _currentStep = 0;
  String? _selectedService;
  String? _selectedExpert;
  String? _selectedSlot;
  final TextEditingController _searchController = TextEditingController();

  final List<String> _services = const [
    'مشاورهٔ تغذیهٔ تخصصی',
    'برنامهٔ ورزشی شخصی‌سازی‌شده',
    'پیگیری دورهٔ سلامت قلب',
  ];

  final List<String> _experts = const [
    'دکتر الهام ساجدی – متخصص تغذیه',
    'دکتر میلاد برومند – متخصص قلب',
    'دکتر نازنین رفیعی – فیزیولوژیست ورزشی',
  ];

  final List<String> _timeSlots = const [
    'سه‌شنبه ۲۵ مرداد، ساعت ۱۰:۳۰',
    'چهارشنبه ۲۶ مرداد، ساعت ۱۴:۱۵',
    'پنجشنبه ۲۷ مرداد، ساعت ۰۹:۰۰',
  ];

  void _goNext() {
    if (_currentStep < 2) {
      setState(() => _currentStep += 1);
    }
  }

  void _goBack() {
    if (_currentStep > 0) {
      setState(() => _currentStep -= 1);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Widget _buildStepContent(BuildContext context) {
    switch (_currentStep) {
      case 0:
        return _SelectionStep(
          title: 'مرحلهٔ نخست: انتخاب خدمت موردنظر',
          description:
              'با جست‌وجو و گزینش دقیق، خدمت مناسب را برای مراجعهٔ خود تعیین کنید.',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppInputField(
                label: 'جست‌وجوی خدمات',
                controller: _searchController,
                placeholder: 'عنوان یا کلیدواژهٔ خدمت را وارد کنید',
                helperText:
                    'نتایج پیشنهادی مطابق با دستورالعمل‌های رسمی نمایش داده می‌شود.',
              ),
              const SizedBox(height: AppSpacing.md),
              Expanded(
                child: AppCard(
                  header: Text(
                    'خدمات پیشنهادی',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  child: AppList(
                    items: _services
                        .map(
                          (service) => AppListItem(
                            title: service,
                            selected: _selectedService == service,
                            onTap: () => setState(() => _selectedService = service),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            ],
          ),
        );
      case 1:
        return _SelectionStep(
          title: 'مرحلهٔ دوم: انتخاب متخصص معتمد',
          description:
              'کارشناس هماهنگ‌کنندهٔ مناسب را با مرور گزینه‌های رسمی برگزینید.',
          child: AppCard(
            header: Text(
              'فهرست متخصصان پیشنهادی',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
            child: AppList(
              items: _experts
                  .map(
                    (expert) => AppListItem(
                      title: expert,
                      selected: _selectedExpert == expert,
                      onTap: () => setState(() => _selectedExpert = expert),
                    ),
                  )
                  .toList(),
            ),
          ),
        );
      default:
        return _SelectionStep(
          title: 'مرحلهٔ نهایی: تأیید زمان مراجعه',
          description:
              'زمان پیشنهادی را بررسی کنید تا نوبت به‌صورت رسمی ثبت گردد.',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: AppCard(
                  header: Text(
                    'زمان‌بندی‌های آزاد',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  child: AppList(
                    items: _timeSlots
                        .map(
                          (slot) => AppListItem(
                            title: slot,
                            selected: _selectedSlot == slot,
                            onTap: () => setState(() => _selectedSlot = slot),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              AppCard(
                header: Text(
                  'خلاصهٔ درخواست',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SummaryRow(
                      label: 'خدمت انتخاب‌شده',
                      value: _selectedService ?? 'هنوز انتخاب نشده است',
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    _SummaryRow(
                      label: 'متخصص پیشنهادی',
                      value: _selectedExpert ?? 'هنوز انتخاب نشده است',
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    _SummaryRow(
                      label: 'زمان مراجعه',
                      value: _selectedSlot ?? 'هنوز تعیین نشده است',
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final totalSteps = 3;
    final stepValue = (_currentStep + 1) / totalSteps;
    final numberFormatter = NumberFormat.decimalPattern(Intl.getCurrentLocale());
    final reduceMotion = AccessibilityUtils.reduceMotion(context);
    final switchDuration =
        AccessibilityUtils.motionAwareDuration(context, milliseconds: 180);
    final currentStepLabel = numberFormatter.format(_currentStep + 1);
    final totalStepsLabel = numberFormatter.format(totalSteps);

    return FocusTraversalGroup(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: AppRadii.lgRadius,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'رزرو مرحله‌به‌مرحلهٔ نوبت رسمی',
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'فرم چندگام با رعایت محدودیت کنش‌های اصلی و بدون پیمایش تو‌در‌تو طراحی شده است.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: AppSpacing.md),
                AppProgressIndicator(
                  value: stepValue,
                  description:
                      'مرحلهٔ $currentStepLabel از $totalStepsLabel با الزام پیام‌های فارسی رسمی',
                ),
                const SizedBox(height: AppSpacing.lg),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: switchDuration,
                    transitionBuilder: (child, animation) {
                      if (reduceMotion) {
                        return child;
                      }
                      return FadeTransition(
                        opacity: animation,
                        child: child,
                      );
                    },
                    child: _buildStepContent(context),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (_currentStep > 0) ...[
                      AppButton(
                        label: 'بازگشت',
                        onPressed: _goBack,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                    ],
                    AppButton(
                      label: _currentStep == 2 ? 'ثبت نهایی نوبت' : 'ادامه',
                      onPressed: _goNext,
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _SelectionStep extends StatelessWidget {
  const _SelectionStep({
    required this.title,
    required this.description,
    required this.child,
  });

  final String title;
  final String description;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          title,
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          description,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: AppSpacing.md),
        Expanded(child: child),
      ],
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          flex: 3,
          child: Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }
}

class AppointmentsFullScreenFlowPage extends StatelessWidget {
  const AppointmentsFullScreenFlowPage({super.key});

  static const String routeName = 'appointmentsFullScreenFlow';
  static const String routePath = 'full-screen-flow';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: const [
            Expanded(child: AppointmentsFullScreenFlow()),
          ],
        ),
      ),
    );
  }
}
