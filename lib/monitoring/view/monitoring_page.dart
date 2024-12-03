import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solar_energy_monitoring_tool/monitoring/cubit/monitoring_cubit.dart';
import 'package:solar_energy_monitoring_tool/monitoring/cubit/monitoring_state.dart';
import 'package:solar_energy_monitoring_tool/monitoring/models/monitoring.dart';
import 'package:solar_energy_monitoring_tool/monitoring/widgets/monitoring_date_selector.dart';
import 'package:solar_energy_monitoring_tool/monitoring/widgets/monitoring_error.dart';
import 'package:solar_energy_monitoring_tool/monitoring/widgets/monitoring_loading.dart';
import 'package:solar_energy_monitoring_tool/monitoring/widgets/monitoring_tab_content.dart';
import 'package:solar_energy_monitoring_tool/settings/view/settings_page.dart';

class MonitoringPage extends StatefulWidget {
  const MonitoringPage({super.key});

  @override
  State<MonitoringPage> createState() => _MonitoringPageState();
}

class _MonitoringPageState extends State<MonitoringPage> {
  int _selectedTabIndex = 0;
  List<Widget> tabOptions = [];

  void _onTabSelected(int index) {
    setState(() {
      _selectedTabIndex = index;
    });
  }

  void _openSettings() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const SettingsPage()));
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> getTabOptions() {
      final monitoringState = context.read<MonitoringCubit>().state;
      final currentMonitoringData = monitoringState
          .monitoringData![monitoringState.selectedDate.stringKey];
      return <Widget>[
        MonitoringDetails(
            metric: Metrics.solar, graphData: currentMonitoringData!.solar),
        MonitoringDetails(
            metric: Metrics.house, graphData: currentMonitoringData.house),
        MonitoringDetails(
            metric: Metrics.battery, graphData: currentMonitoringData.battery),
      ];
    }

    return DefaultTabController(
      length: 3,
      child: Scaffold(
          appBar: AppBar(
            title: const Text('Monitoring'),
            actions: [
              IconButton(
                  onPressed: _openSettings, icon: const Icon(Icons.settings))
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                  icon: Icon(Icons.wb_sunny_rounded),
                  label: 'Solar',
                  backgroundColor: Colors.green),
              BottomNavigationBarItem(
                  icon: Icon(Icons.home_rounded), label: 'Heatpump'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.battery_charging_full_rounded),
                  label: 'Wallbox')
            ],
            currentIndex: _selectedTabIndex,
            onTap: _onTabSelected,
          ),
          body: BlocBuilder<MonitoringCubit, MonitoringState>(
              builder: (context, state) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<MonitoringCubit>().fetchMonitoringData(
                    date: state.selectedDate, shouldRefresh: true);
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const MonitoringDateSelector(),
                    const SizedBox(height: 10),
                    if (state.status == MonitoringStatus.loading)
                      const MonitoringLoading()
                    else if (state.status == MonitoringStatus.success)
                      getTabOptions().elementAt(_selectedTabIndex)
                    else
                      const MonitoringErrorView()
                  ],
                ),
              ),
            );
          })),
    );
  }
}
