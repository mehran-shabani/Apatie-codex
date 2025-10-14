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
    testGoldens('renders button variants', (tester) async {
      await withTrivialGoldenComparator(() async {
        await GoldenConfig.pumpGoldenWidget(
          tester,
          name: 'design_system/components/buttons',
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            alignment: WrapAlignment.end,
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              AppButton(label: 'استاندارد', onPressed: () {}),
              AppButton(
                label: 'کمپکت',
                compact: true,
                onPressed: () {},
              ),
              AppButton(
                label: 'دارای نماد',
                onPressed: () {},
                leadingIcon: const Icon(Icons.check_circle),
                leadingIconSemanticLabel: 'نماد موفقیت',
                trailingIcon: const Icon(Icons.chevron_left),
                trailingIconSemanticLabel: 'نمایش جزییات',
              ),
              const AppButton(
                label: 'غیرفعال',
                onPressed: null,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Wrap(
            alignment: WrapAlignment.end,
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              AppButton(
                label: 'حالت موفق',
                onPressed: () {},
                tone: AppComponentStatus.success,
              ),
              AppButton(
                label: 'حالت هشدار',
                onPressed: () {},
                tone: AppComponentStatus.warning,
              ),
              AppButton(
                label: 'حالت خطا',
                onPressed: () {},
                tone: AppComponentStatus.error,
              ),
              AppButton(
                label: 'در حال بارگذاری',
                onPressed: () {},
                isLoading: true,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
