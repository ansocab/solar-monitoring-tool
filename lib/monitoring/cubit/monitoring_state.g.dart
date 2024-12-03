// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'monitoring_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MonitoringState _$MonitoringStateFromJson(Map<String, dynamic> json) =>
    MonitoringState(
      status: $enumDecodeNullable(_$MonitoringStatusEnumMap, json['status']) ??
          MonitoringStatus.loading,
      selectedUnit:
          $enumDecodeNullable(_$EnergyUnitEnumMap, json['selectedUnit']) ??
              EnergyUnit.kilowatts,
      monitoringData: (json['monitoringData'] as Map<String, dynamic>?)?.map(
        (k, e) =>
            MapEntry(k, MonitoringData.fromJson(e as Map<String, dynamic>)),
      ),
      error: $enumDecodeNullable(_$MonitoringErrorEnumMap, json['error']),
      selectedDate: json['selectedDate'] == null
          ? null
          : CustomDate.fromJson(json['selectedDate'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MonitoringStateToJson(MonitoringState instance) =>
    <String, dynamic>{
      'status': _$MonitoringStatusEnumMap[instance.status]!,
      'monitoringData':
          instance.monitoringData?.map((k, e) => MapEntry(k, e.toJson())),
      'selectedUnit': _$EnergyUnitEnumMap[instance.selectedUnit]!,
      'selectedDate': instance.selectedDate.toJson(),
      'error': _$MonitoringErrorEnumMap[instance.error],
    };

const _$MonitoringStatusEnumMap = {
  MonitoringStatus.loading: 'loading',
  MonitoringStatus.success: 'success',
  MonitoringStatus.failure: 'failure',
};

const _$EnergyUnitEnumMap = {
  EnergyUnit.watts: 'watts',
  EnergyUnit.kilowatts: 'kilowatts',
};

const _$MonitoringErrorEnumMap = {
  MonitoringError.emptyResponse: 'emptyResponse',
  MonitoringError.networkError: 'networkError',
  MonitoringError.generic: 'generic',
};
