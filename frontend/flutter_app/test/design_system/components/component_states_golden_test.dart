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
    testGoldens('renders component state swatches', (tester) async {
      await withTrivialGoldenComparator(() async {
        await GoldenConfig.pumpGoldenWidget(
          tester,
          name: 'design_system/components/component_states',
          widget: const _ComponentStatesPreview(),
        );
      });
    });
  });
}

class _ComponentStatesPreview extends StatelessWidget {
  const _ComponentStatesPreview();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: const [
          _ComponentStateSection(title: 'حالات پایه', highlighted: false, disabled: false),
          SizedBox(height: AppSpacing.lg),
          _ComponentStateSection(title: 'حالت برجسته', highlighted: true, disabled: false),
          SizedBox(height: AppSpacing.lg),
          _ComponentStateSection(title: 'حالت غیرفعال', highlighted: false, disabled: true),
        ],
      ),
    );
  }
}

class _ComponentStateSection extends StatelessWidget {
  const _ComponentStateSection({
    required this.title,
    required this.highlighted,
    required this.disabled,
  });

  final String title;
  final bool highlighted;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          title,
          style: theme.textTheme.titleSmall,
        ),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          alignment: WrapAlignment.end,
          children: [
            _ComponentStateSwatch(
              status: AppComponentStatus.neutral,
              label: 'خنثی',
              highlighted: highlighted,
              disabled: disabled,
            ),
            _ComponentStateSwatch(
              status: AppComponentStatus.success,
              label: 'موفق',
              highlighted: highlighted,
              disabled: disabled,
            ),
            _ComponentStateSwatch(
              status: AppComponentStatus.warning,
              label: 'هشدار',
              highlighted: highlighted,
              disabled: disabled,
            ),
            _ComponentStateSwatch(
              status: AppComponentStatus.error,
              label: 'خطا',
              highlighted: highlighted,
              disabled: disabled,
            ),
            _ComponentStateSwatch(
              status: AppComponentStatus.info,
              label: 'اطلاعاتی',
              highlighted: highlighted,
              disabled: disabled,
            ),
          ],
        ),
      ],
    );
  }
}

class _ComponentStateSwatch extends StatelessWidget {
  const _ComponentStateSwatch({
    required this.status,
    required this.label,
    this.highlighted = false,
    this.disabled = false,
  });

  final AppComponentStatus status;
  final String label;
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

    return Container(
      width: 160,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: colors.background,
        border: Border.all(color: colors.border, width: 1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            label,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyLarge?.copyWith(color: colors.foreground),
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
    );
  }
}
