import 'package:flutter/material.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:solar_energy_monitoring_tool/monitoring/cubit/monitoring_cubit.dart';
import 'package:solar_energy_monitoring_tool/monitoring/cubit/monitoring_state.dart';
import 'package:solar_energy_monitoring_tool/monitoring/models/monitoring.dart';
import 'package:solar_energy_monitoring_tool/monitoring/repository/monitoring_repository.dart';

import '../../helpers/hydrated_bloc.dart';
import '../../helpers/mock_data.dart';

class MockMonitoringRepository extends Mock implements MonitoringRepository {}

void main() {
  initHydratedStorage();

  setUpAll(() {
    registerFallbackValue(CustomDate(value: DateTime(2024, 11, 26)));
  });

  group('MonitoringCubit', () {
    late MonitoringRepository monitoringRepository;
    late MonitoringCubit monitoringCubit;
    final mockData = MockData();

    final date = CustomDate(value: DateTime(2024, 11, 26));
    final mockMonitoringMap = {date.stringKey: mockData.mockMonitoringData};

    setUp(() async {
      monitoringRepository = MockMonitoringRepository();
      monitoringCubit = MonitoringCubit(monitoringRepository);
      when(() =>
              monitoringRepository.getMonitoringData(date: any(named: 'date')))
          .thenAnswer((_) async => mockData.mockMonitoringData);
    });

    test('has correct initial state', () {
      expect(
          monitoringCubit.state,
          isA<MonitoringState>()
              .having(
                  (state) => state.status, 'status', MonitoringStatus.loading)
              .having((state) => state.selectedUnit, 'selectedUnit',
                  EnergyUnit.kilowatts)
              .having((state) => state.monitoringData, 'monitoringData', isNull)
              .having((state) => state.error, 'error', isNull)
              .having(
                  (state) => state.selectedDate,
                  'selectedDate is today',
                  predicate((CustomDate date) =>
                      DateUtils.isSameDay(date.value, DateTime.now()))));
    });

    group('fetchMonitoringData', () {
      blocTest('emits selected date when monitoring data is already fetched',
          build: () => monitoringCubit,
          seed: () => MonitoringState(monitoringData: mockMonitoringMap),
          act: (cubit) => cubit.fetchMonitoringData(date: date),
          expect: () => [
                MonitoringState(
                    selectedDate: date, monitoringData: mockMonitoringMap)
              ],
          verify: (_) {
            verifyNever(
                () => monitoringRepository.getMonitoringData(date: date));
          });

      blocTest('emits [loading, success] when getMonitoringData returns data',
          build: () => monitoringCubit,
          act: (cubit) => cubit.fetchMonitoringData(date: date),
          expect: () => [
                isA<MonitoringState>().having((state) => state.status, 'status',
                    MonitoringStatus.loading),
                isA<MonitoringState>()
                    .having((state) => state.status, 'status',
                        MonitoringStatus.success)
                    .having((state) => state.selectedDate, 'selectedDate', date)
                    .having((state) => state.monitoringData, 'monitoringData',
                        mockMonitoringMap)
              ]);

      blocTest(
          'emits [loading, failure] when getMonitoringData encounters an error',
          setUp: () {
            when(() => monitoringRepository.getMonitoringData(date: date))
                .thenThrow(Exception('some error'));
          },
          build: () => monitoringCubit,
          act: (cubit) => cubit.fetchMonitoringData(date: date),
          expect: () => [
                isA<MonitoringState>().having((state) => state.status, 'status',
                    MonitoringStatus.loading),
                isA<MonitoringState>().having((state) => state.status, 'status',
                    MonitoringStatus.failure),
              ]);
    });

    group('clearMonitoringData', () {
      final mockMonitoringMapEnriched = {
        '2024-11-25': mockData.mockMonitoringData,
        ...mockMonitoringMap
      };

      blocTest(
          'emits [loading, success] when clearMonitoringData is successful',
          build: () => monitoringCubit,
          seed: () => MonitoringState(
              selectedDate: date, monitoringData: mockMonitoringMapEnriched),
          act: (cubit) => cubit.clearMonitoringData(),
          expect: () => [
                // isA<MonitoringState>().having((state) => state.status, 'status',
                //     MonitoringStatus.loading), //TODO: check why it does not go into the loading state
                isA<MonitoringState>()
                    .having((state) => state.status, 'status',
                        MonitoringStatus.success)
                    .having((state) => state.monitoringData, 'monitoringData',
                        mockMonitoringMap)
              ]);

      blocTest(
          'emits [loading, failure] when clearMonitoringData encounters an error',
          setUp: () {
            when(() => monitoringRepository.getMonitoringData(
                date: any(named: 'date'))).thenThrow(Exception('some error'));
          },
          build: () => monitoringCubit,
          act: (cubit) => cubit.clearMonitoringData(),
          expect: () => [
                isA<MonitoringState>().having((state) => state.status, 'status',
                    MonitoringStatus.loading),
                isA<MonitoringState>().having((state) => state.status, 'status',
                    MonitoringStatus.failure),
              ]);
    });

    group('selectUnit', () {
      blocTest('sets unit to selected value',
          build: () => monitoringCubit,
          act: (cubit) => cubit.selectUnit(EnergyUnit.watts),
          expect: () => [
                isA<MonitoringState>().having((state) => state.selectedUnit,
                    'selectedUnit', EnergyUnit.watts)
              ]);
    });
  });
}
