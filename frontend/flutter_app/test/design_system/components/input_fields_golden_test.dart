import 'package:apatie/design_system/components/app_component_states.dart';
import 'package:apatie/design_system/components/app_input_field.dart';
import 'package:apatie/design_system/foundations/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

import '../config/golden_config.dart';
import 'golden_test_utils.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AppInputField golden tests', () {
    testGoldens('renders input field variants', (tester) async {
      await withTrivialGoldenComparator(() async {
        await GoldenConfig.pumpGoldenWidget(
          tester,
          name: 'design_system/components/input_fields',
          widget: const _InputFieldsPreview(),
        );
      });
    });
  });
}

class _InputFieldsPreview extends StatefulWidget {
  const _InputFieldsPreview();

  @override
  State<_InputFieldsPreview> createState() => _InputFieldsPreviewState();
}

class _InputFieldsPreviewState extends State<_InputFieldsPreview> {
  late final TextEditingController _filledController;
  late final TextEditingController _successController;
  late final TextEditingController _errorController;

  @override
  void initState() {
    super.initState();
    _filledController = TextEditingController(text: 'آرات پارسا');
    _successController = TextEditingController(text: 'AP-4581');
    _errorController = TextEditingController(text: 'hello@apatie');
  }

  @override
  void dispose() {
    _filledController.dispose();
    _successController.dispose();
    _errorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppInputField(
            label: 'نام کامل',
            controller: _filledController,
            helperText: 'نام رسمی خود را وارد کنید.',
            placeholder: 'مثال: آرات پارسا',
          ),
          const SizedBox(height: AppSpacing.lg),
          AppInputField(
            label: 'کد پیگیری',
            controller: _successController,
            tone: AppComponentStatus.success,
            helperText: 'شناسه معتبر است.',
            compact: true,
          ),
          const SizedBox(height: AppSpacing.lg),
          AppInputField(
            label: 'ایمیل سازمانی',
            controller: _errorController,
            tone: AppComponentStatus.error,
            errorText: 'نشانی ایمیل نامعتبر است.',
            helperText: 'از دامنهٔ رسمی استفاده کنید.',
            onRetry: () {},
            retryLabel: 'تلاش دوباره',
          ),
          const SizedBox(height: AppSpacing.lg),
          const AppInputField(
            label: 'فقط خواندنی',
            readOnly: true,
            placeholder: 'محتوا قابل ویرایش نیست',
            helperText: 'برای ویرایش سطح دسترسی لازم است.',
          ),
          const SizedBox(height: AppSpacing.lg),
          const AppInputField(
            label: 'غیرفعال',
            enabled: false,
            placeholder: 'این فیلد موقتاً غیرفعال است',
          ),
        ],
      ),
    );
  }
}
