import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

class ThemeCubit extends HydratedCubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.system);

  void updateTheme(ThemeMode mode) => emit(mode);

  void toggleTheme() {
    switch (state) {
      case ThemeMode.system:
        emit(ThemeMode.light);
        break;
      case ThemeMode.light:
        emit(ThemeMode.dark);
        break;
      case ThemeMode.dark:
        emit(ThemeMode.system);
        break;
    }
  }

  @override
  ThemeMode? fromJson(Map<String, dynamic> json) {
    final value = json['themeMode'] as String?;
    if (value == null) return null;
    return ThemeMode.values.firstWhere(
      (mode) => mode.name == value,
      orElse: () => ThemeMode.system,
    );
  }

  @override
  Map<String, dynamic>? toJson(ThemeMode state) => {
        'themeMode': state.name,
      };
}
