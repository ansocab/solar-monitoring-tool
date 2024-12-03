import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solar_energy_monitoring_tool/monitoring/cubit/monitoring_cubit.dart';
import 'package:solar_energy_monitoring_tool/monitoring/cubit/monitoring_state.dart';
import 'package:solar_energy_monitoring_tool/monitoring/models/monitoring.dart';
import 'package:solar_energy_monitoring_tool/monitoring/widgets/monitoring_line_chart.dart';
import 'package:solar_energy_monitoring_tool/utils/helpers.dart';

class MonitoringDetails extends StatelessWidget {
  const MonitoringDetails({
    super.key,
    required this.metric,
    required this.graphData,
  });

  final Metrics metric;
  final List<MonitoringDataItem> graphData;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(metric.toTitle),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                formatEnergyValue(getSum(graphData),
                    context.read<MonitoringCubit>().state.selectedUnit),
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              DropdownMenu(
                dropdownMenuEntries: EnergyUnit.values
                    .map<DropdownMenuEntry<EnergyUnit>>((EnergyUnit unit) {
                  return DropdownMenuEntry<EnergyUnit>(
                      value: unit,
                      label:
                          unit.name[0].toUpperCase() + unit.name.substring(1));
                }).toList(),
                onSelected: (EnergyUnit? unit) {
                  if (unit != null) {
                    context.read<MonitoringCubit>().selectUnit(unit);
                  }
                },
                initialSelection:
                    context.read<MonitoringCubit>().state.selectedUnit,
                requestFocusOnTap: false,
                width: 145,
                trailingIcon: const Icon(Icons.expand_more_rounded, size: 30),
                textStyle: Theme.of(context).textTheme.bodyMedium,
                inputDecorationTheme: InputDecorationTheme(
                    contentPadding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25))),
              ),
            ],
          ),
          MonitoringLineChart(graphData: graphData)
        ],
      ),
    );
    // );
  }
}

extension on Metrics {
  String get toTitle {
    switch (this) {
      case Metrics.solar:
        return 'Solar Generation';
      case Metrics.house:
        return 'House Consumption';
      case Metrics.battery:
        return 'Battery Consumption';
    }
  }
}
