import 'package:apatie/design_system/components/app_button.dart';
import 'package:apatie/design_system/components/app_component_states.dart';
import 'package:apatie/design_system/foundations/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

import '../config/golden_config.dart';
import 'golden_test_utils.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AppButton golden tests', () {
    testGoldens('renders interaction and status states side by side',
        (tester) async {
      await withTrivialGoldenComparator(() async {
        await GoldenConfig.pumpGoldenWidget(
          tester,
          name:
              'test/design_system/goldens/components/buttons_interaction_states',
          widget: const _ButtonsPreview(),
        );
      });
    });
  });
}

class _ButtonsPreview extends StatelessWidget {
  const _ButtonsPreview();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: ComponentStateGallery(
        sections: [
          ComponentStateSection(
            title: 'حالت‌های تعاملی دکمه',
            tiles: [
              ComponentStateTile(
                label: 'استاندارد',
                child: AppButton(
                  label: 'ارسال',
                  onPressed: () {},
                ),
              ),
              ComponentStateTile(
                label: 'حالت شناور',
                child: GoldenHoverActivator(
                  child: AppButton(
                    label: 'شناور',
                    onPressed: () {},
                  ),
                ),
              ),
              ComponentStateTile(
                label: 'نسخهٔ فشرده',
                child: AppButton(
                  label: 'گزینهٔ سریع',
                  compact: true,
                  onPressed: () {},
                ),
              ),
              const ComponentStateTile(
                label: 'غیرفعال',
                child: AppButton(
                  label: 'در دسترس نیست',
                  onPressed: null,
                ),
              ),
              ComponentStateTile(
                label: 'در حال بارگذاری',
                child: AppButton(
                  label: 'ارسال',
                  onPressed: () {},
                  isLoading: true,
                ),
              ),
            ],
          ),
          ComponentStateSection(
            title: 'حالت‌های وضعیت',
            tiles: [
              ComponentStateTile(
                label: 'موفق',
                child: AppButton(
                  label: 'موفقیت',
                  onPressed: () {},
                  tone: AppComponentStatus.success,
                ),
              ),
              ComponentStateTile(
                label: 'هشدار',
                child: AppButton(
                  label: 'هشدار',
                  onPressed: () {},
                  tone: AppComponentStatus.warning,
                ),
              ),
              ComponentStateTile(
                label: 'خطا',
                child: AppButton(
                  label: 'خطا',
                  onPressed: () {},
                  tone: AppComponentStatus.error,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
