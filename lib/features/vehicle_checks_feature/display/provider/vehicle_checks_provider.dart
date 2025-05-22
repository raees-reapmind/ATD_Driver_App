import 'package:atd/core/errors/failures.dart';
import 'package:atd/features/vehicle_checks_feature/data/datasources/vehicle_checks_local_data_source.dart';
import 'package:atd/features/vehicle_checks_feature/data/datasources/vehicle_checks_remote_data_source.dart';
import 'package:atd/features/vehicle_checks_feature/data/repository/vehicle_checks_repository_impl.dart';
import 'package:atd/features/vehicle_checks_feature/domain/entities/vehicle_check.dart';
import 'package:atd/features/vehicle_checks_feature/domain/usecases/get_vehicle_checks.dart';
import 'package:atd/features/vehicle_checks_feature/domain/usecases/set_vehicle_checks.dart';
import 'package:data_connection_checker_tv/data_connection_checker.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../../core/connection/network_info.dart';

class VehicleChecksProvider extends ChangeNotifier {
  List<VehicleCheck>? vehicleCheckList;
  Failure? failure;
  String? message;

  void setStatus({required int index, required int status}) {
    VehicleCheck vehicleCheck = VehicleCheck(
        name: vehicleCheckList![index].name,
        status: status,
        id: vehicleCheckList![index].id);
    vehicleCheckList![index] = vehicleCheck;
    notifyListeners();
  }

void clearVehicleChecks() {
  if (vehicleCheckList != null) {
    for (var check in vehicleCheckList!) {
      check.status = 0; // ✅ Reset only status, keep data
    }
    notifyListeners(); // ✅ Ensure UI updates
  }
}




  void notifyDataChanged(){
    notifyListeners();
  }

  Future<void> eitherFailureOrGetVehicleChecks({required String apiToken}) async {
    VehicleChecksRepositoryImpl repository = VehicleChecksRepositoryImpl(
      remoteDataSource: VehicleChecksRemoteDataSourceImpl(dio: Dio()),
      localDataSource: VehicleChecksLocalDataSourceImpl(vehicleChecksBox: Hive.box('vehicle_checks_box_key'),pendingChecksSyncBox: Hive.box('pending_vehicle_checks_box')),
      networkInfo: NetworkInfoImpl(connectionChecker: DataConnectionChecker()),
    );
    final failureOrVehicleChecks =
        await GetVehicleChecks(repository: repository).call(apiToken: apiToken);
    failureOrVehicleChecks?.fold((newFailure) {
      vehicleCheckList = null;
      failure = newFailure;
      debugPrint(newFailure.errorMessage.toString());
      notifyListeners();
    }, (data) {
      if (data != null) {
        vehicleCheckList = data;
        failure = null;
        debugPrint('[api-test] vehicleCheckList ${vehicleCheckList.toString()}');
        notifyListeners();
      }
    });
  }

  // Future<bool> eitherFailureOrSetVehicleChecks(
  //     {required String apiToken}) async {
  //   VehicleChecksRepositoryImpl repository = VehicleChecksRepositoryImpl(
  //     remoteDataSource: VehicleChecksRemoteDataSourceImpl(dio: Dio()),
  //     localDataSource: VehicleChecksLocalDataSourceImpl(vehicleChecksBox: Hive.box('vehicle_checks_box_key')),
  //     networkInfo: NetworkInfoImpl(connectionChecker: DataConnectionChecker()),
  //   );
  //   bool isSuccess = false;
  //   final result = await SetVehicleChecks(repository: repository).call(vehicleChecks: vehicleCheckList, apiToken: apiToken);
  //   result?.fold((newFailure) {
  //     message = newFailure.errorMessage;
  //     failure = newFailure;
  //     notifyListeners();
  //     isSuccess = false;
  //   }, (data) {
      
  //     failure = null;
  //     message = data;
  //     notifyListeners();
  //     isSuccess = true;
  //   });
  //   return isSuccess;
  // }

  Future<bool> eitherFailureOrSetVehicleChecks({required String apiToken}) async {
  VehicleChecksRepositoryImpl repository = VehicleChecksRepositoryImpl(
    remoteDataSource: VehicleChecksRemoteDataSourceImpl(dio: Dio()),
    localDataSource: VehicleChecksLocalDataSourceImpl(
      vehicleChecksBox: Hive.box('vehicle_checks_box_key'),
      pendingChecksSyncBox: Hive.box('pending_vehicle_checks_box'),
    ),
    networkInfo: NetworkInfoImpl(connectionChecker: DataConnectionChecker()),
  );

  bool isSuccess = false;

  final isConnected = await repository.networkInfo.isConnected;

  if (isConnected ==  true) {
    final result = await SetVehicleChecks(repository: repository)
        .call(vehicleChecks: vehicleCheckList, apiToken: apiToken);
    result?.fold((newFailure) {
      failure = newFailure;
      message = newFailure.errorMessage;
      notifyListeners();
      isSuccess = false;
    }, (data) {
      failure = null;
      message = data;
      notifyListeners();
      isSuccess = true;
    });
  } else {
    await repository.localDataSource.savePendingVehicleChecks(vehicleCheckList ?? []);
    failure = null;
    message = 'Saved locally. Will sync when online.';
    notifyListeners();
    isSuccess = true;
  }

  return isSuccess;
}

}
