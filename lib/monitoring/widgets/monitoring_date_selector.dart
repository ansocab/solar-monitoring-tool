import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solar_energy_monitoring_tool/monitoring/cubit/monitoring_cubit.dart';
import 'package:solar_energy_monitoring_tool/monitoring/models/monitoring.dart';

class MonitoringDateSelector extends StatefulWidget {
  const MonitoringDateSelector({super.key});

  @override
  State<MonitoringDateSelector> createState() => _MonitoringDateSelectorState();
}

class _MonitoringDateSelectorState extends State<MonitoringDateSelector> {
  late TextEditingController _dateController;

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _dateController = TextEditingController(
        text: context.read<MonitoringCubit>().state.selectedDate.stringKey);

    Future<void> selectDate() async {
      DateTime? pickedDate = await showDatePicker(
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
          });

      if (pickedDate != null) {
        if (!context.mounted) return;
        await context
            .read<MonitoringCubit>()
            .fetchMonitoringData(date: CustomDate(value: pickedDate));
      }
    }

    return TextFormField(
        controller: _dateController,
        decoration: InputDecoration(
            enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade200, width: 2)),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade200, width: 2)),
            border: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade200, width: 2))),
        textAlign: TextAlign.center,
        readOnly: true,
        onTap: selectDate);
  }
}
