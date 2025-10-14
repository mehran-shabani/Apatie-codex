import 'package:apatie/design_system/components/app_component_states.dart';
import 'package:apatie/design_system/components/app_notification.dart';
import 'package:apatie/design_system/foundations/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

import '../config/golden_config.dart';
import 'golden_test_utils.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AppNotification golden tests', () {
    testGoldens('captures tone, density, and dismissible variants', (tester) async {
      await withTrivialGoldenComparator(() async {
        await GoldenConfig.pumpGoldenWidget(
          tester,
          name:
              'test/design_system/goldens/components/notifications_state_matrix',
          widget: const _NotificationsPreview(),
        );
      });
    });
  });
}

class _NotificationsPreview extends StatelessWidget {
  const _NotificationsPreview();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: ComponentStateGallery(
        sections: [
          ComponentStateSection(
            title: 'پیکربندی‌های پایه',
            tiles: [
              ComponentStateTile(
                label: 'اعلان استاندارد',
                child: _notification(
                  context,
                  title: 'به‌روزرسانی سامانه',
                  message: 'نسخهٔ جدید در دسترس است. برای مشاهده روی جزئیات کلیک کنید.',
                ),
              ),
              ComponentStateTile(
                label: 'نسخهٔ فشرده',
                child: _notification(
                  context,
                  title: 'خبر فوری',
                  message: 'درخواست شما دریافت شد.',
                  compact: true,
                ),
              ),
              ComponentStateTile(
                label: 'دارای دکمه و آیکن',
                child: _notification(
                  context,
                  title: 'پیوند جدید',
                  message: 'جلسهٔ امروز به ساعت ۱۵ منتقل شد.',
                  leading: const Icon(Icons.calendar_today),
                  actions: [
                    TextButton(onPressed: () {}, child: const Text('مشاهده جزئیات')),
                  ],
                  onDismiss: () {},
                ),
              ),
            ],
          ),
          ComponentStateSection(
            title: 'حالت‌های وضعیت',
            tiles: [
              ComponentStateTile(
                label: 'موفق',
                child: _notification(
                  context,
                  title: 'عملیات موفق',
                  message: 'سفارش با موفقیت ثبت شد.',
                  tone: AppComponentStatus.success,
                ),
              ),
              ComponentStateTile(
                label: 'هشدار',
                child: _notification(
                  context,
                  title: 'نیاز به اقدام',
                  message: 'مهلت ارسال مدارک رو به پایان است.',
                  tone: AppComponentStatus.warning,
                ),
              ),
              ComponentStateTile(
                label: 'خطا',
                child: _notification(
                  context,
                  title: 'خطای سیستمی',
                  message: 'در اتصال به سرور مشکلی رخ داد.',
                  tone: AppComponentStatus.error,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _notification(
    BuildContext context, {
    required String title,
    required String message,
    AppComponentStatus tone = AppComponentStatus.info,
    bool compact = false,
    Widget? leading,
    List<Widget> actions = const <Widget>[],
    VoidCallback? onDismiss,
  }) {
    return AppNotification(
      title: title,
      message: message,
      tone: tone,
      compact: compact,
      leading: leading,
      actions: actions,
      onDismiss: onDismiss,
    );
  }
}
