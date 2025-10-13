import 'package:flutter/material.dart';
import 'package:flutter_app/design_system/foundations/colors.dart';
import 'package:flutter_app/design_system/foundations/radii.dart';
import 'package:flutter_app/design_system/foundations/shadows.dart';
import 'package:flutter_app/design_system/foundations/spacing.dart';
import 'package:flutter_app/design_system/foundations/touch_targets.dart';
import 'package:flutter_app/design_system/foundations/typography.dart';

class AppTheme {
  const AppTheme._();

  static ThemeData light() {
    const palette = AppColors.light;
    final textTheme = AppTypography.light(palette);

    return _buildTheme(
      palette: palette,
      textTheme: textTheme,
      shadows: AppShadows.light,
    );
  }

  static ThemeData dark() {
    const palette = AppColors.dark;
    final textTheme = AppTypography.dark(palette);

    return _buildTheme(
      palette: palette,
      textTheme: textTheme,
      shadows: AppShadows.dark,
    );
  }

  static ThemeData _buildTheme({
    required AppColorPalette palette,
    required TextTheme textTheme,
    required AppShadowSet shadows,
  }) {
    final colorScheme = palette.colorScheme;

    OutlineInputBorder outline(Color color, double width) {
      return OutlineInputBorder(
        borderRadius: AppRadii.mdRadius,
        borderSide: BorderSide(color: color, width: width),
      );
    }

    return ThemeData(
      useMaterial3: true,
      brightness: colorScheme.brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.background,
      textTheme: textTheme,
      iconTheme: IconThemeData(color: colorScheme.onSurfaceVariant),
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        shadowColor: shadows.shadowColor,
        centerTitle: true,
        toolbarHeight: AppTouchTargets.toolbarHeight,
        titleTextStyle: textTheme.titleLarge,
        surfaceTintColor: colorScheme.surfaceTint,
      ),
      cardTheme: CardTheme(
        elevation: 0,
        margin: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: AppRadii.lgRadius,
        ),
        shadowColor: shadows.shadowColor,
        clipBehavior: Clip.antiAlias,
        color: colorScheme.surface,
        surfaceTintColor: colorScheme.surfaceTint,
      ),
      dialogTheme: DialogTheme(
        backgroundColor: colorScheme.surface,
        surfaceTintColor: colorScheme.surfaceTint,
        titleTextStyle: textTheme.titleLarge,
        contentTextStyle: textTheme.bodyMedium,
        shape: const RoundedRectangleBorder(borderRadius: AppRadii.lgRadius),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          minimumSize: MaterialStateProperty.all(AppTouchTargets.minimumSize),
          padding: MaterialStateProperty.all(
            const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.sm,
            ),
          ),
          shape: MaterialStateProperty.all(
            const RoundedRectangleBorder(borderRadius: AppRadii.mdRadius),
          ),
          elevation: MaterialStateProperty.resolveWith<double?>((states) {
            if (states.contains(MaterialState.disabled) ||
                states.contains(MaterialState.pressed)) {
              return 0;
            }
            return 1;
          }),
          backgroundColor: MaterialStateProperty.resolveWith<Color?>((states) {
            if (states.contains(MaterialState.disabled)) {
              return colorScheme.onSurface.withOpacity(0.12);
            }
            return colorScheme.primary;
          }),
          foregroundColor: MaterialStateProperty.resolveWith<Color?>((states) {
            if (states.contains(MaterialState.disabled)) {
              return colorScheme.onSurface.withOpacity(0.38);
            }
            return colorScheme.onPrimary;
          }),
          textStyle: MaterialStateProperty.all(textTheme.labelLarge),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          minimumSize: MaterialStateProperty.all(AppTouchTargets.minimumSize),
          padding: MaterialStateProperty.all(
            const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.sm,
            ),
          ),
          foregroundColor: MaterialStateProperty.resolveWith<Color?>((states) {
            if (states.contains(MaterialState.disabled)) {
              return colorScheme.onSurface.withOpacity(0.38);
            }
            return colorScheme.primary;
          }),
          overlayColor: MaterialStateProperty.resolveWith<Color?>((states) {
            if (states.contains(MaterialState.pressed)) {
              return colorScheme.primary.withOpacity(0.12);
            }
            return null;
          }),
          textStyle: MaterialStateProperty.all(textTheme.labelLarge),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          minimumSize: MaterialStateProperty.all(AppTouchTargets.minimumSize),
          padding: MaterialStateProperty.all(
            const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.sm,
            ),
          ),
          shape: MaterialStateProperty.all(
            const RoundedRectangleBorder(borderRadius: AppRadii.mdRadius),
          ),
          side: MaterialStateProperty.resolveWith<BorderSide?>((states) {
            if (states.contains(MaterialState.disabled)) {
              return BorderSide(color: colorScheme.onSurface.withOpacity(0.12));
            }
            return BorderSide(color: colorScheme.outline);
          }),
          foregroundColor: MaterialStateProperty.resolveWith<Color?>((states) {
            if (states.contains(MaterialState.disabled)) {
              return colorScheme.onSurface.withOpacity(0.38);
            }
            return colorScheme.primary;
          }),
          overlayColor: MaterialStateProperty.resolveWith<Color?>((states) {
            if (states.contains(MaterialState.pressed)) {
              return colorScheme.primary.withOpacity(0.12);
            }
            return null;
          }),
          textStyle: MaterialStateProperty.all(textTheme.labelLarge),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.sm,
        ),
        border: outline(colorScheme.outlineVariant, 1),
        enabledBorder: outline(colorScheme.outlineVariant, 1),
        focusedBorder: outline(colorScheme.primary, 2),
        errorBorder: outline(colorScheme.error, 1.5),
        focusedErrorBorder: outline(colorScheme.error, 2),
        labelStyle: textTheme.bodyMedium,
        helperStyle: textTheme.bodySmall,
        errorStyle: textTheme.bodySmall?.copyWith(color: colorScheme.error),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: colorScheme.surface,
        disabledColor: colorScheme.onSurface.withOpacity(0.12),
        selectedColor: colorScheme.primary.withOpacity(0.12),
        secondarySelectedColor: colorScheme.primary,
        showCheckmark: false,
        labelStyle: textTheme.bodyMedium!,
        secondaryLabelStyle: textTheme.bodyMedium!.copyWith(
          color: colorScheme.onPrimary,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: AppRadii.mdRadius,
        ),
      ),
      listTileTheme: ListTileThemeData(
        dense: false,
        tileColor: colorScheme.surface,
        textColor: colorScheme.onSurface,
        iconColor: colorScheme.onSurfaceVariant,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.xs,
        ),
        minLeadingWidth: AppTouchTargets.minInteractiveWidth,
        shape: const RoundedRectangleBorder(
          borderRadius: AppRadii.mdRadius,
        ),
      ),
      dividerTheme: DividerThemeData(
        color: colorScheme.outlineVariant,
        thickness: 1,
        space: AppSpacing.md,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 3,
        shape: const RoundedRectangleBorder(borderRadius: AppRadii.pillRadius),
      ),
      navigationBarTheme: NavigationBarThemeData(
        height: AppTouchTargets.toolbarHeight,
        backgroundColor: colorScheme.surface,
        indicatorColor: colorScheme.primary.withOpacity(0.12),
        surfaceTintColor: colorScheme.surfaceTint,
        labelTextStyle: MaterialStateProperty.all(textTheme.labelMedium),
      ),
      bottomAppBarTheme: BottomAppBarTheme(
        color: colorScheme.surface,
        elevation: 0,
        surfaceTintColor: colorScheme.surfaceTint,
        height: AppTouchTargets.denseToolbarHeight,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: colorScheme.inverseSurface,
        contentTextStyle: textTheme.bodyMedium?.copyWith(
          color: colorScheme.onInverseSurface,
        ),
        behavior: SnackBarBehavior.floating,
        shape: const RoundedRectangleBorder(borderRadius: AppRadii.lgRadius),
        elevation: 4,
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateProperty.resolveWith<Color?>((states) {
          if (states.contains(MaterialState.disabled)) {
            return colorScheme.onSurface.withOpacity(0.12);
          }
          if (states.contains(MaterialState.selected)) {
            return colorScheme.primary;
          }
          return colorScheme.surface;
        }),
        checkColor: MaterialStateProperty.all(colorScheme.onPrimary),
        side: BorderSide(color: colorScheme.outlineVariant),
        shape: const RoundedRectangleBorder(borderRadius: AppRadii.smRadius),
      ),
      radioTheme: RadioThemeData(
        fillColor: MaterialStateProperty.resolveWith<Color?>((states) {
          if (states.contains(MaterialState.disabled)) {
            return colorScheme.onSurface.withOpacity(0.12);
          }
          if (states.contains(MaterialState.selected)) {
            return colorScheme.primary;
          }
          return colorScheme.outlineVariant;
        }),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith<Color?>((states) {
          if (states.contains(MaterialState.disabled)) {
            return colorScheme.onSurface.withOpacity(0.12);
          }
          if (states.contains(MaterialState.selected)) {
            return colorScheme.primary;
          }
          return colorScheme.outlineVariant;
        }),
        trackColor: MaterialStateProperty.resolveWith<Color?>((states) {
          if (states.contains(MaterialState.disabled)) {
            return colorScheme.onSurface.withOpacity(0.1);
          }
          if (states.contains(MaterialState.selected)) {
            return colorScheme.primary.withOpacity(0.3);
          }
          return colorScheme.outlineVariant.withOpacity(0.3);
        }),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: colorScheme.primary,
        linearTrackColor: colorScheme.surfaceVariant,
        refreshBackgroundColor: colorScheme.surface,
      ),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: colorScheme.inverseSurface,
          borderRadius: AppRadii.smRadius,
          boxShadow: shadows.level2,
        ),
        textStyle: textTheme.bodySmall?.copyWith(
          color: colorScheme.onInverseSurface,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
      ),
      bannerTheme: MaterialBannerThemeData(
        backgroundColor: palette.infoContainer,
        contentTextStyle: textTheme.bodyMedium?.copyWith(
          color: palette.onInfoContainer,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
      ),
      extensions: <ThemeExtension<dynamic>>[
        _AppSemanticStatusColors(
          success: palette.success,
          onSuccess: palette.onSuccess,
          successContainer: palette.successContainer,
          onSuccessContainer: palette.onSuccessContainer,
          warning: palette.warning,
          onWarning: palette.onWarning,
          warningContainer: palette.warningContainer,
          onWarningContainer: palette.onWarningContainer,
          info: palette.info,
          onInfo: palette.onInfo,
          infoContainer: palette.infoContainer,
          onInfoContainer: palette.onInfoContainer,
        ),
      ],
    );
  }
}

class _AppSemanticStatusColors extends ThemeExtension<_AppSemanticStatusColors> {
  const _AppSemanticStatusColors({
    required this.success,
    required this.onSuccess,
    required this.successContainer,
    required this.onSuccessContainer,
    required this.warning,
    required this.onWarning,
    required this.warningContainer,
    required this.onWarningContainer,
    required this.info,
    required this.onInfo,
    required this.infoContainer,
    required this.onInfoContainer,
  });

  final Color success;
  final Color onSuccess;
  final Color successContainer;
  final Color onSuccessContainer;
  final Color warning;
  final Color onWarning;
  final Color warningContainer;
  final Color onWarningContainer;
  final Color info;
  final Color onInfo;
  final Color infoContainer;
  final Color onInfoContainer;

  @override
  ThemeExtension<_AppSemanticStatusColors> copyWith({
    Color? success,
    Color? onSuccess,
    Color? successContainer,
    Color? onSuccessContainer,
    Color? warning,
    Color? onWarning,
    Color? warningContainer,
    Color? onWarningContainer,
    Color? info,
    Color? onInfo,
    Color? infoContainer,
    Color? onInfoContainer,
  }) {
    return _AppSemanticStatusColors(
      success: success ?? this.success,
      onSuccess: onSuccess ?? this.onSuccess,
      successContainer: successContainer ?? this.successContainer,
      onSuccessContainer: onSuccessContainer ?? this.onSuccessContainer,
      warning: warning ?? this.warning,
      onWarning: onWarning ?? this.onWarning,
      warningContainer: warningContainer ?? this.warningContainer,
      onWarningContainer: onWarningContainer ?? this.onWarningContainer,
      info: info ?? this.info,
      onInfo: onInfo ?? this.onInfo,
      infoContainer: infoContainer ?? this.infoContainer,
      onInfoContainer: onInfoContainer ?? this.onInfoContainer,
    );
  }

  @override
  ThemeExtension<_AppSemanticStatusColors> lerp(
    covariant ThemeExtension<_AppSemanticStatusColors>? other,
    double t,
  ) {
    if (other is! _AppSemanticStatusColors) {
      return this;
    }

    return _AppSemanticStatusColors(
      success: Color.lerp(success, other.success, t)!,
      onSuccess: Color.lerp(onSuccess, other.onSuccess, t)!,
      successContainer:
          Color.lerp(successContainer, other.successContainer, t)!,
      onSuccessContainer:
          Color.lerp(onSuccessContainer, other.onSuccessContainer, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      onWarning: Color.lerp(onWarning, other.onWarning, t)!,
      warningContainer:
          Color.lerp(warningContainer, other.warningContainer, t)!,
      onWarningContainer:
          Color.lerp(onWarningContainer, other.onWarningContainer, t)!,
      info: Color.lerp(info, other.info, t)!,
      onInfo: Color.lerp(onInfo, other.onInfo, t)!,
      infoContainer: Color.lerp(infoContainer, other.infoContainer, t)!,
      onInfoContainer:
          Color.lerp(onInfoContainer, other.onInfoContainer, t)!,
    );
  }
}
