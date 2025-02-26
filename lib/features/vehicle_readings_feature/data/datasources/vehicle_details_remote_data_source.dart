import 'dart:io';
import 'package:atd/features/vehicle_readings_feature/data/models/vehicle_details.dart';
import 'package:atd/utils/constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import '../../../../core/errors/exceptions.dart';

abstract class VehicleDetailsRemoteDataSource {
  Future<String>? postVehicleDetails({required VehicleReadings vehicleReadings, required String apiToken});
  Future<VehicleReadings?>? getVehicleDetails({required String apiToken});
}

class VehicleDetailsRemoteDataSourceImpl implements VehicleDetailsRemoteDataSource {
  final Dio dio;

  VehicleDetailsRemoteDataSourceImpl({required this.dio});

  @override
  Future<VehicleReadings?>? getVehicleDetails(
      {required String apiToken}) async {
    dio.options.headers[HttpHeaders.contentTypeHeader] = 'application/json';
    dio.options.headers[HttpHeaders.authorizationHeader] = 'Bearer $apiToken';
    dio.options.headers['Accept'] = 'application/json';

    final response = await dio.get(
      postVehicleDetailsUrl,
    );

    final responseMap = Map<String, dynamic>.from(response.data);
    debugPrint(responseMap.toString());

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(responseMap['results'])
          .map((e) => VehicleReadings.fromMap(e))
          .toList()
          .last;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<String>? postVehicleDetails(
      {required VehicleReadings vehicleReadings,
      required String apiToken}) async {
    dio.options.headers[HttpHeaders.contentTypeHeader] = 'application/json';
    dio.options.headers[HttpHeaders.authorizationHeader] = 'Bearer $apiToken';
    dio.options.headers['Accept'] = 'application/json';

    debugPrint('[api-test] POST VEHICLE DETAILS : ${vehicleReadings.toMap()}');
    debugPrint('[api-test] postVehicleDetails referenceId before API call: ${vehicleReadings.referenceId}');
    debugPrint('[api-test] postVehicleDetails URL: $postVehicleDetailsUrl');
    debugPrint('[api-test] postVehicleDetails Headers: ${dio.options.headers}');
  
    final response = await dio.post(
      postVehicleDetailsUrl,
      data: vehicleReadings.toMap(),
    );
    
    final responseMap = Map<String, dynamic>.from(response.data);
    
    debugPrint('[api-test] postVehicleDetails Body: ${responseMap}');
    debugPrint('[api-test] postVehicleDetails Body-2: ${responseMap.toString()}');

    if (response.statusCode == 200) {
      return responseMap['message'];
    } else {
      throw ServerException();
    }
  }
}
