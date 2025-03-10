import 'dart:io';

import 'package:atd/core/errors/failures.dart';
import 'package:atd/features/location_feature/data/datasources/location_local_data_source.dart';
import 'package:atd/features/location_feature/data/datasources/location_remote_data_source.dart';
import 'package:atd/features/location_feature/data/repository/location_repository_impl.dart';
import 'package:atd/features/location_feature/domain/entities/location.dart';
import 'package:atd/features/routine_feature/data/models/vehicle_details.dart';
import 'package:atd/features/routine_feature/display/providers/routines_provider.dart';
import 'package:data_connection_checker_tv/data_connection_checker.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../../core/connection/network_info.dart';
import 'package:atd/utils/constants.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:convert';

import '../../../../core/errors/exceptions.dart';



class LocationProvider extends ChangeNotifier {
  Location? _location;
  Failure? _failure;

  Location? get location => _location;
  List<Location> locationList = [];

  Failure? get failure => _failure;

  void add({required Location location}){
    locationList.add(location);
    notifyListeners();
  }

  void eitherFailureOrSetLocation({required Location location}) async {
    LocationRepositoryImpl repository = LocationRepositoryImpl(
      remoteDataSource: LocationRemoteDataSourceImpl(dio: Dio()),
      localDataSource: LocationLocalDataSourceImpl(
          locationBox: Hive.box('location_box_key')),
      networkInfo: NetworkInfoImpl(connectionChecker: DataConnectionChecker()),
    );
    final result = await repository.setLocation(locationList: locationList);
    result?.fold((newFailure) {
      _failure = newFailure;
      notifyListeners();
    }, (data) {
      if (data != null) {
        if (data == true) {
          _failure = null;
          locationList = [];
        } else {
          _failure = null;
        }
      }
    });
  }



Future<String> sendLocationToServer({required String apiToken,required RoutinesProvider routineProvider}) async {
  Position position = await _determinePosition();
  final Dio dio = Dio();

  // VehicleDetails? vehicleDetails = VehicleManager().vehicleDetails;
  // debugPrint('[loc-test] vehicleDetails id: ${vehicleDetails?.id}');



  dio.options.headers[HttpHeaders.contentTypeHeader] = 'application/json';
  dio.options.headers[HttpHeaders.authorizationHeader] = 'Bearer $apiToken';
  dio.options.headers['Accept'] = 'application/json';

  Map<String, dynamic> data = {
    "latitude": position.latitude,
    "longitude": position.longitude,
  };
  debugPrint("[loc-test] Sending Location: $data");
  debugPrint("[loc-test] Sending Location URL : ${'$mainUrl/api/app/v2/vehicles/${routineProvider.vehicleDetails?.id}/locations'}");

  var response = await dio.post(
    '$mainUrl/api/app/v2/vehicles/${routineProvider.vehicleDetails?.id}/locations',
    options: Options(validateStatus: (status) => true),
    data: jsonEncode(data),
  );

  final responseMap = response.data;
  debugPrint(responseMap.toString());

  if (response.statusCode != null && response.statusCode! >= 200 && response.statusCode! < 300) {
    return responseMap['message'] ?? "Success";
  }
  throw ServerException();
}


  /// Gets the current location
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        throw Exception('Location permissions are permanently denied.');
      }
    }

    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

}


class VehicleManager {
  static final VehicleManager _instance = VehicleManager._internal();
  factory VehicleManager() => _instance;
  VehicleManager._internal();

  VehicleDetails? vehicleDetails;
}
