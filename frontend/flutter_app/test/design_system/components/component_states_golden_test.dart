import 'package:apatie/design_system/components/app_component_states.dart';
import 'package:apatie/design_system/foundations/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

import '../config/golden_config.dart';
import 'golden_test_utils.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AppComponentStates golden tests', () {
    testGoldens('documents highlighted and disabled palettes', (tester) async {
      await GoldenConfig.pumpGoldenWidget(
        tester,
        name: 'test/design_system/goldens/components/component_state_swatches',
        widget: const _ComponentStatesPreview(),
      );
    });
  });
}

class _ComponentStatesPreview extends StatelessWidget {
  const _ComponentStatesPreview();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: ComponentStateGallery(
        sections: const [
          ComponentStateSection(
            title: 'حالت‌های پایه',
            tiles: [
              _ComponentStateSwatchTile(
                label: 'خنثی',
                status: AppComponentStatus.neutral,
              ),
              _ComponentStateSwatchTile(
                label: 'موفق',
                status: AppComponentStatus.success,
              ),
              _ComponentStateSwatchTile(
                label: 'هشدار',
                status: AppComponentStatus.warning,
              ),
              _ComponentStateSwatchTile(
                label: 'خطا',
                status: AppComponentStatus.error,
              ),
              _ComponentStateSwatchTile(
                label: 'اطلاعات',
                status: AppComponentStatus.info,
              ),
            ],
          ),
          ComponentStateSection(
            title: 'در حالت شناور یا تمرکز',
            tiles: [
              _ComponentStateSwatchTile(
                label: 'خنثی برجسته',
                status: AppComponentStatus.neutral,
                highlighted: true,
              ),
              _ComponentStateSwatchTile(
                label: 'موفق برجسته',
                status: AppComponentStatus.success,
                highlighted: true,
              ),
              _ComponentStateSwatchTile(
                label: 'هشدار برجسته',
                status: AppComponentStatus.warning,
                highlighted: true,
              ),
              _ComponentStateSwatchTile(
                label: 'خطا برجسته',
                status: AppComponentStatus.error,
                highlighted: true,
              ),
              _ComponentStateSwatchTile(
                label: 'اطلاعات برجسته',
                status: AppComponentStatus.info,
                highlighted: true,
              ),
            ],
          ),
          ComponentStateSection(
            title: 'حالت‌های غیرفعال',
            tiles: [
              _ComponentStateSwatchTile(
                label: 'خنثی غیرفعال',
                status: AppComponentStatus.neutral,
                disabled: true,
              ),
              _ComponentStateSwatchTile(
                label: 'موفق غیرفعال',
                status: AppComponentStatus.success,
                disabled: true,
              ),
              _ComponentStateSwatchTile(
                label: 'هشدار غیرفعال',
                status: AppComponentStatus.warning,
                disabled: true,
              ),
              _ComponentStateSwatchTile(
                label: 'خطا غیرفعال',
                status: AppComponentStatus.error,
                disabled: true,
              ),
              _ComponentStateSwatchTile(
                label: 'اطلاعات غیرفعال',
                status: AppComponentStatus.info,
                disabled: true,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ComponentStateSwatchTile extends ComponentStateTile {
  const _ComponentStateSwatchTile({
    required String label,
    required this.status,
    this.highlighted = false,
    this.disabled = false,
  }) : super(label: label, child: const SizedBox.shrink(), width: 240);

  final AppComponentStatus status;
  final bool highlighted;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    final colors = resolveComponentColors(
      context,
      status: status,
      highlighted: highlighted,
      disabled: disabled,
    );
    final theme = Theme.of(context);

    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            label,
            textAlign: TextAlign.right,
            style: theme.textTheme.bodyLarge,
          ),
          const SizedBox(height: AppSpacing.sm),
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: colors.background,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: colors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'پیش‌نمایش',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colors.foreground,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Container(
                  height: 24,
                  decoration: BoxDecoration(
                    color: colors.border,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
