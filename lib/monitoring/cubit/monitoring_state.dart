import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:solar_energy_monitoring_tool/monitoring/models/monitoring.dart';

part 'monitoring_state.g.dart';

enum MonitoringStatus { loading, success, failure }

enum MonitoringMetric { solar, heatpump, wallbox }

enum EnergyUnit { watts, kilowatts }

@JsonSerializable(explicitToJson: true)
final class MonitoringState extends Equatable {
  MonitoringState(
      {this.status = MonitoringStatus.loading,
      this.selectedUnit = EnergyUnit.kilowatts,
      this.monitoringData,
      this.error,
      CustomDate? selectedDate})
      : selectedDate = selectedDate ?? CustomDate(value: DateTime.now());

  factory MonitoringState.fromJson(Map<String, dynamic> json) =>
      _$MonitoringStateFromJson(json);

  final MonitoringStatus status;
  final Map<String, MonitoringData>? monitoringData;
  final EnergyUnit selectedUnit;
  final CustomDate selectedDate;
  final MonitoringError? error;

  MonitoringState copyWith(
      {final MonitoringStatus? status,
      final Map<String, MonitoringData>? monitoringData,
      final EnergyUnit? selectedUnit,
      final CustomDate? selectedDate,
      final MonitoringError? error}) {
    return MonitoringState(
      status: status ?? this.status,
      monitoringData: monitoringData ?? this.monitoringData,
      selectedUnit: selectedUnit ?? this.selectedUnit,
      selectedDate: selectedDate ?? this.selectedDate,
      error: error ?? this.error,
    );
  }

  Map<String, dynamic> toJson() => _$MonitoringStateToJson(this);

  @override
  List<Object?> get props =>
      [status, monitoringData, selectedUnit, selectedDate, error];
}
