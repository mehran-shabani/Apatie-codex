import 'package:flutter/material.dart';
import 'package:apatie/design_system/components/app_component_states.dart';
import 'package:apatie/design_system/foundations/radii.dart';
import 'package:apatie/design_system/foundations/spacing.dart';

class AppLabel extends StatelessWidget {
  const AppLabel({
    super.key,
    required this.text,
    this.icon,
    this.iconSemanticLabel,
    this.tone = AppComponentStatus.info,
    this.compact = false,
    this.onClose,
    this.semanticLabel,
  });

  final String text;
  final Widget? icon;
  final String? iconSemanticLabel;
  final AppComponentStatus tone;
  final bool compact;
  final VoidCallback? onClose;
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
    final padding = EdgeInsets.symmetric(
      horizontal: AppSpacing.sm,
      vertical: compact ? AppSpacing.xs : AppSpacing.sm,
    );

    return Semantics(
      label: semanticLabel ?? 'برچسب وضعیت: $text',
      child: Container(
        decoration: BoxDecoration(
          color: colors.background,
          borderRadius: compact ? AppRadii.smRadius : AppRadii.mdRadius,
          border: Border.all(color: colors.border, width: 1),
        ),
        padding: padding,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null)
              Padding(
                padding: const EdgeInsetsDirectional.only(end: AppSpacing.xs),
                child: Semantics(
                  label: iconSemanticLabel,
                  child: IconTheme(
                    data: IconThemeData(
                      color: colors.foreground,
                      size: compact ? 16 : 18,
                    ),
                    child: icon!,
                  ),
                ),
              ),
            Flexible(
              child: Text(
                text,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colors.foreground,
                ),
              ),
            ),
            if (onClose != null)
              Padding(
                padding: const EdgeInsetsDirectional.only(start: AppSpacing.xs),
                child: Semantics(
                  button: true,
                  label: 'بستن برچسب',
                  child: GestureDetector(
                    onTap: onClose,
                    child: Icon(
                      Icons.close,
                      size: compact ? 16 : 18,
                      color: colors.foreground,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
