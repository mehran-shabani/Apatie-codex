import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:apatie/design_system/components/app_button.dart';
import 'package:apatie/design_system/foundations/spacing.dart';
import 'package:apatie/l10n/app_localizations.dart';
import 'package:apatie/modules/marketplace/ui/patterns/dialog_card/marketplace_dialog_card_pattern.dart';
import 'package:apatie/modules/marketplace/ui/patterns/horizontal_card_bar/marketplace_horizontal_card_bar.dart';

class MarketplacePage extends StatelessWidget {
  const MarketplacePage({super.key});

  static const String routeName = 'marketplace';
  static const String routePath = '/marketplace';

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
              localizations.marketplaceHeadline,
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'جست‌وجو و گزینش خدمات باید با پیام‌های رسمی، بدون پیمایش تو‌در‌تو و با حداکثر دو کنش اصلی انجام شود.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: AppSpacing.xl),
            const MarketplaceHorizontalCardBar(),
            const SizedBox(height: AppSpacing.md),
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: AppButton(
                label: 'نمایش نوار کارت‌ها در مسیر مستقل',
                onPressed: () => context.push(
                  '${MarketplacePage.routePath}/${MarketplaceHorizontalCardBarPage.routePath}',
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            const MarketplaceDialogCardPattern(),
            const SizedBox(height: AppSpacing.md),
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: AppButton(
                label: 'باز کردن نمونهٔ گفت‌وگو',
                onPressed: () => context.push(
                  '${MarketplacePage.routePath}/${MarketplaceDialogCardPatternPage.routePath}',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
