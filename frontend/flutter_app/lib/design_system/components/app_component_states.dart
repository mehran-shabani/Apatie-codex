import 'package:flutter/material.dart';
import 'package:flutter_app/design_system/foundations/semantic_colors.dart';

enum AppComponentStatus {
  neutral,
  success,
  warning,
  error,
  info,
}

@immutable
class AppComponentStateColors {
  const AppComponentStateColors({
    required this.background,
    required this.foreground,
    required this.border,
  });

  final Color background;
  final Color foreground;
  final Color border;
}

AppComponentStateColors resolveComponentColors(
  BuildContext context, {
  required AppComponentStatus status,
  bool highlighted = false,
  bool disabled = false,
}) {
  final theme = Theme.of(context);
  final palette = theme.colorScheme;
  final semantics = context.semanticColors;

  Color baseBackground = palette.surface;
  Color baseForeground = palette.onSurface;
  Color baseBorder = palette.outlineVariant;

  switch (status) {
    case AppComponentStatus.neutral:
      baseBackground = palette.surface;
      baseForeground = palette.onSurface;
      baseBorder = palette.outlineVariant;
      break;
    case AppComponentStatus.success:
      baseBackground = semantics.successContainer;
      baseForeground = semantics.onSuccessContainer;
      baseBorder = semantics.success;
      break;
    case AppComponentStatus.warning:
      baseBackground = semantics.warningContainer;
      baseForeground = semantics.onWarningContainer;
      baseBorder = semantics.warning;
      break;
    case AppComponentStatus.error:
      baseBackground = palette.errorContainer;
      baseForeground = palette.onErrorContainer;
      baseBorder = palette.error;
      break;
    case AppComponentStatus.info:
      baseBackground = semantics.infoContainer;
      baseForeground = semantics.onInfoContainer;
      baseBorder = semantics.info;
      break;
  }

  if (disabled) {
    baseBackground = palette.onSurface.withOpacity(0.12);
    baseForeground = palette.onSurface.withOpacity(0.38);
    baseBorder = Colors.transparent;
  } else if (highlighted) {
    baseBackground = Color.alphaBlend(
      palette.primary.withOpacity(0.08),
      baseBackground,
    );
  }

  return AppComponentStateColors(
    background: baseBackground,
    foreground: baseForeground,
    border: baseBorder,
  );
}
