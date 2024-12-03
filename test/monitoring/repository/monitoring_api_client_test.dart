import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:solar_energy_monitoring_tool/monitoring/models/monitoring.dart';
import 'package:solar_energy_monitoring_tool/monitoring/repository/monitoring_api_client.dart';
import 'package:flutter_test/flutter_test.dart';

class MockHttpClient extends Mock implements http.Client {}

class MockResponse extends Mock implements http.Response {}

class FakeUri extends Fake implements Uri {}

void main() {
  group('MonitoringApiClient', () {
    late http.Client httpClient;
    late MonitoringApiClient apiClient;

    setUpAll(() {
      registerFallbackValue(FakeUri());
    });

    setUp(() {
      httpClient = MockHttpClient();
      apiClient = MonitoringApiClient(httpClient: httpClient);
    });

    group('constructor', () {
      test('does not require an httpClient', () {
        expect(MonitoringApiClient(), isNotNull);
      });
    });

    group('fetchMonitoring', () {
      const metric = Metrics.solar;
      final date = CustomDate(value: DateTime(2024, 11, 26));
      test('makes correct http request', () async {
        final response = MockResponse();
        when(() => httpClient.get(any())).thenAnswer((_) async => response);
        try {
          await apiClient.fetchMonitoring(metric: metric, date: date);
        } catch (_) {}
        verify(
          () => httpClient.get(
            Uri.http(
              'localhost:3000',
              '/monitoring',
              {'date': date.stringKey, 'type': metric.name},
            ),
          ),
        ).called(1);
      });

      test('throws MonitoringException on non-200 response', () async {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(400);
        when(() => httpClient.get(any())).thenAnswer((_) async => response);
        expect(
          () async => apiClient.fetchMonitoring(metric: metric, date: date),
          throwsA(isA<MonitoringRequestFailure>()),
        );
      });

      test('throws MonitoringException on emtpy response', () async {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(200);
        when(() => response.body).thenReturn('[]');
        when(() => httpClient.get(any())).thenAnswer((_) async => response);
        expect(
          () async => apiClient.fetchMonitoring(metric: metric, date: date),
          throwsA(isA<NoDataAvailableFailure>()),
        );
      });

      test('throws monitoring data item on valid response', () async {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(200);
        when(() => response.body).thenReturn(
          '''
[
{"timestamp":"2024-11-21T03:45:00.000Z","value":2250},
{"timestamp":"2024-11-21T03:50:00.000Z","value":3023}
]
''',
        );
        when(() => httpClient.get(any())).thenAnswer((_) async => response);
        final actual =
            await apiClient.fetchMonitoring(metric: metric, date: date);
        expect(
            actual,
            isA<List<MonitoringDataItem>>()
                .having((l) => l[0].timestamp, 'timestamp',
                    '2024-11-21T03:45:00.000Z')
                .having((l) => l[0].value, 'value', 2250));
      });
    });
  });
}
