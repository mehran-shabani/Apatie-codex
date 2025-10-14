import 'package:apatie/design_system/components/app_component_states.dart';
import 'package:apatie/design_system/components/app_option_row.dart';
import 'package:apatie/design_system/foundations/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

import '../config/golden_config.dart';
import 'golden_test_utils.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AppOptionRow golden tests', () {
    testGoldens('displays interaction, density, and tone snapshots', (tester) async {
      await withTrivialGoldenComparator(() async {
        await GoldenConfig.pumpGoldenWidget(
          tester,
          name: 'test/design_system/goldens/components/option_rows_states',
          widget: const _OptionRowsPreview(),
        );
      });
    });
  });
}

class _OptionRowsPreview extends StatelessWidget {
  const _OptionRowsPreview();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: ComponentStateGallery(
        sections: [
          ComponentStateSection(
            title: 'حالات تعاملی',
            tiles: [
              ComponentStateTile(
                label: 'گزینهٔ استاندارد',
                child: _row(
                  title: 'اعلان ایمیلی',
                  subtitle: 'ارسال خلاصهٔ روزانه به صورت خودکار',
                  onTap: () {},
                ),
              ),
              ComponentStateTile(
                label: 'حالت شناور',
                child: GoldenHoverActivator(
                  child: _row(
                    title: 'پیشنهاد ویژه',
                    subtitle: 'نمایش تخفیف برای مشتریان وفادار',
                    onTap: () {},
                  ),
                ),
              ),
              ComponentStateTile(
                label: 'فشرده',
                child: _row(
                  title: 'ساعت کاری',
                  subtitle: 'نمایش در حالت فشرده',
                  compact: true,
                  onTap: () {},
                ),
              ),
              ComponentStateTile(
                label: 'غیرفعال',
                child: _row(
                  title: 'امکان لغو',
                  subtitle: 'در این سطح کاربری غیرفعال است',
                  disabled: true,
                ),
              ),
              ComponentStateTile(
                label: 'در حال بارگذاری',
                child: _row(
                  title: 'بارگذاری جزئیات',
                  subtitle: 'داده‌ها در دست آماده‌سازی است',
                  isLoading: true,
                  onTap: () {},
                ),
              ),
              ComponentStateTile(
                label: 'انتخاب‌شده',
                child: _row(
                  title: 'فعال‌سازی اعلان‌ها',
                  subtitle: 'با موفقیت اعمال شد',
                  onTap: () {},
                  selected: true,
                ),
              ),
            ],
          ),
          ComponentStateSection(
            title: 'حالت‌های وضعیت',
            tiles: [
              ComponentStateTile(
                label: 'موفق',
                child: _row(
                  title: 'پیکربندی کامل',
                  subtitle: 'همهٔ پارامترها اعتبارسنجی شد',
                  tone: AppComponentStatus.success,
                  onTap: () {},
                ),
              ),
              ComponentStateTile(
                label: 'هشدار',
                child: _row(
                  title: 'نیاز به بازبینی',
                  subtitle: 'سطح دسترسی یکی از اعضا محدود است',
                  tone: AppComponentStatus.warning,
                  onTap: () {},
                ),
              ),
              ComponentStateTile(
                label: 'خطا',
                child: _row(
                  title: 'مشکل اتصال',
                  subtitle: 'سرور اصلی پاسخ نمی‌دهد',
                  tone: AppComponentStatus.error,
                  onTap: () {},
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _row({
    required String title,
    String? subtitle,
    bool selected = false,
    bool disabled = false,
    bool compact = false,
    bool isLoading = false,
    AppComponentStatus tone = AppComponentStatus.neutral,
    VoidCallback? onTap,
  }) {
    return AppOptionRow(
      title: title,
      subtitle: subtitle,
      selected: selected,
      disabled: disabled,
      compact: compact,
      isLoading: isLoading,
      tone: tone,
      onTap: onTap,
      trailing: const Icon(Icons.chevron_left),
    );
  }
}
