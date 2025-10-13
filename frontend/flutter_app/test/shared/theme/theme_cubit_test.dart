import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:apatie/shared/theme/theme_cubit.dart';
import '../../helpers/hydrated_bloc.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ThemeCubit', () {
    test('starts with system theme', () async {
      await runHydrated(() async {
        final cubit = ThemeCubit();
        addTearDown(cubit.close);

        expect(cubit.state, equals(ThemeMode.system));
      }, storage: buildMockHydratedStorage());
    });

    test('toggles between light and dark themes', () async {
      await runHydrated(() async {
        final cubit = ThemeCubit();
        addTearDown(cubit.close);

        cubit.toggleTheme();
        expect(cubit.state, equals(ThemeMode.dark));

        cubit.toggleTheme();
        expect(cubit.state, equals(ThemeMode.light));
      }, storage: buildMockHydratedStorage());
    });

    test('restores persisted theme mode from storage', () async {
      await runHydrated(() async {
        final cubit = ThemeCubit();
        addTearDown(cubit.close);

        expect(cubit.state, equals(ThemeMode.dark));
      }, storageValues: {
        'ThemeCubit': {'themeMode': 'dark'},
      });
    });

    test('persists theme mode changes to storage', () async {
      final storage = buildMockHydratedStorage();
      late ThemeCubit cubit;

      await runHydrated(() async {
        cubit = ThemeCubit();
        addTearDown(cubit.close);

        cubit.updateTheme(ThemeMode.dark);
      }, storage: storage);

      verify(() => storage.write('ThemeCubit', {'themeMode': 'dark'})).called(1);
    });
  });
}
