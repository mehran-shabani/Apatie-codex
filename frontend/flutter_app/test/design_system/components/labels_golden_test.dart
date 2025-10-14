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
    testGoldens('renders semantic tone and density combinations', (tester) async {
      await GoldenConfig.pumpGoldenWidget(
        tester,
        name: 'test/design_system/goldens/components/labels_variants',
        widget: const _LabelsPreview(),
      );
    });
  });
}

class _LabelsPreview extends StatelessWidget {
  const _LabelsPreview();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: ComponentStateGallery(
        sections: [
          ComponentStateSection(
            title: 'حالت‌های پایه',
            tiles: [
              ComponentStateTile(
                label: 'برچسب اطلاعاتی',
                child: _buildLabel(
                  text: 'به‌روزرسانی شد',
                  tone: AppComponentStatus.info,
                ),
              ),
              ComponentStateTile(
                label: 'نسخهٔ فشرده',
                child: _buildLabel(
                  text: 'کم‌حجم',
                  tone: AppComponentStatus.info,
                  compact: true,
                ),
              ),
              ComponentStateTile(
                label: 'با دکمهٔ بستن',
                child: _buildLabel(
                  text: 'پیام موقت',
                  tone: AppComponentStatus.info,
                  onClose: () {},
                ),
              ),
            ],
          ),
          ComponentStateSection(
            title: 'برچسب‌های وضعیت',
            tiles: [
              ComponentStateTile(
                label: 'موفق',
                child: _buildLabel(
                  text: 'تأیید شده',
                  tone: AppComponentStatus.success,
                ),
              ),
              ComponentStateTile(
                label: 'هشدار',
                child: _buildLabel(
                  text: 'نیاز به اقدام',
                  tone: AppComponentStatus.warning,
                ),
              ),
              ComponentStateTile(
                label: 'خطا',
                child: _buildLabel(
                  text: 'رد شده',
                  tone: AppComponentStatus.error,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLabel({
    required String text,
    required AppComponentStatus tone,
    bool compact = false,
    VoidCallback? onClose,
  }) {
    return Wrap(
      alignment: WrapAlignment.end,
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: [
        AppLabel(
          text: text,
          tone: tone,
          compact: compact,
          icon: const Icon(Icons.info_outline),
          iconSemanticLabel: 'نماد وضعیت',
          onClose: onClose,
          closeButtonSemanticLabel: onClose != null ? 'بستن برچسب' : null,
        ),
      ],
    );
  }
}
