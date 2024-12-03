// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'monitoring.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MonitoringData _$MonitoringDataFromJson(Map<String, dynamic> json) =>
    MonitoringData(
      solar: (json['solar'] as List<dynamic>)
          .map((e) => MonitoringDataItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      house: (json['house'] as List<dynamic>)
          .map((e) => MonitoringDataItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      battery: (json['battery'] as List<dynamic>)
          .map((e) => MonitoringDataItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MonitoringDataToJson(MonitoringData instance) =>
    <String, dynamic>{
      'solar': instance.solar,
      'house': instance.house,
      'battery': instance.battery,
    };

MonitoringDataItem _$MonitoringDataItemFromJson(Map<String, dynamic> json) =>
    MonitoringDataItem(
      timestamp: json['timestamp'] as String,
      value: (json['value'] as num).toInt(),
    );

Map<String, dynamic> _$MonitoringDataItemToJson(MonitoringDataItem instance) =>
    <String, dynamic>{
      'timestamp': instance.timestamp,
      'value': instance.value,
    };

CustomDate _$CustomDateFromJson(Map<String, dynamic> json) => CustomDate(
      value: DateTime.parse(json['value'] as String),
    );

Map<String, dynamic> _$CustomDateToJson(CustomDate instance) =>
    <String, dynamic>{
      'value': instance.value.toIso8601String(),
    };
