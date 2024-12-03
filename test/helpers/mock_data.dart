import 'package:solar_energy_monitoring_tool/monitoring/models/monitoring.dart';

class MockData {
  final solarMonitoringData = [
    const MonitoringDataItem(timestamp: "2024-11-26T03:45:00.000Z", value: 2250)
  ];
  final houseMonitoringData = [
    const MonitoringDataItem(timestamp: "2024-11-26T03:45:00.000Z", value: 2000)
  ];
  final batteryMonitoringData = [
    const MonitoringDataItem(timestamp: "2024-11-26T03:45:00.000Z", value: 1880)
  ];

  MonitoringData get mockMonitoringData => MonitoringData(
      solar: solarMonitoringData,
      house: houseMonitoringData,
      battery: batteryMonitoringData);
}
