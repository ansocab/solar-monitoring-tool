import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:solar_energy_monitoring_tool/monitoring/cubit/monitoring_cubit.dart';
import 'package:solar_energy_monitoring_tool/monitoring/models/monitoring.dart';
import 'package:solar_energy_monitoring_tool/utils/helpers.dart';

class MonitoringLineChart extends StatelessWidget {
  const MonitoringLineChart({super.key, required this.graphData});

  final List<MonitoringDataItem> graphData;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 450,
      child: Padding(
        padding: const EdgeInsets.only(right: 15),
        child: LineChart(LineChartData(
            maxY: 10000,
            gridData: const FlGridData(show: false),
            borderData: FlBorderData(show: false),
            titlesData: FlTitlesData(
                topTitles:
                    const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles:
                    const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                        showTitles: true,
                        interval: 75,
                        getTitlesWidget: (value, meta) {
                          int index = value.toInt();
                          if (index >= 0 && index < graphData.length) {
                            DateTime date =
                                DateTime.parse(graphData[index].timestamp);
                            return Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Text(
                                DateFormat.Hm().format(date),
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            );
                          }
                          return const Text('');
                        })),
                leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                        showTitles: true,
                        interval: 2000,
                        reservedSize: 52,
                        minIncluded: false,
                        maxIncluded: false,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            formatEnergyValue(
                                value,
                                context
                                    .read<MonitoringCubit>()
                                    .state
                                    .selectedUnit),
                            style: Theme.of(context).textTheme.bodySmall,
                          );
                        }))),
            lineBarsData: [
              LineChartBarData(
                  spots: graphData
                      .asMap()
                      .entries
                      .map((entry) => FlSpot(
                            entry.key.toDouble(),
                            entry.value.value.toDouble(),
                          ))
                      .toList(),
                  isCurved: true,
                  barWidth: 0.1,
                  color: Theme.of(context).colorScheme.primary,
                  dotData: const FlDotData(show: false),
                  preventCurveOverShooting: true,
                  belowBarData: BarAreaData(show: true, color: Colors.black12)),
            ],
            lineTouchData: LineTouchData(
                touchTooltipData: LineTouchTooltipData(
                    getTooltipItems: (touchedSpots) {
                      return touchedSpots.map((spot) {
                        return LineTooltipItem(
                            formatEnergyValue(
                                spot.y,
                                context
                                    .read<MonitoringCubit>()
                                    .state
                                    .selectedUnit),
                            TextStyle(
                                color: Theme.of(context).colorScheme.primary));
                      }).toList();
                    },
                    getTooltipColor: (touchedSpot) =>
                        Theme.of(context).colorScheme.background)))),
      ),
    );
  }
}
