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
    testGoldens('illustrates interaction, density, and validation states',
        (tester) async {
      await GoldenConfig.pumpGoldenWidget(
        tester,
        name:
            'test/design_system/goldens/components/input_fields_state_matrix',
        widget: const _InputFieldsPreview(),
      );
    });
  });
}

class _InputFieldsPreview extends StatelessWidget {
  const _InputFieldsPreview();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: ComponentStateGallery(
        sections: [
          ComponentStateSection(
            title: 'حالت‌های تعاملی',
            tiles: [
              ComponentStateTile(
                label: 'استاندارد',
                child: _buildField(
                  context,
                  label: 'عنوان گزارش',
                  helper: 'یک عنوان توصیفی وارد کنید.',
                ),
              ),
              ComponentStateTile(
                label: 'حالت فوکوس',
                child: _focusedField(
                  context,
                  label: 'جست‌وجو',
                  placeholder: 'کلیدواژهٔ مورد نظر را وارد کنید',
                ),
              ),
              ComponentStateTile(
                label: 'در حال بارگذاری',
                child: _buildField(
                  context,
                  label: 'نام مشتری',
                  helper: 'اطلاعات در حال واکشی است.',
                  isLoading: true,
                ),
              ),
              const ComponentStateTile(
                label: 'غیرفعال',
                child: AppInputField(
                  label: 'کد پیگیری',
                  enabled: false,
                  helperText: 'این فیلد توسط سامانه پر می‌شود.',
                ),
              ),
              ComponentStateTile(
                label: 'نسخهٔ فشرده',
                child: _buildField(
                  context,
                  label: 'توضیح کوتاه',
                  compact: true,
                  helper: 'برای جداول و فضاهای محدود.',
                ),
              ),
            ],
          ),
          ComponentStateSection(
            title: 'اعتبارسنجی و وضعیت',
            tiles: [
              ComponentStateTile(
                label: 'موفق',
                child: _buildField(
                  context,
                  label: 'کد امنیتی',
                  tone: AppComponentStatus.success,
                  helper: 'کد تأیید شد.',
                ),
              ),
              ComponentStateTile(
                label: 'هشدار',
                child: _buildField(
                  context,
                  label: 'آستانهٔ مصرف',
                  tone: AppComponentStatus.warning,
                  helper: 'به سقف مجاز نزدیک می‌شوید.',
                ),
              ),
              ComponentStateTile(
                label: 'خطا',
                child: _buildField(
                  context,
                  label: 'شماره تماس',
                  tone: AppComponentStatus.error,
                  helper: 'فرمت شماره صحیح نیست.',
                  error: 'لطفاً با ۰۹ شروع شود.',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildField(
    BuildContext context, {
    required String label,
    String? helper,
    String? placeholder,
    AppComponentStatus tone = AppComponentStatus.neutral,
    bool compact = false,
    bool isLoading = false,
    String? error,
  }) {
    return AppInputField(
      label: label,
      helperText: helper,
      placeholder: placeholder,
      tone: tone,
      compact: compact,
      isLoading: isLoading,
      errorText: error,
    );
  }

  Widget _focusedField(
    BuildContext context, {
    required String label,
    String? placeholder,
  }) {
    final focusNode = FocusNode();
    return GoldenFocusActivator(
      focusNode: focusNode,
      child: AppInputField(
        label: label,
        focusNode: focusNode,
        placeholder: placeholder,
        helperText: 'نتایج هم‌زمان نمایش داده می‌شود.',
      ),
    );
  }
}
