import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/design_system/components/app_component_states.dart';
import 'package:flutter_app/design_system/foundations/radii.dart';
import 'package:flutter_app/design_system/foundations/spacing.dart';

class AppNotification extends StatelessWidget {
  const AppNotification({
    super.key,
    required this.title,
    required this.message,
    this.tone = AppComponentStatus.info,
    this.compact = false,
    this.leading,
    this.actions = const <Widget>[],
    this.onDismiss,
    this.semanticLabel,
  });

  final String title;
  final String message;
  final AppComponentStatus tone;
  final bool compact;
  final Widget? leading;
  final List<Widget> actions;
  final VoidCallback? onDismiss;
  final String? semanticLabel;

  void _announce(BuildContext context) {
    final label = 'اعلان رسمی: $title - $message';
    SemanticsService.announce(label, Directionality.of(context));
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _announce(context));
    final colors = resolveComponentColors(
      context,
      status: tone,
      highlighted: false,
      disabled: false,
    );

    final theme = Theme.of(context);

    return Semantics(
      liveRegion: true,
      label: semanticLabel ?? 'اعلان: $title',
      child: Container(
        padding: EdgeInsets.all(compact ? AppSpacing.sm : AppSpacing.md),
        decoration: BoxDecoration(
          color: colors.background,
          borderRadius: compact ? AppRadii.mdRadius : AppRadii.lgRadius,
          border: Border.all(color: colors.border, width: 1),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (leading != null)
              Padding(
                padding: const EdgeInsetsDirectional.only(end: AppSpacing.sm),
                child: IconTheme(
                  data: IconThemeData(color: colors.foreground, size: 24),
                  child: leading!,
                ),
              ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: colors.foreground,
                    ),
                  ),
                  SizedBox(height: AppSpacing.xs),
                  Text(
                    message,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colors.foreground,
                    ),
                  ),
                  if (actions.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: AppSpacing.sm),
                      child: Wrap(
                        spacing: AppSpacing.sm,
                        runSpacing: AppSpacing.xs,
                        children: actions,
                      ),
                    ),
                ],
              ),
            ),
            if (onDismiss != null)
              IconButton(
                tooltip: 'بستن اعلان',
                onPressed: onDismiss,
                icon: Icon(Icons.close, color: colors.foreground),
              ),
          ],
        ),
      ),
    );
  }
}
