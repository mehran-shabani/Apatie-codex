import 'package:apatie/design_system/foundations/colors.dart';
import 'package:apatie/design_system/foundations/spacing.dart';
import 'package:apatie/shared/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

/// A reusable golden configuration helper tailored for the Apatie design system.
///
/// The configuration wraps every widget with the design system theme, enforces an
/// RTL layout, and exposes shared presets for surfaces and devices so that
/// tests can remain concise and expressive.
class GoldenConfig {
  const GoldenConfig._();

  /// Default locale used by the product (Persian / RTL).
  static const Locale defaultLocale = Locale('fa');

  /// Default padding used to provide breathing room around components.
  static const EdgeInsetsDirectional defaultSurfacePadding =
      EdgeInsetsDirectional.fromSTEB(
    AppSpacing.lg,
    AppSpacing.lg,
    AppSpacing.lg,
    AppSpacing.lg,
  );

  /// Wraps the provided [child] with all theming, localization and direction
  /// requirements expected by the design system.
  static Widget surface({
    required Widget child,
    required GoldenSurface surface,
    EdgeInsetsGeometry padding = defaultSurfacePadding,
  }) {
    final theme = surface.themeMode == ThemeMode.dark
        ? AppTheme.dark()
        : AppTheme.light();

    final colorScheme = theme.colorScheme.copyWith(
      background: surface.backgroundColor,
      surface: surface.surfaceColor,
    );

    final themed = theme.copyWith(
      colorScheme: colorScheme,
      scaffoldBackgroundColor: surface.backgroundColor,
      canvasColor: surface.surfaceColor,
    );

    return Localizations(
      locale: defaultLocale,
      delegates: const <LocalizationsDelegate<dynamic>>[
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      child: Theme(
        data: themed,
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
            color: surface.backgroundColor,
            padding: padding,
            child: DefaultTextStyle(
              style: themed.textTheme.bodyMedium!,
              child: child,
            ),
          ),
        ),
      ),
    );
  }

  /// Pumps a widget under the provided [surfaces] and [device] before asserting
  /// against the golden file whose base [name] is provided.
  ///
  /// Fonts provided by golden_toolkit (Roboto et al.) are loaded up-front so the
  /// typography defined in the design system remains stable across environments.
  static Future<void> pumpGoldenWidget(
    WidgetTester tester, {
    required String name,
    required Widget widget,
    List<GoldenSurface> surfaces = GoldenSurfaces.primary,
    Device device = GoldenDevices.phoneSmall,
    EdgeInsetsGeometry? padding,
  }) async {
    await loadAppFonts();

    final builder = DeviceBuilder()
      ..overrideDevicesForAllScenarios(<Device>[device]);

    for (final surface in surfaces) {
      builder.addScenario(
        name: surface.name,
        widget: GoldenConfig.surface(
          child: widget,
          surface: surface,
          padding: padding ?? defaultSurfacePadding,
        ),
      );
    }

    await tester.pumpDeviceBuilder(builder);
    await tester.pumpAndSettle();

    await screenMatchesGolden(tester, name);
  }
}

/// Represents a commonly used device size preset.
class GoldenDevices {
  const GoldenDevices._();

  static const Device phoneSmall = Device(
    name: 'phoneSmall',
    size: Size(360, 690),
    devicePixelRatio: 3.0,
    textScale: 1.0,
  );

  static const List<Device> defaults = <Device>[phoneSmall];
}

/// Represents a surface preset describing theme mode and palette.
class GoldenSurface {
  const GoldenSurface._({
    required this.name,
    required this.palette,
    required this.themeMode,
  });

  final String name;
  final AppColorPalette palette;
  final ThemeMode themeMode;

  Color get backgroundColor => palette.colorScheme.background;
  Color get surfaceColor => palette.colorScheme.surface;
}

class GoldenSurfaces {
  const GoldenSurfaces._();

  static const GoldenSurface light = GoldenSurface._(
    name: 'light',
    palette: AppColors.light,
    themeMode: ThemeMode.light,
  );

  static const GoldenSurface dark = GoldenSurface._(
    name: 'dark',
    palette: AppColors.dark,
    themeMode: ThemeMode.dark,
  );

  static const List<GoldenSurface> primary = <GoldenSurface>[light, dark];
}
