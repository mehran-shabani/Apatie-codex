import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';
import 'package:apatie/l10n/app_localizations.dart';
import 'package:apatie/shared/config/app_config.dart';

import 'app_router.dart';
import 'shared/theme/app_theme.dart';
import 'shared/theme/theme_cubit.dart';

class App extends StatelessWidget {
  App({super.key, required this.config}) : _appRouter = AppRouter();

  final AppConfig config;
  final AppRouter _appRouter;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: config,
      child: BlocProvider(
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
                Intl.defaultLocale =
                    Intl.canonicalizedLocale(resolved.toLanguageTag());
                return resolved;
              },
            );
          },
        ),
      ),
    );
  }
}
