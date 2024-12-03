import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:solar_energy_monitoring_tool/monitoring/models/monitoring.dart';
import 'package:solar_energy_monitoring_tool/monitoring/repository/monitoring_api_client.dart';
import 'package:solar_energy_monitoring_tool/monitoring/repository/monitoring_repository.dart';

import '../../helpers/mock_data.dart';

class MockMonitoringApiClient extends Mock implements MonitoringApiClient {}

class MockMonitoringDataItem extends Mock implements MonitoringDataItem {}

void main() {
  group('MonitoringRepository', () {
    late MonitoringApiClient monitoringApiClient;
    late MonitoringRepository monitoringRepository;

    setUpAll(() {
      registerFallbackValue(Metrics.solar);
    });

    setUp(() {
      monitoringApiClient = MockMonitoringApiClient();
      monitoringRepository =
          MonitoringRepository(monitoringApiClient: monitoringApiClient);
    });

    group('contructor', () {
      test('instantiates internal monitoring api client when not injected', () {
        expect(MonitoringRepository(), isNotNull);
      });
    });

    group('getMonitoringData', () {
      final date = CustomDate(value: DateTime(2024, 11, 26));

      test('calls fetchMonitoring with correct date and metrics', () async {
        final monitoringDataItem = MockMonitoringDataItem();

        when(() => monitoringApiClient.fetchMonitoring(
            metric: any(named: 'metric'),
            date: date)).thenAnswer((_) async => [monitoringDataItem]);
        try {
          await monitoringRepository.getMonitoringData(date: date);
        } catch (_) {}
        verify(() => monitoringApiClient.fetchMonitoring(
            metric: Metrics.solar, date: date)).called(1);
        verify(() => monitoringApiClient.fetchMonitoring(
            metric: Metrics.house, date: date)).called(1);
        verify(() => monitoringApiClient.fetchMonitoring(
            metric: Metrics.battery, date: date)).called(1);
      });

      test('throws when fetchMonitoring fails', () async {
        final exception = Exception('some error');
        when(() => monitoringApiClient.fetchMonitoring(
            metric: any(named: 'metric'), date: date)).thenThrow(exception);
        expect(
          () async => monitoringRepository.getMonitoringData(date: date),
          throwsA(exception),
        );
      });

      test('returns correct monitoring data on success', () async {
        final mockData = MockData();
        when(() => monitoringApiClient.fetchMonitoring(
            metric: Metrics.solar,
            date: date)).thenAnswer((_) async => mockData.solarMonitoringData);
        when(() => monitoringApiClient.fetchMonitoring(
            metric: Metrics.house,
            date: date)).thenAnswer((_) async => mockData.houseMonitoringData);
        when(() => monitoringApiClient.fetchMonitoring(
                metric: Metrics.battery, date: date))
            .thenAnswer((_) async => mockData.batteryMonitoringData);
        final actual = await monitoringRepository.getMonitoringData(date: date);
        expect(
            actual,
            MonitoringData(
                solar: mockData.solarMonitoringData,
                house: mockData.houseMonitoringData,
                battery: mockData.batteryMonitoringData));
      });
    });
  });
}
