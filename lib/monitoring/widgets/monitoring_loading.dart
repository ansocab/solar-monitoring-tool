import 'package:flutter/material.dart';

class MonitoringLoading extends StatelessWidget {
  const MonitoringLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 48),
        Padding(
          padding: EdgeInsets.all(16),
          child: CircularProgressIndicator(),
        ),
        Text('Loading energy data...'),
      ],
    );
  }
}
