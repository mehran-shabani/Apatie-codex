import 'package:flutter/material.dart';

import 'colors.dart';

class AppTypography {
  const AppTypography._();

  static const String _fontFamily = 'Vazirmatn';
  static const List<String> _fontFamilyFallback = <String>['Roboto', 'Helvetica', 'Arial'];

  static const TextStyle _headlineBase = TextStyle(
    fontFamily: _fontFamily,
    fontFamilyFallback: _fontFamilyFallback,
    fontWeight: FontWeight.w700,
    height: 1.25,
    letterSpacing: -0.4,
  );

  static const TextStyle _titleBase = TextStyle(
    fontFamily: _fontFamily,
    fontFamilyFallback: _fontFamilyFallback,
    fontWeight: FontWeight.w600,
    height: 1.3,
    letterSpacing: -0.2,
  );

  static const TextStyle _bodyBase = TextStyle(
    fontFamily: _fontFamily,
    fontFamilyFallback: _fontFamilyFallback,
    fontWeight: FontWeight.w400,
    height: 1.5,
    letterSpacing: 0.05,
  );

  static const TextStyle _captionBase = TextStyle(
    fontFamily: _fontFamily,
    fontFamilyFallback: _fontFamilyFallback,
    fontWeight: FontWeight.w400,
    height: 1.4,
    letterSpacing: 0.1,
  );

  static const TextStyle _labelBase = TextStyle(
    fontFamily: _fontFamily,
    fontFamilyFallback: _fontFamilyFallback,
    fontWeight: FontWeight.w600,
    height: 1.2,
    letterSpacing: 0.2,
  );

  static TextTheme light(AppColorPalette palette) => _textTheme(
        onSurface: palette.colorScheme.onSurface,
        onSurfaceVariant: palette.colorScheme.onSurfaceVariant,
        accent: palette.colorScheme.primary,
      );

  static TextTheme dark(AppColorPalette palette) => _textTheme(
        onSurface: palette.colorScheme.onSurface,
        onSurfaceVariant: palette.colorScheme.onSurfaceVariant,
        accent: palette.colorScheme.primary,
      );

  static TextTheme _textTheme({
    required Color onSurface,
    required Color onSurfaceVariant,
    required Color accent,
  }) {
    return TextTheme(
      headlineLarge: _headlineBase.copyWith(fontSize: 32, color: onSurface),
      headlineMedium: _headlineBase.copyWith(fontSize: 28, color: onSurface),
      titleLarge: _titleBase.copyWith(fontSize: 22, color: onSurface),
      titleMedium: _titleBase.copyWith(fontSize: 18, color: onSurfaceVariant),
      bodyLarge: _bodyBase.copyWith(fontSize: 16, color: onSurface),
      bodyMedium: _bodyBase.copyWith(fontSize: 14, color: onSurfaceVariant),
      bodySmall: _captionBase.copyWith(fontSize: 12, color: onSurfaceVariant),
      labelLarge: _labelBase.copyWith(fontSize: 16, color: accent),
      labelMedium: _labelBase.copyWith(fontSize: 14, color: onSurface),
      labelSmall: _captionBase.copyWith(fontSize: 11, color: onSurfaceVariant),
    );
  }
}
