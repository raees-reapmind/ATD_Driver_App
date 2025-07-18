import 'package:atd/core/connection/network_info.dart';
import 'package:atd/core/errors/failures.dart';
import 'package:atd/features/vehicle_readings_feature/data/datasources/vehicle_details_remote_data_source.dart';
import 'package:atd/features/vehicle_readings_feature/data/models/vehicle_details.dart';
import 'package:atd/features/vehicle_readings_feature/domain/repository/vehicle_details_repository.dart';
import 'package:atd/utils/helper.dart';
import 'package:data_connection_checker_tv/data_connection_checker.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../data/repository/vehicle_details_repository_impl.dart';

class VehicleReadingsProvider extends ChangeNotifier {
  VehicleReadings? vehicleReadings;
  Failure? failure;
  String? message;

  VehicleReadingsProvider({this.vehicleReadings,this.failure,this.message});
  void notifyDataChanged() {
    notifyListeners();
  }

  Future<bool> eitherFailureOrPostVehicleDetails({
    required String apiToken,
  }) async {
    VehicleDetailsRepository repository = VehicleDetailsRepositoryImpl(
      networkInfo: NetworkInfoImpl(connectionChecker: DataConnectionChecker()),
      remoteDataSource: VehicleDetailsRemoteDataSourceImpl(dio: Dio()),
    );
    bool isSuccess = false;
    final result = await repository.postVehicleDetails(
        apiToken: apiToken, vehicleReadings: vehicleReadings!);
        debugPrint('[api-test] eitherFailureOrPostVehicleDetails result $result');
    result?.fold((newFailure) {
      failure = newFailure;
      notifyListeners();
      isSuccess = false;
    }, (data) {
      failure = null;
      message = data;
      notifyListeners();
      isSuccess = true;
      //  updateUserStep(2);
       debugPrint('updateUserStep: $updateUserStep');
    });
    return isSuccess;
  }

  Future<bool> eitherFailureOrGetVehicleDetails({
    required String apiToken,
  }) async {
    VehicleDetailsRepository repository = VehicleDetailsRepositoryImpl(
      networkInfo: NetworkInfoImpl(connectionChecker: DataConnectionChecker()),
      remoteDataSource: VehicleDetailsRemoteDataSourceImpl(dio: Dio()),
    );
    bool isSuccess = true;
    final result = await repository.getVehicleDetails(apiToken: apiToken);
        debugPrint('[api-test] eitherFailureOrGetVehicleDetails result $result');

    result?.fold((newFailure) {
      failure = newFailure;
      isSuccess = false;
      debugPrint('faliure');
      notifyListeners();
    }, (data) {
      failure = null;
      vehicleReadings = data;
      debugPrint('data : ${data.toString()}');
      isSuccess = true;
      notifyListeners();
    });
    return isSuccess;
  }

}
