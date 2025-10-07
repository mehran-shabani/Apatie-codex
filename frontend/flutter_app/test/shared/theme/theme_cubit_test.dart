import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

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

      expect(cubit.state, equals(ThemeMode.system));
    });

    test('toggles between light and dark themes', () {
      final storage = buildMockHydratedStorage();
      final cubit = HydratedBlocOverrides.runZoned<ThemeCubit>(
        ThemeCubit.new,
        storage: storage,
      );

      cubit.toggleTheme();
      expect(cubit.state, equals(ThemeMode.dark));

      cubit.toggleTheme();
      expect(cubit.state, equals(ThemeMode.light));
    });
  });
}
