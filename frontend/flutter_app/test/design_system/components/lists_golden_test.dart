import 'package:apatie/design_system/components/app_component_states.dart';
import 'package:apatie/design_system/components/app_list.dart';
import 'package:apatie/design_system/foundations/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

import '../config/golden_config.dart';
import 'golden_test_utils.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AppList golden tests', () {
    testGoldens('presents selectable, hovered, and statusful rows', (tester) async {
      await GoldenConfig.pumpGoldenWidget(
        tester,
        name: 'test/design_system/goldens/components/lists_state_showcase',
        widget: const _ListsPreview(),
      );
    });
  });
}

class _ListsPreview extends StatelessWidget {
  const _ListsPreview();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: ComponentStateGallery(
        sections: [
          ComponentStateSection(
            title: 'حالت‌های تعاملی آیتم‌ها',
            tiles: [
              ComponentStateTile(
                label: 'لیست استاندارد',
                child: _buildList(
                  context,
                  items: [
                    _item('جزئیات مشتری', subtitle: 'آخرین فعالیت در ۲۴ ساعت گذشته'),
                    _item('یادداشت داخلی', subtitle: 'افزوده شده توسط تیم فروش'),
                  ],
                ),
              ),
              ComponentStateTile(
                label: 'گزینهٔ شناور',
                child: GoldenHoverActivator(
                  child: _buildList(
                    context,
                    items: [
                      _item('در حال بررسی', subtitle: 'منتظر تأیید', interactive: true),
                    ],
                  ),
                ),
              ),
              ComponentStateTile(
                label: 'نسخهٔ فشرده',
                child: _buildList(
                  context,
                  items: [
                    _item('وظیفهٔ سریع', compact: true, subtitle: 'زمان پاسخ: ۳۰ دقیقه'),
                    _item('وظیفهٔ دوم', compact: true, subtitle: 'زمان پاسخ: ۴۵ دقیقه'),
                  ],
                ),
              ),
              ComponentStateTile(
                label: 'آیتم غیرفعال',
                child: _buildList(
                  context,
                  items: [
                    _item('دسترسی محدود', disabled: true, subtitle: 'برای مشاهده مجوز لازم است'),
                  ],
                ),
              ),
              ComponentStateTile(
                label: 'نمایش بارگذاری',
                child: _buildList(
                  context,
                  items: [
                    _item('در حال همگام‌سازی', isLoading: true, subtitle: 'صبر کنید...'),
                  ],
                ),
              ),
            ],
          ),
          ComponentStateSection(
            title: 'حالات وضعیت',
            tiles: [
              ComponentStateTile(
                label: 'موفق و انتخاب‌شده',
                child: _buildList(
                  context,
                  items: [
                    _item(
                      'خروجی نهایی',
                      subtitle: 'توسط ناظر تأیید شد',
                      selected: true,
                      tone: AppComponentStatus.success,
                    ),
                  ],
                ),
              ),
              ComponentStateTile(
                label: 'هشدار',
                child: _buildList(
                  context,
                  items: [
                    _item(
                      'نیاز به بازبینی',
                      subtitle: 'مهلت تا ۱۲ ساعت دیگر',
                      tone: AppComponentStatus.warning,
                    ),
                  ],
                ),
              ),
              ComponentStateTile(
                label: 'خطا',
                child: _buildList(
                  context,
                  items: [
                    _item(
                      'پردازش ناموفق',
                      subtitle: 'جزئیات خطا برای بررسی موجود است',
                      tone: AppComponentStatus.error,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildList(
    BuildContext context, {
    required List<AppListItem> items,
  }) {
    return AppList(
      items: items,
      separated: true,
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
    );
  }

  AppListItem _item(
    String title, {
    String? subtitle,
    bool selected = false,
    bool disabled = false,
    bool compact = false,
    bool isLoading = false,
    bool interactive = false,
    AppComponentStatus tone = AppComponentStatus.neutral,
  }) {
    return AppListItem(
      title: title,
      subtitle: subtitle,
      selected: selected,
      disabled: disabled,
      compact: compact,
      isLoading: isLoading,
      tone: tone,
      onTap: interactive ? () {} : null,
      trailing: const Icon(Icons.chevron_left),
    );
  }
}
