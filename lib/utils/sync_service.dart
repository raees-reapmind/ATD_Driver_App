import 'package:dio/dio.dart';
import 'package:atd/core/connection/network_info.dart';
import 'package:data_connection_checker_tv/data_connection_checker.dart';
import 'package:hive/hive.dart';

import '../features/vehicle_checks_feature/data/datasources/vehicle_checks_local_data_source.dart';
import '../features/vehicle_checks_feature/data/datasources/vehicle_checks_remote_data_source.dart';
import '../features/vehicle_checks_feature/data/repository/vehicle_checks_repository_impl.dart';
import '../features/vehicle_checks_feature/domain/usecases/set_vehicle_checks.dart';
import '../features/vehicle_readings_feature/data/datasources/vehicle_details_remote_data_source.dart';
import '../features/vehicle_readings_feature/data/models/vehicle_details.dart';
import '../features/vehicle_readings_feature/data/repository/vehicle_details_repository_impl.dart'; 

Future<void> syncPendingVehicleChecks(String apiToken) async {
  final repository = VehicleChecksRepositoryImpl(
    remoteDataSource: VehicleChecksRemoteDataSourceImpl(dio: Dio()),
    localDataSource: VehicleChecksLocalDataSourceImpl(
      vehicleChecksBox: Hive.box('vehicle_checks_box_key'),
      pendingChecksSyncBox: Hive.box('pending_vehicle_checks_box')
    ),
    networkInfo: NetworkInfoImpl(connectionChecker: DataConnectionChecker()),
  );
  
final isConnected = await repository.networkInfo.isConnected;
if (isConnected == null || !isConnected) return;


  final pending = await repository.localDataSource.getPendingVehicleChecks();

  for (final entry in pending.entries) {
    final id = entry.key;
    final checks = entry.value;

    final result = await SetVehicleChecks(repository: repository)
        .call(vehicleChecks: checks, apiToken: apiToken);

    result?.fold(
      (_) {}, // optional: show error message or retry logic
      (_) async {
        await repository.localDataSource.removePendingChecks(id);
      },
    );
  }
}



Future<void> syncPendingVehicleReadings(String apiToken) async {
  final repository = VehicleDetailsRepositoryImpl(
    remoteDataSource: VehicleDetailsRemoteDataSourceImpl(dio: Dio()),
    networkInfo: NetworkInfoImpl(connectionChecker: DataConnectionChecker()),
  );

  final isConnected = await repository.networkInfo.isConnected;
  if (isConnected == null || !isConnected) return;

  final box = Hive.box('offline_vehicle_readings');
  final pending = <int, VehicleReadings>{};

  for (int i = 0; i < box.length; i++) {
    final reading = box.getAt(i);
    if (reading != null) {
      pending[i] = reading;
    }
  }

  for (final entry in pending.entries) {
    final key = entry.key;
    final vehicleReading = entry.value;

    final result = await repository.postVehicleDetails(
      apiToken: apiToken,
      vehicleReadings: vehicleReading,
    );

    result?.fold(
      (failure) {
        // Optionally handle failure: retry, log, etc.
      },
      (success) async {
        await box.deleteAt(key);
      },
    );
  }
}

