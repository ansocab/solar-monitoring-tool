import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter/material.dart';
import 'package:solar_energy_monitoring_tool/monitoring/cubit/monitoring_cubit.dart';
import 'package:solar_energy_monitoring_tool/monitoring/models/monitoring.dart';

class MonitoringErrorView extends StatelessWidget {
  const MonitoringErrorView({super.key});

  @override
  Widget build(BuildContext context) {
    final monitoringCubit = context.read<MonitoringCubit>();

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.all(15),
          child: Text(
            monitoringCubit.state.error?.message ?? 'Something went wrong!',
            textAlign: TextAlign.center,
          ),
        ),
        OutlinedButton(
            onPressed: (() {
              monitoringCubit.fetchMonitoringData(
                  date: monitoringCubit.state.selectedDate);
            }),
            child: const Text("Try again"))
      ],
    );
  }
}

extension on MonitoringError {
  String get message {
    switch (this) {
      case MonitoringError.emptyResponse:
        return 'There is no monitoring data available for the selected date. Please select a different date.';
      case MonitoringError.networkError:
        return 'It looks like you are offline. Please check your internet connection and try again.';
      default:
        return 'We could not load your monitoring data. Please try again later.';
    }
  }
}
