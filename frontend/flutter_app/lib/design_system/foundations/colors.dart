import 'package:flutter/material.dart';

class AppColorPalette {
  const AppColorPalette({
    required this.colorScheme,
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

  final ColorScheme colorScheme;
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
}

class AppColors {
  const AppColors._();

  static const AppColorPalette light = AppColorPalette(
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xFF0057B7),
      onPrimary: Color(0xFFFFFFFF),
      primaryContainer: Color(0xFFD5E3FF),
      onPrimaryContainer: Color(0xFF001B3F),
      secondary: Color(0xFF006D3C),
      onSecondary: Color(0xFFFFFFFF),
      secondaryContainer: Color(0xFFA6F2C5),
      onSecondaryContainer: Color(0xFF00210F),
      tertiary: Color(0xFF8A2C5B),
      onTertiary: Color(0xFFFFFFFF),
      tertiaryContainer: Color(0xFFFFD8E7),
      onTertiaryContainer: Color(0xFF360018),
      error: Color(0xFFB3261E),
      onError: Color(0xFFFFFFFF),
      errorContainer: Color(0xFFFFDAD6),
      onErrorContainer: Color(0xFF410002),
      background: Color(0xFFFBF8F5),
      onBackground: Color(0xFF1B1B1F),
      surface: Color(0xFFFBF8F5),
      onSurface: Color(0xFF1B1B1F),
      surfaceVariant: Color(0xFFE1E3ED),
      onSurfaceVariant: Color(0xFF44474F),
      outline: Color(0xFF74777F),
      outlineVariant: Color(0xFFC5C6CF),
      shadow: Color(0x26000000),
      scrim: Color(0x66000000),
      inverseSurface: Color(0xFF303033),
      onInverseSurface: Color(0xFFF2F0F4),
      inversePrimary: Color(0xFFA5C7FF),
      surfaceTint: Color(0xFF0057B7),
    ),
    success: Color(0xFF1E7F4F),
    onSuccess: Color(0xFFFFFFFF),
    successContainer: Color(0xFFC6F7DA),
    onSuccessContainer: Color(0xFF002112),
    warning: Color(0xFFB25E00),
    onWarning: Color(0xFFFFFFFF),
    warningContainer: Color(0xFFFFDDB5),
    onWarningContainer: Color(0xFF361900),
    info: Color(0xFF005A9C),
    onInfo: Color(0xFFFFFFFF),
    infoContainer: Color(0xFFD2E4FF),
    onInfoContainer: Color(0xFF001C38),
  );

  static const AppColorPalette dark = AppColorPalette(
    colorScheme: ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xFFA5C7FF),
      onPrimary: Color(0xFF002F67),
      primaryContainer: Color(0xFF00458E),
      onPrimaryContainer: Color(0xFFD5E3FF),
      secondary: Color(0xFF8CD7AC),
      onSecondary: Color(0xFF00391D),
      secondaryContainer: Color(0xFF00522D),
      onSecondaryContainer: Color(0xFFA6F2C5),
      tertiary: Color(0xFFFFB1C9),
      onTertiary: Color(0xFF530027),
      tertiaryContainer: Color(0xFF75003B),
      onTertiaryContainer: Color(0xFFFFD8E7),
      error: Color(0xFFFFB4AB),
      onError: Color(0xFF690005),
      errorContainer: Color(0xFF93000A),
      onErrorContainer: Color(0xFFFFDAD6),
      background: Color(0xFF111417),
      onBackground: Color(0xFFE2E2E6),
      surface: Color(0xFF111417),
      onSurface: Color(0xFFE2E2E6),
      surfaceVariant: Color(0xFF44474F),
      onSurfaceVariant: Color(0xFFC5C6CF),
      outline: Color(0xFF8E9099),
      outlineVariant: Color(0xFF44474F),
      shadow: Color(0x99000000),
      scrim: Color(0x99000000),
      inverseSurface: Color(0xFFE2E2E6),
      onInverseSurface: Color(0xFF1B1B1F),
      inversePrimary: Color(0xFF0057B7),
      surfaceTint: Color(0xFFA5C7FF),
    ),
    success: Color(0xFF6DD58C),
    onSuccess: Color(0xFF00391E),
    successContainer: Color(0xFF005230),
    onSuccessContainer: Color(0xFFC6F7DA),
    warning: Color(0xFFFFB760),
    onWarning: Color(0xFF4F2600),
    warningContainer: Color(0xFF713900),
    onWarningContainer: Color(0xFFFFDDB5),
    info: Color(0xFF78C7FF),
    onInfo: Color(0xFF003152),
    infoContainer: Color(0xFF004A78),
    onInfoContainer: Color(0xFFD2E4FF),
  );
}
