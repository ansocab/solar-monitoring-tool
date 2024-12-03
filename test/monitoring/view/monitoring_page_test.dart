// TODO: write the following tests:
// navigates to SettingsPage when settings icon is tapped
// renders MonitoringLoading for MonitoringStatus.loading
// renders MonitoringErrorView for MonitoringStatus.failure
// triggers fetchMonitoringData on pull to refresh

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:solar_energy_monitoring_tool/monitoring/cubit/monitoring_cubit.dart';
import 'package:solar_energy_monitoring_tool/monitoring/cubit/monitoring_state.dart';
import 'package:solar_energy_monitoring_tool/monitoring/models/monitoring.dart';
import 'package:solar_energy_monitoring_tool/monitoring/view/monitoring_page.dart';

import '../../helpers/hydrated_bloc.dart';
import '../../helpers/mock_data.dart';

class MockMonitoringCubit extends MockCubit<MonitoringState>
    implements MonitoringCubit {}

void main() {
  initHydratedStorage();

  group('MonitoringPage', () {
    late MonitoringCubit monitoringCubit;
    final mockData = MockData();
    final date = CustomDate(value: DateTime(2024, 11, 26));

    setUp(() {
      monitoringCubit = MockMonitoringCubit();
    });

    testWidgets('BottomNavigationBar updates selected tab', (tester) async {
      when(() => monitoringCubit.state).thenReturn(MonitoringState(
          status: MonitoringStatus.success,
          monitoringData: {date.stringKey: mockData.mockMonitoringData},
          selectedDate: date));
      await tester.pumpWidget(BlocProvider.value(
          value: monitoringCubit,
          child: const MaterialApp(home: MonitoringPage())));

      expect(find.text('Solar Generation'), findsOneWidget);
      expect(find.text('House Consumption'), findsNothing);
      expect(find.text('Battery Consumption'), findsNothing);

      await tester.tap(find.text('Heatpump'));
      await tester.pump();

      expect(find.text('Solar Generation'), findsNothing);
      expect(find.text('House Consumption'), findsOneWidget);
      expect(find.text('Battery Consumption'), findsNothing);

      await tester.tap(find.text('Wallbox'));
      await tester.pump();

      expect(find.text('Solar Generation'), findsNothing);
      expect(find.text('House Consumption'), findsNothing);
      expect(find.text('Battery Consumption'), findsOneWidget);

      await tester.tap(find.text('Solar'));
      await tester.pump();

      expect(find.text('Solar Generation'), findsOneWidget);
      expect(find.text('House Consumption'), findsNothing);
      expect(find.text('Battery Consumption'), findsNothing);
    });
  });
}
