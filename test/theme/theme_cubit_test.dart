import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:solar_energy_monitoring_tool/theme/cubit/theme_cubit.dart';
import 'package:solar_energy_monitoring_tool/theme/cubit/theme_state.dart';

void main() {
  group('ThemeCubit', () {
    test('has correct initial state', () {
      expect(ThemeCubit().state, equals(const ThemeState()));
    });

    blocTest<ThemeCubit, ThemeState>(
      'sets theme to given value',
      build: () => ThemeCubit(),
      act: (cubit) => cubit.setThemeMode(ThemeMode.dark),
      expect: () => [const ThemeState(themeMode: ThemeMode.dark)],
    );
  });
}
