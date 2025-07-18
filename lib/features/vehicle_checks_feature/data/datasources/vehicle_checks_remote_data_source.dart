import 'dart:io';
import 'package:atd/features/vehicle_checks_feature/domain/entities/vehicle_check.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../utils/constants.dart';
import 'package:atd/utils/helper.dart';



abstract class VehicleChecksRemoteDataSource {
  Future<List<VehicleCheck>>? getVehicleChecks({required String apiToken});

  Future<String>? setVehicleChecks(
      {required List<VehicleCheck> vehicleChecks, required String apiToken});
}

class VehicleChecksRemoteDataSourceImpl
    implements VehicleChecksRemoteDataSource {
  final Dio dio;

  VehicleChecksRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<VehicleCheck>>? getVehicleChecks(
      {required String apiToken}) async {
    dio.options.headers[HttpHeaders.contentTypeHeader] = 'application/json';
    dio.options.headers[HttpHeaders.authorizationHeader] = 'Bearer $apiToken';
    dio.options.headers['Accept'] = 'application/json';
    final response = await dio.get(
      getVehicleChecksUrl,
      options: Options(validateStatus: (status) => true),
    );
    debugPrint('[cache-test] getVehicleChecks token $apiToken');
    debugPrint('[cache-test] getVehicleChecks response ${response.data}');
    if (response.statusCode == 200) {
      final responseMap = Map<String, dynamic>.from(response.data);
      // if (responseMap['results'] != null) {
      List<VehicleCheck> data = responseMap['results'].map<VehicleCheck>((e) {
        return VehicleCheck.fromMap(e);
      }).toList();
      return data;
      // } else {
      //   debugPrint(responseMap['error'].toString());
      // }
    } else {
      throw ServerException();
    }
  }

// Future<String?> getPlanId() async {
//   try {
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? planId = prefs.getString('planId'); // Fetch and store the value
//     print('[api-test] getPlanId planId: $planId');
//     return planId; // Return the fetched ID
//   } catch (e) {
//     print('[api-test] SharedPreferences error: $e');
//     return null; // Return null in case of an error
//   }
// }

  @override
  Future<String>? setVehicleChecks(
      {required List<VehicleCheck> vehicleChecks,
      required String apiToken}) async {
        
    dio.options.headers[HttpHeaders.contentTypeHeader] = 'application/json';
    dio.options.headers[HttpHeaders.authorizationHeader] = 'Bearer $apiToken';
    String? planId = await getPlanId();

    debugPrint('[cache-test] setVehicleChecks URL: $postVehicleChecksUrl');

    debugPrint('[cache-test] setVehicleChecks request : ${
      {
        "route_plan_id" : planId,
        "checks": vehicleChecks.map((e) => e.toMap()).toList(),
      }
    }');      

    var response = await dio.post(
      postVehicleChecksUrl,
      data: {
        "route_plan_id" : planId,
        "checks": vehicleChecks.map((e) => e.toMap()).toList(),
      },
      options: Options(validateStatus: (status) => true),
    );
    if (response.statusCode == 200) {
      return response.data['message'];
    } else {
      throw ServerException();
    }
  }
}
