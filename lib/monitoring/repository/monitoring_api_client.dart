import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:solar_energy_monitoring_tool/monitoring/models/monitoring.dart';

class MonitoringRequestFailure implements Exception {}

class NoDataAvailableFailure implements Exception {}

class MonitoringApiClient {
  MonitoringApiClient({http.Client? httpClient})
      : _httpClient = httpClient ?? http.Client();

  static const _baseUrl = 'localhost:3000';
  final http.Client _httpClient;

  Future<List<MonitoringDataItem>> fetchMonitoring(
      {required Metrics metric, required CustomDate date}) async {
    final request = Uri.http(
        _baseUrl, '/monitoring', {'date': date.stringKey, 'type': metric.name});

    final response = await _httpClient.get(request);

    if (response.statusCode != 200) {
      throw MonitoringRequestFailure();
    }

    final List<dynamic> bodyJson = jsonDecode(response.body);

    if (bodyJson.isEmpty) {
      throw NoDataAvailableFailure();
    }

    return bodyJson.map((json) => MonitoringDataItem.fromJson(json)).toList();
  }
}
