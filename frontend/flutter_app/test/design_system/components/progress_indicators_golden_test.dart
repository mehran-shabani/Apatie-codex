import 'package:apatie/design_system/components/app_component_states.dart';
import 'package:apatie/design_system/components/app_progress_indicator.dart';
import 'package:apatie/design_system/foundations/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

import '../config/golden_config.dart';
import 'golden_test_utils.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AppProgressIndicator golden tests', () {
    testGoldens('renders progress indicator variants', (tester) async {
      await withTrivialGoldenComparator(() async {
        await GoldenConfig.pumpGoldenWidget(
          tester,
          name: 'design_system/components/progress_indicators',
          widget: const _ProgressIndicatorsPreview(),
        );
      });
    });
  });
}

class _ProgressIndicatorsPreview extends StatelessWidget {
  const _ProgressIndicatorsPreview();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: const [
          AppProgressIndicator(
            value: 0.35,
            description: 'در حال بارگذاری سفارش‌ها (۳۵٪)',
          ),
          SizedBox(height: AppSpacing.lg),
          AppProgressIndicator(
            tone: AppComponentStatus.success,
            value: 0.8,
            description: 'پیشرفت انتشار نسخه',
            compact: true,
          ),
          SizedBox(height: AppSpacing.lg),
          AppProgressIndicator(
            tone: AppComponentStatus.warning,
            circular: true,
            description: 'در حال اعتبارسنجی داده‌ها',
          ),
          SizedBox(height: AppSpacing.lg),
          AppProgressIndicator(
            tone: AppComponentStatus.error,
            circular: true,
            value: 0.6,
            description: 'بازآوری مجدد پس از خطا',
            compact: true,
          ),
        ],
      ),
    );
  }
}
