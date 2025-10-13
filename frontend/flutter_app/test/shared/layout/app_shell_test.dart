import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_app/shared/layout/app_shell.dart';
import 'package:flutter_app/shared/theme/app_theme.dart';
import 'package:flutter_app/shared/theme/theme_cubit.dart';

import '../../helpers/hydrated_bloc.dart';

class _TestNavigationShell extends StatefulWidget
    implements StatefulNavigationShell {
  const _TestNavigationShell({
    required this.currentIndexNotifier,
    required this.onGoBranch,
    this.child = const SizedBox.shrink(),
  });

  final ValueNotifier<int> currentIndexNotifier;
  final void Function(int index, {bool initialLocation}) onGoBranch;
  final Widget child;

  @override
  int get currentIndex => currentIndexNotifier.value;

  @override
  ShellRouteContext get shellRouteContext => throw UnimplementedError();

  @override
  ShellNavigationContainerBuilder get containerBuilder =>
      throw UnimplementedError();

  @override
  StatefulShellRoute get route => throw UnimplementedError();

  @override
  void goBranch(int index, {bool initialLocation = false}) {
    onGoBranch(index, initialLocation: initialLocation);
    if (currentIndexNotifier.value != index) {
      currentIndexNotifier.value = index;
    }
  }

  @override
  State<_TestNavigationShell> createState() => _TestNavigationShellState();
}

class _TestNavigationShellState extends State<_TestNavigationShell> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: widget.currentIndexNotifier,
      builder: (context, index, _) {
        return KeyedSubtree(
          key: ValueKey('test-shell-$index'),
          child: widget.child,
        );
      },
    );
  }
}

Widget _buildTestAppShell({
  required ThemeCubit themeCubit,
  required StatefulNavigationShell navigationShell,
  Locale? locale,
}) {
  return BlocProvider.value(
    value: themeCubit,
    child: BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, themeMode) {
        return MaterialApp(
          locale: locale,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          theme: AppTheme.light(),
          darkTheme: AppTheme.dark(),
          themeMode: themeMode,
          home: AppShell(navigationShell: navigationShell),
        );
      },
    ),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AppShell', () {
    testWidgets('toggles the theme and updates the action button state',
        (tester) async {
      await runHydrated(() async {
        final themeCubit = ThemeCubit();
        addTearDown(themeCubit.close);
        final currentIndexNotifier = ValueNotifier<int>(0);
        addTearDown(currentIndexNotifier.dispose);

        themeCubit.updateTheme(ThemeMode.dark);
        await tester.pumpWidget(
          _buildTestAppShell(
            themeCubit: themeCubit,
            navigationShell: _TestNavigationShell(
              currentIndexNotifier: currentIndexNotifier,
              onGoBranch: (_, {bool initialLocation = false}) {},
            ),
            locale: const Locale('en'),
          ),
        );
        await tester.pumpAndSettle();

        final darkIconFinder = find.byIcon(Icons.dark_mode);
        expect(darkIconFinder, findsOneWidget);

        final localizations = await AppLocalizations.delegate.load(
          const Locale('en'),
        );
        expect(
          find.byTooltip(localizations.themeToggleTooltip),
          findsOneWidget,
        );

        final emitted = <ThemeMode>[];
        final listener = themeCubit.stream.listen(emitted.add);
        addTearDown(listener.cancel);

        await tester.tap(find.byTooltip(localizations.themeToggleTooltip));
        await tester.pumpAndSettle();

        expect(emitted, isNotEmpty);
        expect(emitted.last, ThemeMode.system);
        expect(themeCubit.state, ThemeMode.system);
        expect(find.byIcon(Icons.light_mode), findsOneWidget);
      });
    });

    testWidgets('delegates navigation to the shell with correct arguments',
        (tester) async {
      await runHydrated(() async {
        final themeCubit = ThemeCubit();
        addTearDown(themeCubit.close);

        final currentIndexNotifier = ValueNotifier<int>(0);
        addTearDown(currentIndexNotifier.dispose);

        final calls = <({int index, bool initialLocation})>[];
        final navigationShell = _TestNavigationShell(
          currentIndexNotifier: currentIndexNotifier,
          onGoBranch: (index, {bool initialLocation = false}) {
            calls.add((index: index, initialLocation: initialLocation));
          },
        );

        await tester.pumpWidget(
          _buildTestAppShell(
            themeCubit: themeCubit,
            navigationShell: navigationShell,
            locale: const Locale('en'),
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.text('Products'));
        await tester.pump();

        expect(
          calls.last,
          (index: 1, initialLocation: false),
        );

        await tester.tap(find.text('Products'));
        await tester.pump();

        expect(
          calls.last,
          (index: 1, initialLocation: true),
        );
      });
    });

    testWidgets('renders localized labels for supported locales', (tester) async {
      await runHydrated(() async {
        // Move these out of the loop so they’re disposed only once:
        final themeCubit = ThemeCubit();
        addTearDown(themeCubit.close);
        final currentIndexNotifier = ValueNotifier<int>(0);
        addTearDown(currentIndexNotifier.dispose);

        for (final locale in AppLocalizations.supportedLocales) {
          final navigationShell = _TestNavigationShell(
            currentIndexNotifier: currentIndexNotifier,
            onGoBranch: (_, {bool initialLocation = false}) {},
          );

          final localizations = await AppLocalizations.delegate.load(locale);

          await tester.pumpWidget(
            _buildTestAppShell(
              themeCubit: themeCubit,
              navigationShell: navigationShell,
              locale: locale,
            ),
          );
          await tester.pumpAndSettle();

          expect(find.text(localizations.appTitle), findsOneWidget);
          expect(
            find.byTooltip(localizations.themeToggleTooltip),
            findsOneWidget,
          );

          await tester.pumpWidget(const SizedBox.shrink());
          await tester.pump();
        }
      });
    });
  });
}
