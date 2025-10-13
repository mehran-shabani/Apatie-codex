import 'package:flutter/material.dart';
import 'package:apatie/design_system/components/app_button.dart';
import 'package:apatie/design_system/components/app_card.dart';
import 'package:apatie/design_system/components/app_component_states.dart';
import 'package:apatie/design_system/components/app_input_field.dart';
import 'package:apatie/design_system/components/app_label.dart';
import 'package:apatie/design_system/components/app_progress_indicator.dart';
import 'package:apatie/design_system/foundations/spacing.dart';

class MarketplaceHorizontalCardBar extends StatefulWidget {
  const MarketplaceHorizontalCardBar({super.key});

  @override
  State<MarketplaceHorizontalCardBar> createState() =>
      _MarketplaceHorizontalCardBarState();
}

class _MarketplaceHorizontalCardBarState
    extends State<MarketplaceHorizontalCardBar> {
  final TextEditingController _searchController = TextEditingController();
  int _highlightedIndex = 0;

  final List<_MarketplacePackage> _packages = const [
    _MarketplacePackage(
      title: 'پکیج غربالگری قلب و عروق',
      description:
          'شامل ارزیابی نوار قلب، آزمایش خون و مشاورهٔ تخصصی با گزارش رسمی.',
      status: 'ظرفیت امروز محدود است',
      price: '۲٬۹۵۰٬۰۰۰ ریال',
    ),
    _MarketplacePackage(
      title: 'برنامهٔ تغذیهٔ شخصی',
      description:
          'تنظیم برنامهٔ سه‌مرحله‌ای با پایش دوره‌ای توسط متخصص ارشد.',
      status: 'پیشنهاد ویژهٔ هفته',
      price: '۱٬۷۵۰٬۰۰۰ ریال',
    ),
    _MarketplacePackage(
      title: 'جلسهٔ تمرین تنفسی آنلاین',
      description:
          'دورهٔ ۴۵ دقیقه‌ای با مربی معتبر و ارائهٔ دستورالعمل کتبی.',
      status: 'ظرفیت آزاد',
      price: '۹۸۰٬۰۰۰ ریال',
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _handleHighlight(int index) {
    setState(() => _highlightedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Semantics(
      container: true,
      label: 'نوار افقی کارت‌ها برای جست‌وجو و گزینش رسمی',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'جست‌وجو و گزینش خدمت مناسب',
            style: theme.textTheme.titleLarge
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'با استفاده از نوار افقی کارت‌ها می‌توانید پیشنهادها را مرور و گزینهٔ مناسب را انتخاب کنید.',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: AppSpacing.md),
          AppInputField(
            label: 'عبارت جست‌وجو',
            controller: _searchController,
            placeholder: 'مثال: برنامهٔ تغذیه یا پایش قلب',
            helperText:
                'حداکثر دو کنش اصلی در هر کارت فعال است و پیمایش تو‌در‌تو وجود ندارد.',
          ),
          const SizedBox(height: AppSpacing.lg),
          SizedBox(
            height: 280,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
              itemBuilder: (context, index) {
                final package = _packages[index];
                final selected = _highlightedIndex == index;
                return SizedBox(
                  width: 320,
                  child: AppCard(
                    semanticLabel: 'گزینهٔ ${package.title}',
                    tone:
                        selected ? AppComponentStatus.success : AppComponentStatus.neutral,
                    header: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          package.title,
                          style: theme.textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        AppLabel(
                          text: package.status,
                          tone: selected
                              ? AppComponentStatus.success
                              : AppComponentStatus.info,
                          semanticLabel: 'وضعیت پیشنهاد: ${package.status}',
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          package.description,
                          style: theme.textTheme.bodyMedium,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Text(
                          'هزینهٔ نهایی: ${package.price}',
                          style: theme.textTheme.titleMedium,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        AppProgressIndicator(
                          value: selected ? 0.9 : 0.6,
                          description: selected
                              ? 'پس از انتخاب می‌توانید سفارش را نهایی کنید.'
                              : 'برای مقایسهٔ دقیق گزینه‌ها را مرور کنید.',
                          compact: true,
                        ),
                      ],
                    ),
                    footer: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        AppButton(
                          label: 'افزودن به بررسی',
                          onPressed: () => _handleHighlight(index),
                          compact: true,
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        AppButton(
                          label: 'انتخاب فوری',
                          onPressed: () => _handleHighlight(index),
                          tone: AppComponentStatus.success,
                          compact: true,
                        ),
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) => const SizedBox(width: AppSpacing.md),
              itemCount: _packages.length,
            ),
          ),
        ],
      ),
    );
  }
}

class _MarketplacePackage {
  const _MarketplacePackage({
    required this.title,
    required this.description,
    required this.status,
    required this.price,
  });

  final String title;
  final String description;
  final String status;
  final String price;
}

class MarketplaceHorizontalCardBarPage extends StatelessWidget {
  const MarketplaceHorizontalCardBarPage({super.key});

  static const String routeName = 'marketplaceHorizontalCardBar';
  static const String routePath = 'horizontal-card-bar';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: const MarketplaceHorizontalCardBar(),
      ),
    );
  }
}
