import 'package:apatie/design_system/components/app_component_states.dart';
import 'package:apatie/design_system/components/app_label.dart';
import 'package:apatie/design_system/foundations/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

import '../config/golden_config.dart';
import 'golden_test_utils.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AppLabel golden tests', () {
    testGoldens('renders label variants', (tester) async {
      await withTrivialGoldenComparator(() async {
        await GoldenConfig.pumpGoldenWidget(
          tester,
          name: 'design_system/components/labels',
          widget: const _LabelsPreview(),
        );
      });
    });
  });
}

class _LabelsPreview extends StatelessWidget {
  const _LabelsPreview();

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
              AppLabel(
                text: 'اطلاع رسانی',
                icon: const Icon(Icons.info_outline),
                tone: AppComponentStatus.info,
              ),
              AppLabel(
                text: 'موفقیت عملیات',
                icon: const Icon(Icons.check_circle_outline),
                tone: AppComponentStatus.success,
                compact: true,
              ),
              AppLabel(
                text: 'خطای سیستم',
                icon: const Icon(Icons.error_outline),
                tone: AppComponentStatus.error,
                onClose: () {},
                closeButtonSemanticLabel: 'بستن برچسب خطا',
              ),
              AppLabel(
                text: 'هشدار امنیتی',
                icon: const Icon(Icons.warning_amber_rounded),
                tone: AppComponentStatus.warning,
                onClose: () {},
                compact: true,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Wrap(
            alignment: WrapAlignment.end,
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: const [
              AppLabel(
                text: 'برچسب ساده',
                tone: AppComponentStatus.neutral,
              ),
              AppLabel(
                text: 'اطلاعات خنثی',
                compact: true,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
