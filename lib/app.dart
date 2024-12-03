import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solar_energy_monitoring_tool/monitoring/cubit/monitoring_cubit.dart';
import 'package:solar_energy_monitoring_tool/monitoring/models/monitoring.dart';
import 'package:solar_energy_monitoring_tool/monitoring/repository/monitoring_repository.dart';
import 'package:solar_energy_monitoring_tool/monitoring/view/monitoring_page.dart';
import 'package:solar_energy_monitoring_tool/theme/cubit/theme_cubit.dart';
import 'package:solar_energy_monitoring_tool/theme/cubit/theme_state.dart';
import 'package:solar_energy_monitoring_tool/theme/theme.dart';

class EnergyMonitoringApp extends StatelessWidget {
  const EnergyMonitoringApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider<ThemeCubit>(create: (_) => ThemeCubit()),
      BlocProvider<MonitoringCubit>(
          create: (_) => MonitoringCubit(MonitoringRepository())
            ..fetchMonitoringData(date: CustomDate(value: DateTime.now())))
    ], child: const EnergyMonitoringAppView());
  }
}

class EnergyMonitoringAppView extends StatelessWidget {
  const EnergyMonitoringAppView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(builder: (context, state) {
      return MaterialApp(
          theme: MonitoringTheme.light,
          darkTheme: MonitoringTheme.dark,
          themeMode: state.themeMode,
          debugShowCheckedModeBanner: false,
          home: const MonitoringPage());
    });
  }
}
