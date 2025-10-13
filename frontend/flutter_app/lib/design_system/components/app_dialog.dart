import 'package:flutter/material.dart';
import 'package:flutter_app/design_system/components/app_component_states.dart';
import 'package:flutter_app/design_system/foundations/radii.dart';
import 'package:flutter_app/design_system/foundations/spacing.dart';

class AppDialog extends StatelessWidget {
  const AppDialog({
    super.key,
    required this.title,
    required this.content,
    this.actions = const <Widget>[],
    this.tone = AppComponentStatus.neutral,
    this.compact = false,
    this.isLoading = false,
    this.semanticLabel,
  });

  final String title;
  final Widget content;
  final List<Widget> actions;
  final AppComponentStatus tone;
  final bool compact;
  final bool isLoading;
  final String? semanticLabel;

  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    required Widget content,
    List<Widget> actions = const <Widget>[],
    AppComponentStatus tone = AppComponentStatus.neutral,
    bool compact = false,
    bool isLoading = false,
    String? semanticLabel,
    bool barrierDismissible = true,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) => AppDialog(
        title: title,
        content: content,
        actions: actions,
        tone: tone,
        compact: compact,
        isLoading: isLoading,
        semanticLabel: semanticLabel,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = resolveComponentColors(
      context,
      status: tone,
      highlighted: false,
      disabled: false,
    );
    final theme = Theme.of(context);

    return Dialog(
      insetPadding: EdgeInsets.symmetric(
        horizontal: compact ? AppSpacing.lg : AppSpacing.xl,
        vertical: compact ? AppSpacing.md : AppSpacing.lg,
      ),
      shape: const RoundedRectangleBorder(borderRadius: AppRadii.lgRadius),
      backgroundColor: colors.background,
      child: Semantics(
        container: true,
        label: semanticLabel ?? 'کادر گفت‌وگو: $title',
        child: Padding(
          padding: EdgeInsets.all(compact ? AppSpacing.md : AppSpacing.lg),
          child: FocusTraversalGroup(
            policy: ReadingOrderTraversalPolicy(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: colors.foreground,
                  ),
                ),
                SizedBox(height: AppSpacing.sm),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: isLoading ? 0.5 : 1,
                  child: content,
                ),
                if (isLoading)
                  Padding(
                    padding: const EdgeInsets.only(top: AppSpacing.sm),
                    child: LinearProgressIndicator(
                      minHeight: 2,
                      color: colors.border,
                      backgroundColor: colors.background,
                    ),
                  ),
                SizedBox(height: AppSpacing.md),
                if (actions.isNotEmpty)
                  Wrap(
                    alignment: WrapAlignment.end,
                    spacing: AppSpacing.sm,
                    runSpacing: AppSpacing.xs,
                    children: actions,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
