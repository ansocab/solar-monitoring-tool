import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:solar_energy_monitoring_tool/app.dart';

import 'package:solar_energy_monitoring_tool/utils/bloc_logs_observer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = const BlocLogsObserver();
  HydratedBloc.storage = await HydratedStorage.build(
      storageDirectory: kIsWeb
          ? HydratedStorage.webStorageDirectory
          : await getApplicationCacheDirectory());
  runApp(const EnergyMonitoringApp());
}
