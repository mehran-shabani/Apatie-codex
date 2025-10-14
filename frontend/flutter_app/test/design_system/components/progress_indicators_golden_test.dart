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
    testGoldens('renders linear, circular, compact, and status variants',
        (tester) async {
      await withTrivialGoldenComparator(() async {
        await GoldenConfig.pumpGoldenWidget(
          tester,
          name:
              'test/design_system/goldens/components/progress_indicators_matrix',
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
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: ComponentStateGallery(
        sections: [
          ComponentStateSection(
            title: 'الگوهای خطی',
            tiles: [
              ComponentStateTile(
                label: 'پیشرفت استاندارد',
                child: _linear(
                  value: 0.4,
                  description: '۴۰٪ تکمیل شده است.',
                ),
              ),
              ComponentStateTile(
                label: 'در حال اجرا (نامحدود)',
                child: _linear(description: 'در انتظار پاسخ سرور...'),
              ),
              ComponentStateTile(
                label: 'نسخهٔ فشرده',
                child: _linear(
                  value: 0.65,
                  compact: true,
                  description: '۶۵٪ همگام‌سازی انجام شد.',
                ),
              ),
            ],
          ),
          ComponentStateSection(
            title: 'الگوهای دایره‌ای و وضعیت',
            tiles: [
              ComponentStateTile(
                label: 'دایره‌ای استاندارد',
                child: _circular(value: 0.25, description: 'بارگذاری اولیه'),
              ),
              ComponentStateTile(
                label: 'دایره‌ای فشرده',
                child: _circular(compact: true, description: 'حالت مینیمال'),
              ),
              ComponentStateTile(
                label: 'موفق',
                child: _linear(
                  value: 1,
                  tone: AppComponentStatus.success,
                  description: 'پروسه تکمیل شد.',
                ),
              ),
              ComponentStateTile(
                label: 'هشدار',
                child: _linear(
                  value: 0.5,
                  tone: AppComponentStatus.warning,
                  description: 'پیشرفت کند است.',
                ),
              ),
              ComponentStateTile(
                label: 'خطا',
                child: _linear(
                  tone: AppComponentStatus.error,
                  description: 'پروسه متوقف شد.',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _linear({
    double? value,
    String? description,
    AppComponentStatus tone = AppComponentStatus.neutral,
    bool compact = false,
  }) {
    return AppProgressIndicator(
      value: value,
      description: description,
      tone: tone,
      compact: compact,
    );
  }

  Widget _circular({
    double? value,
    String? description,
    AppComponentStatus tone = AppComponentStatus.neutral,
    bool compact = false,
  }) {
    return AppProgressIndicator(
      value: value,
      description: description,
      tone: tone,
      compact: compact,
      circular: true,
    );
  }
}
