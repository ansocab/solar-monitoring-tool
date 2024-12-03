import 'package:solar_energy_monitoring_tool/monitoring/models/monitoring.dart';
import 'package:solar_energy_monitoring_tool/monitoring/repository/monitoring_api_client.dart';

class MonitoringRepository {
  MonitoringRepository({MonitoringApiClient? monitoringApiClient})
      : _monitoringApiClient = monitoringApiClient ?? MonitoringApiClient();

  final MonitoringApiClient _monitoringApiClient;

  Future<MonitoringData> getMonitoringData({required CustomDate date}) async {
    final solarData = await _monitoringApiClient.fetchMonitoring(
        metric: Metrics.solar, date: date);
    final houseData = await _monitoringApiClient.fetchMonitoring(
        metric: Metrics.house, date: date);
    final batteryData = await _monitoringApiClient.fetchMonitoring(
        metric: Metrics.battery, date: date);

    return MonitoringData(
        solar: solarData, house: houseData, battery: batteryData);
  }
}
