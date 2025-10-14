import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:apatie/design_system/components/app_button.dart';
import 'package:apatie/design_system/foundations/spacing.dart';
import 'package:apatie/l10n/app_localizations.dart';
import 'package:apatie/modules/appointments/ui/patterns/full_screen_flow/appointments_full_screen_flow.dart';
import 'package:apatie/modules/services/ui/patterns/floating_window/services_floating_window_pattern.dart';
import 'package:apatie/modules/services/ui/screens/services_page.dart';

class AppointmentsPage extends StatelessWidget {
  const AppointmentsPage({super.key});

  static const String routeName = 'appointments';
  static const String routePath = '/appointments';

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              localizations.appointmentsHeadline,
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'برای رزرو رسمی نوبت، فرم چندگام زیر با پیام‌های فارسی و حداقل دو کنش اصلی طراحی شده است.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: AppSpacing.lg),
            ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 420, maxHeight: 720),
              child: const AppointmentsFullScreenFlow(),
            ),
            const SizedBox(height: AppSpacing.md),
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: AppButton(
                label: 'مشاهدهٔ نسخهٔ تمام‌صفحه',
                onPressed: () => context.push(
                  '${AppointmentsPage.routePath}/${AppointmentsFullScreenFlowPage.routePath}',
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            Text(
              'پس از ثبت نوبت می‌توانید از پایش زنده برای کنترل وضعیت استفاده کنید.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: AppSpacing.sm),
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: AppButton(
                label: 'نمایش پایش زندهٔ خدمات',
                onPressed: () => context.go(
                  '${ServicesPage.routePath}/${ServicesFloatingWindowPatternPage.routePath}',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
