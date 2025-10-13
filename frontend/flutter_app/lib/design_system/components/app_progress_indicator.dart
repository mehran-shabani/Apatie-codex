import 'package:apatie/design_system/components/app_component_states.dart';
import 'package:apatie/design_system/foundations/spacing.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppProgressIndicator extends StatelessWidget {
  const AppProgressIndicator({
    super.key,
    this.value,
    this.description,
    this.tone = AppComponentStatus.neutral,
    this.compact = false,
    this.circular = false,
    this.semanticLabel,
  });

  final double? value;
  final String? description;
  final AppComponentStatus tone;
  final bool compact;
  final bool circular;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final colors = resolveComponentColors(
      context,
      status: tone,
      highlighted: false,
      disabled: false,
    );
    final theme = Theme.of(context);

    final indicator = circular
        ? CircularProgressIndicator(
            value: value,
            valueColor: AlwaysStoppedAnimation<Color>(colors.border),
            backgroundColor: colors.background,
          )
        : LinearProgressIndicator(
            value: value,
            color: colors.border,
            backgroundColor: colors.background,
            minHeight: compact ? 2 : 4,
          );

    final semanticValue = value != null
        ? (() {
            final locale = Intl.getCurrentLocale();
            final formatter = NumberFormat.percentPattern(locale)
              ..maximumFractionDigits = 0
              ..minimumFractionDigits = 0;
            return formatter.format(value!.clamp(0.0, 1.0));
          })()
        : null;

    return Semantics(
      label: semanticLabel ?? 'نشانگر پیشرفت',
      value: semanticValue,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: circular ? (compact ? 32 : 48) : null,
            width: circular ? (compact ? 32 : 48) : double.infinity,
            child: indicator,
          ),
          if (description != null)
            Padding(
              padding: EdgeInsets.only(top: compact ? AppSpacing.xs : AppSpacing.sm),
              child: Text(
                description!,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colors.border,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
