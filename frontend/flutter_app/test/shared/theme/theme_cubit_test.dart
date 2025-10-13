import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mocktail/mocktail.dart';

import 'package:flutter_app/shared/theme/theme_cubit.dart';
import '../../helpers/hydrated_bloc.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ThemeCubit', () {
    test('starts with system theme', () {
      final storage = buildMockHydratedStorage();
      final cubit = HydratedBlocOverrides.runZoned<ThemeCubit>(
        ThemeCubit.new,
        storage: storage,
      );
      addTearDown(cubit.close);

      expect(cubit.state, equals(ThemeMode.system));
    });

    test('toggles between light and dark themes', () {
      final storage = buildMockHydratedStorage();
      final cubit = HydratedBlocOverrides.runZoned<ThemeCubit>(
        ThemeCubit.new,
        storage: storage,
      );
      addTearDown(cubit.close);

      cubit.toggleTheme();
      expect(cubit.state, equals(ThemeMode.dark));

      cubit.toggleTheme();
      expect(cubit.state, equals(ThemeMode.light));
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

    test('persists theme mode changes to storage', () {
      final storage = buildMockHydratedStorage();
      final cubit = HydratedBlocOverrides.runZoned<ThemeCubit>(
        ThemeCubit.new,
        storage: storage,
      );
      addTearDown(cubit.close);

      cubit.updateTheme(ThemeMode.dark);

      verify(
        () => storage.write('ThemeCubit', {'themeMode': 'dark'}),
      ).called(1);
    });
  });
}
