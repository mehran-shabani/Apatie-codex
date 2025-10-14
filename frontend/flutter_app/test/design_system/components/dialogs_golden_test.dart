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
    testGoldens('renders dialog variants', (tester) async {
      await withTrivialGoldenComparator(() async {
        await GoldenConfig.pumpGoldenWidget(
          tester,
          name: 'design_system/components/dialogs',
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
    return SingleChildScrollView(
      child: Wrap(
        alignment: WrapAlignment.end,
        spacing: AppSpacing.lg,
        runSpacing: AppSpacing.lg,
        children: const [
          _DialogCard(
            title: 'گفت‌وگوی استاندارد',
            tone: AppComponentStatus.neutral,
            message:
                'این کادر گفت‌وگو برای سناریوهای عادی با دو کنش نمونه نمایش داده می‌شود.',
            compact: false,
          ),
          _DialogCard(
            title: 'هشدار امنیتی',
            tone: AppComponentStatus.warning,
            message:
                'لطفاً رمز عبور خود را تأیید کنید. این اقدام ممکن است چند دقیقه زمان ببرد.',
            compact: true,
          ),
          _DialogCard(
            title: 'در حال پردازش',
            tone: AppComponentStatus.info,
            message: 'پردازش درخواست شما همچنان ادامه دارد.',
            isLoading: true,
          ),
        ],
      ),
    );
  }
}

class _DialogCard extends StatelessWidget {
  const _DialogCard({
    required this.title,
    required this.message,
    required this.tone,
    this.compact = false,
    this.isLoading = false,
  });

  final String title;
  final String message;
  final AppComponentStatus tone;
  final bool compact;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 360),
      child: AppDialog(
        title: title,
        tone: tone,
        compact: compact,
        isLoading: isLoading,
        content: Text(
          message,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        actions: [
          AppButton(
            label: 'لغو',
            onPressed: () {},
            compact: true,
            tone: AppComponentStatus.neutral,
          ),
          AppButton(
            label: 'تأیید',
            onPressed: () {},
            compact: true,
            tone: tone,
          ),
        ],
      ),
    );
  }
}
