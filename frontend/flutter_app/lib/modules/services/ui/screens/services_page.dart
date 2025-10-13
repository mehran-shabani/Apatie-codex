import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:apatie/design_system/components/app_button.dart';
import 'package:apatie/design_system/foundations/spacing.dart';
import 'package:apatie/l10n/app_localizations.dart';
import 'package:apatie/modules/services/ui/patterns/floating_window/services_floating_window_pattern.dart';

class ServicesPage extends StatelessWidget {
  const ServicesPage({super.key});

  static const String routeName = 'services';
  static const String routePath = '/services';

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
              localizations.servicesHeadline,
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'پایش زنده باید دسترسی آسان، پیام‌های رسمی و حداکثر دو کنش اصلی داشته باشد.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: AppSpacing.xl),
            ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 360, maxHeight: 520),
              child: const ServicesFloatingWindowPattern(),
            ),
            const SizedBox(height: AppSpacing.md),
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: AppButton(
                label: 'نمایش پنجرهٔ شناور در مسیر مستقل',
                onPressed: () => context.push(
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
