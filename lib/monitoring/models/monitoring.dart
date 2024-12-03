import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:intl/intl.dart';

part 'monitoring.g.dart';

enum Metrics { solar, house, battery }

@JsonSerializable()
class MonitoringData extends Equatable {
  const MonitoringData(
      {required this.solar, required this.house, required this.battery});

  final List<MonitoringDataItem> solar;
  final List<MonitoringDataItem> house;
  final List<MonitoringDataItem> battery;

  @override
  List<Object> get props => [solar, house, battery];

  factory MonitoringData.fromJson(Map<String, dynamic> json) =>
      _$MonitoringDataFromJson(json);

  Map<String, dynamic> toJson() => _$MonitoringDataToJson(this);
}

@JsonSerializable()
class MonitoringDataItem {
  const MonitoringDataItem({required this.timestamp, required this.value});

  factory MonitoringDataItem.fromJson(Map<String, dynamic> json) =>
      _$MonitoringDataItemFromJson(json);

  Map<String, dynamic> toJson() => _$MonitoringDataItemToJson(this);

  final String timestamp;
  final int value;
}

@JsonSerializable()
class CustomDate {
  const CustomDate({required this.value});

  factory CustomDate.fromJson(Map<String, dynamic> json) =>
      _$CustomDateFromJson(json);

  Map<String, dynamic> toJson() => _$CustomDateToJson(this);

  final DateTime value;

  String get stringKey {
    return DateFormat('yyyy-MM-dd').format(value).toString();
  }
}

enum MonitoringError { emptyResponse, networkError, generic }
