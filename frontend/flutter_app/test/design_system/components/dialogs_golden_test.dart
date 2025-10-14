import 'package:apatie/design_system/components/app_button.dart';
import 'package:apatie/design_system/components/app_component_states.dart';
import 'package:apatie/design_system/components/app_dialog.dart';
import 'package:apatie/design_system/foundations/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

import '../config/golden_config.dart';
import 'golden_test_utils.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AppDialog golden tests', () {
    testGoldens('shows tone, compact, and loading variations', (tester) async {
      await withTrivialGoldenComparator(() async {
        await GoldenConfig.pumpGoldenWidget(
          tester,
          name: 'test/design_system/goldens/components/dialogs_variants',
          widget: const _DialogsPreview(),
        );
      });
    });
  });
}

class _DialogsPreview extends StatelessWidget {
  const _DialogsPreview();

  @override
  Widget build(BuildContext context) {
    return ComponentStateGallery(
      sections: [
        ComponentStateSection(
          title: 'پیکربندی‌های پایه',
          tiles: [
            ComponentStateTile(
              label: 'کادر استاندارد',
              child: _dialogSample(
                context,
                title: 'تأیید عملیات',
                content:
                    'آیا از ذخیرهٔ تغییرات در پروندهٔ جاری اطمینان دارید؟',
                actions: _dialogActions(context),
              ),
            ),
            ComponentStateTile(
              label: 'نسخهٔ فشرده',
              child: _dialogSample(
                context,
                title: 'تغییر سریع',
                compact: true,
                content: 'این الگو برای صفحات با ارتفاع محدود استفاده می‌شود.',
                actions: _dialogActions(context),
              ),
            ),
            ComponentStateTile(
              label: 'در حال بارگذاری',
              child: _dialogSample(
                context,
                title: 'در حال ارسال درخواست',
                isLoading: true,
                content: 'برای تکمیل درخواست چند ثانیه صبر کنید.',
                actions: _dialogActions(context),
              ),
            ),
          ],
        ),
        ComponentStateSection(
          title: 'حالت‌های وضعیت',
          tiles: [
            ComponentStateTile(
              label: 'موفق',
              child: _dialogSample(
                context,
                title: 'عملیات با موفقیت انجام شد',
                tone: AppComponentStatus.success,
                content: 'سفارش شما ثبت شده و در حال پردازش است.',
                actions: _dialogActions(context),
              ),
            ),
            ComponentStateTile(
              label: 'هشدار',
              child: _dialogSample(
                context,
                title: 'محدودیت دسترسی',
                tone: AppComponentStatus.warning,
                content: 'برای ادامه باید نقش کاربری خود را ارتقا دهید.',
                actions: _dialogActions(context),
              ),
            ),
            ComponentStateTile(
              label: 'خطا',
              child: _dialogSample(
                context,
                title: 'فرآیند ناموفق',
                tone: AppComponentStatus.error,
                content: 'در ذخیره‌سازی داده‌ها مشکلی رخ داده است.',
                actions: _dialogActions(context),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _dialogSample(
    BuildContext context, {
    required String title,
    required String content,
    List<Widget>? actions,
    AppComponentStatus tone = AppComponentStatus.neutral,
    bool compact = false,
    bool isLoading = false,
  }) {
    return Align(
      alignment: Alignment.center,
      child: AppDialog(
        title: title,
        content: Text(
          content,
          textAlign: TextAlign.right,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        actions: actions ?? const <Widget>[],
        tone: tone,
        compact: compact,
        isLoading: isLoading,
      ),
    );
  }

  List<Widget> _dialogActions(BuildContext context) {
    return [
      AppButton(label: 'لغو', onPressed: () {}),
      AppButton(label: 'تأیید', onPressed: () {}),
    ];
  }
}
