import 'package:flutter/material.dart';
import 'package:apatie/design_system/components/app_button.dart';
import 'package:apatie/design_system/components/app_card.dart';
import 'package:apatie/design_system/components/app_component_states.dart';
import 'package:apatie/design_system/components/app_dialog.dart';
import 'package:apatie/design_system/components/app_label.dart';
import 'package:apatie/design_system/foundations/spacing.dart';

class MarketplaceDialogCardPattern extends StatelessWidget {
  const MarketplaceDialogCardPattern({super.key});

  Future<void> _showDetails(BuildContext context) async {
    final theme = Theme.of(context);

    await AppDialog.show(
      context: context,
      title: 'جزئیات رسمی خدمت انتخاب‌شده',
      semanticLabel: 'گفت‌وگوی رسمی برای بررسی کارت خدمت',
      content: AppCard(
        compact: true,
        tone: AppComponentStatus.info,
        header: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'جلسهٔ ارزیابی جامع سلامت',
              style: theme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: AppSpacing.xs),
            AppLabel(
              text: 'گزارش رسمی ظرف ۲۴ ساعت ارسال می‌شود',
              tone: AppComponentStatus.info,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'کارت اطلاعاتی شامل مراحل آماده‌سازی، مدارک موردنیاز و مدت‌زمان تقریبی اجرای خدمت است. '
              'تمام پیام‌ها به‌صورت فارسی رسمی نگاشته شده‌اند تا ابهامی ایجاد نشود.',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'شرح مزایا:',
              style: theme.textTheme.titleSmall
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              '• هماهنگی هوشمند با متخصصان موردتأیید \n'
              '• امکان دریافت مشاورهٔ تکمیلی پس از جلسه \n'
              '• تضمین بازپرداخت در صورت لغو رسمی',
              style: theme.textTheme.bodyMedium,
            ),
          ],
        ),
        footer: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            AppButton(
              label: 'افزودن به مقایسه',
              compact: true,
              onPressed: () => Navigator.of(context).pop('compare'),
            ),
            const SizedBox(width: AppSpacing.sm),
            AppButton(
              label: 'تأیید انتخاب',
              compact: true,
              tone: AppComponentStatus.success,
              onPressed: () => Navigator.of(context).pop('confirm'),
            ),
          ],
        ),
      ),
      actions: const <Widget>[],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'بررسی چند گزینه در قالب گفت‌وگو',
          style:
              theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'کارت اطلاعاتی داخل گفت‌وگو امکان مرور دقیق و تصمیم‌گیری رسمی را فراهم می‌کند.',
          style: theme.textTheme.bodyMedium,
        ),
        const SizedBox(height: AppSpacing.md),
        AppButton(
          label: 'مشاهدهٔ کارت در گفت‌وگو',
          onPressed: () => _showDetails(context),
        ),
      ],
    );
  }
}

class MarketplaceDialogCardPatternPage extends StatelessWidget {
  const MarketplaceDialogCardPatternPage({super.key});

  static const String routeName = 'marketplaceDialogCard';
  static const String routePath = 'dialog-card';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: const MarketplaceDialogCardPattern(),
      ),
    );
  }
}
