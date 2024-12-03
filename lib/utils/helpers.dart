import 'package:intl/intl.dart';
import 'package:solar_energy_monitoring_tool/monitoring/cubit/monitoring_state.dart';
import 'package:solar_energy_monitoring_tool/monitoring/models/monitoring.dart';

String formatEnergyValue(double value, EnergyUnit unit) {
  NumberFormat formatter = NumberFormat.decimalPattern();

  return unit == EnergyUnit.watts
      ? '${formatter.format(value)} W'
      : '${(value ~/ 1000).toString()} kW';
}

double getSum(List<MonitoringDataItem> items) {
  return items.fold(0, (sum, item) => sum + item.value);
}
