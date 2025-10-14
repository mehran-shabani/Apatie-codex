import 'package:apatie/design_system/components/app_button.dart';
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
    testGoldens('renders notification variants', (tester) async {
      await withTrivialGoldenComparator(() async {
        await GoldenConfig.pumpGoldenWidget(
          tester,
          name: 'design_system/components/notifications',
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppNotification(
            title: 'به‌روزرسانی موفق',
            message: 'پیکربندی جدید با موفقیت اعمال شد.',
            tone: AppComponentStatus.success,
            leading: const Icon(Icons.check_circle_outline),
            actions: [
              AppButton(
                label: 'مشاهده گزارش',
                onPressed: () {},
                compact: true,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          AppNotification(
            title: 'هشدار امنیتی',
            message: 'تلاش ورود مشکوک شناسایی شده است.',
            tone: AppComponentStatus.warning,
            leading: const Icon(Icons.security),
            actions: [
              AppButton(
                label: 'بررسی',
                onPressed: () {},
                compact: true,
              ),
              AppButton(
                label: 'نادیده گرفتن',
                onPressed: () {},
                compact: true,
                tone: AppComponentStatus.neutral,
              ),
            ],
            onDismiss: () {},
          ),
          const SizedBox(height: AppSpacing.lg),
          AppNotification(
            title: 'پیام اطلاعاتی',
            message: 'سرور گزارش روزانه را ارسال کرد.',
            tone: AppComponentStatus.info,
            compact: true,
            leading: const Icon(Icons.info_outline),
          ),
          const SizedBox(height: AppSpacing.lg),
          const AppNotification(
            title: 'خطای سامانه',
            message: 'ارتباط با پایگاه داده برقرار نشد.',
            tone: AppComponentStatus.error,
          ),
        ],
      ),
    );
  }
}
