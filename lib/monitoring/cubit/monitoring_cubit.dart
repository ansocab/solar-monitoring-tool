import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

import 'package:solar_energy_monitoring_tool/monitoring/cubit/monitoring_state.dart';
import 'package:solar_energy_monitoring_tool/monitoring/models/monitoring.dart';
import 'package:solar_energy_monitoring_tool/monitoring/repository/monitoring_api_client.dart';
import 'package:solar_energy_monitoring_tool/monitoring/repository/monitoring_repository.dart';

//TODO: add data polling on state init

class MonitoringCubit extends HydratedCubit<MonitoringState> {
  MonitoringCubit(this._monitoringRepository) : super(MonitoringState());

  final MonitoringRepository _monitoringRepository;

  Future<void> fetchMonitoringData(
      {required CustomDate date, bool? shouldRefresh}) async {
    final isDataPresentForDate = state.monitoringData?[date.stringKey] != null;
    final isToday = DateUtils.isSameDay(date.value, DateTime.now());

    if (shouldRefresh != true && isDataPresentForDate && !isToday) {
      emit(state.copyWith(selectedDate: date));
      return;
    }

    emit(state.copyWith(status: MonitoringStatus.loading));

    try {
      final newMonitoringData =
          await _monitoringRepository.getMonitoringData(date: date);

      var updatedMonitoringData = {date.stringKey: newMonitoringData};

      if (state.monitoringData != null) {
        updatedMonitoringData =
            Map<String, MonitoringData>.from(state.monitoringData!)
              ..[date.stringKey] = newMonitoringData;
      }

      emit(state.copyWith(
          status: MonitoringStatus.success,
          monitoringData: updatedMonitoringData,
          selectedDate: date));
    } catch (error) {
      emit(state.copyWith(
          status: MonitoringStatus.failure, error: getError(error)));
    }
  }

  Future<void> clearMonitoringData() async {
    emit(state.copyWith(status: MonitoringStatus.loading));

    try {
      final newMonitoringData = await _monitoringRepository.getMonitoringData(
          date: state.selectedDate);

      emit(state.copyWith(
          status: MonitoringStatus.success,
          monitoringData: {state.selectedDate.stringKey: newMonitoringData}));
    } on Exception {
      emit(state.copyWith(status: MonitoringStatus.failure));
    }
  }

  void selectUnit(EnergyUnit unit) {
    emit(state.copyWith(selectedUnit: unit));
  }

  @override
  MonitoringState fromJson(Map<String, dynamic> json) =>
      MonitoringState.fromJson(json);

  @override
  Map<String, dynamic> toJson(MonitoringState state) => state.toJson();
}

MonitoringError getError(error) {
  switch (error) {
    case SocketException _:
      return MonitoringError.networkError;
    case NoDataAvailableFailure _:
      return MonitoringError.emptyResponse;
    default:
      return MonitoringError.generic;
  }
}
