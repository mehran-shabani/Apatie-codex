import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';
import 'package:apatie/l10n/app_localizations.dart';

import 'app_router.dart';
import 'shared/theme/app_theme.dart';
import 'shared/theme/theme_cubit.dart';

class App extends StatelessWidget {
  App({super.key});

  final AppRouter _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ThemeCubit(),
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          const defaultLocale = Locale('fa');
          return MaterialApp.router(
            title: 'Apatie Codex',
            theme: AppTheme.light(),
            darkTheme: AppTheme.dark(),
            themeMode: themeMode,
            routerConfig: _appRouter.router,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            localeListResolutionCallback: (locales, supported) {
              final requestedLocales = locales ?? <Locale>[];
              final resolved = requestedLocales.firstWhere(
                (locale) => supported.any(
                  (supportedLocale) =>
                      supportedLocale.languageCode == locale.languageCode,
                ),
                orElse: () => defaultLocale,
              );
              Intl.defaultLocale = resolved.toLanguageTag();
              return resolved;
            },
            builder: (context, child) {
              final locale = Localizations.maybeLocaleOf(context) ?? defaultLocale;
              Intl.defaultLocale = locale.toLanguageTag();
              final isRtl = ui.Bidi.isRtlLanguage(locale.languageCode);
              final resolvedChild = child ?? const SizedBox.shrink();

              return Directionality(
                textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
                child: resolvedChild,
              );
            },
          );
        },
      ),
    );
  }
}
