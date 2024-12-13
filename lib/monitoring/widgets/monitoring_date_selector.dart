import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:solar_energy_monitoring_tool/monitoring/cubit/monitoring_cubit.dart';
import 'package:solar_energy_monitoring_tool/monitoring/models/monitoring.dart';

class MonitoringDateSelector extends StatefulWidget {
  const MonitoringDateSelector({super.key});

  @override
  State<MonitoringDateSelector> createState() => _MonitoringDateSelectorState();
}

class _MonitoringDateSelectorState extends State<MonitoringDateSelector> {
  final ValueNotifier<DateTime> _selectedDate =
      ValueNotifier<DateTime>(DateTime.now());

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: _selectedDate,
        builder: (context, value, ch) => InkWell(
          onTap: selectDate,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                    DateFormat('yyyy-MM-dd').format(value),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
            ],
          ),
        ));
  }

 void selectDate() {
    showDatePicker(
        context: context,
        initialDate: context.read<MonitoringCubit>().state.selectedDate.value,
        firstDate: DateTime(2000),
        lastDate: DateTime.now(),
        builder: (context, child) {
          return Theme(
              data: Theme.of(context).copyWith(
                  textTheme: TextTheme(
                      titleLarge: Theme.of(context).textTheme.titleMedium)),
              child: child!);
        }).then((pickedDate) {
      if (pickedDate != null) {
        updateSelectedDate(pickedDate);
      }
    });
  }

  void updateSelectedDate(DateTime date) {
    _selectedDate.value = date;
    context
        .read<MonitoringCubit>()
        .fetchMonitoringData(date: CustomDate(value: date));
  }
}
