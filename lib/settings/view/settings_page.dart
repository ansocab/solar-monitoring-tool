import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:solar_energy_monitoring_tool/monitoring/cubit/monitoring_cubit.dart';
import 'package:solar_energy_monitoring_tool/theme/cubit/theme_cubit.dart';
import 'package:solar_energy_monitoring_tool/theme/cubit/theme_state.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  void showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _clearCache(BuildContext context) async {
    if (!context.mounted) return;
    context.read<MonitoringCubit>().clearMonitoringData();
    final storage = HydratedBloc.storage;
    await storage.clear();
    if (!context.mounted) return;
    showSnackBar(context, 'Cache successfully deleted');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Settings")),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Dark mode"),
                BlocBuilder<ThemeCubit, ThemeState>(
                  builder: (context, state) {
                    return Switch(
                      value: context.read<ThemeCubit>().state.themeMode ==
                          ThemeMode.dark,
                      onChanged: (bool isOn) {
                        context.read<ThemeCubit>().setThemeMode(
                            isOn ? ThemeMode.dark : ThemeMode.light);
                      },
                    );
                  },
                )
              ],
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Clear cache"),
                OutlinedButton(
                    onPressed: () => _clearCache(context),
                    child: const Text("Clear"))
              ],
            ),
            const Divider()
          ]),
        ));
  }
}
