import 'dart:io';
import 'package:atd/features/routine_feature/data/models/additonal_charge.dart';
import 'package:atd/features/routine_feature/data/models/du_response_data.dart';
import 'package:atd/features/routine_feature/data/models/routine_details.dart';
import 'package:atd/features/vehicle_readings_feature/data/models/vehicle_details.dart';
import 'package:atd/features/vehicle_readings_feature/display/providers/vehicle_details_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../utils/constants.dart';
import '../models/routine.dart';
import 'package:atd/utils/helper.dart';
import 'dart:developer';

abstract class RoutineRemoteDataSource {
  Future<bool>? setRoutines({required RoutineDetails? routines});
  Future<String>? postStartRoutine(
      {required Routine routine, required String apiToken});
  Future<String>? postEndRoutine(
      {required Routine routine, required String apiToken});
  Future<String>? postRefillReport(
      {required Routine routine, required String apiToken});
  Future<String>? postDeliveryReport(
      {required Routine routine, required String apiToken});

  Future<RoutineDetails?>? getRoutines({required String apiToken});
  Future<List<AdditionCharge>>? getBill(
      {required String apiToken, required Routine routine});
  Future<List<DuResponseData>>? getDuStatusResponse();

  Future<String>? postTransferReport(
      {required Routine routine, required String apiToken});

  Future<String>? postTransferFromReport(
      {required Routine routine, required String apiToken});

  Future<String>? updateReacheadAt(
      {required Routine routine, required String apiToken});
}

class RoutineRemoteDataSourceImpl implements RoutineRemoteDataSource {
  final Dio dio;
  VehicleReadingsProvider? vehicleReadingsProvider;

  RoutineRemoteDataSourceImpl({required this.dio,this.vehicleReadingsProvider});

  // Future<void> savePlanId(String planId) async {
  //   try {
  //     final SharedPreferences prefs = await SharedPreferences.getInstance();
  //     await prefs.setString('planId', planId.toString());
  //     print('[api-test] Saved planId: $planId');
  //   } catch (e) {
  //     print('[api-test] SharedPreferences error: $e');
  //   }
  // }

  @override
  Future<RoutineDetails>? getRoutines({required String apiToken}) async {
    dio.options.headers[HttpHeaders.contentTypeHeader] = ContentType.json;
    dio.options.headers[HttpHeaders.authorizationHeader] = 'Bearer $apiToken';
    dio.options.headers['Accept'] = ContentType.json;
    
    final response = await dio.get(
      getRoutinesUrl,
      options: Options(validateStatus: (status) => true),
    );

    print('[api-test] getRoutines apiToken ${apiToken}');
    print('[api-test] getRoutines URL: $getRoutinesUrl');
    print('[api-test] getRoutines Headers: ${dio.options.headers}');

    final responseMap = Map<String, dynamic>.from(response.data);

    log('[api-test] getRoutines response ${responseMap.toString()}');

    if (response.statusCode == 200) {
      debugPrint(responseMap.toString());
      if (responseMap['result'] != null) {
        final result = RoutineDetails.fromMap(responseMap['result']);
        var plan = responseMap['result']['plan']['id'];
        print('[api-test] plan: $plan');

        savePlanId(plan.toString());
      
        debugPrint(result.toString());
        return result;
      } else {
        throw ServerException(
            message:
                '[${response.statusCode}] ${responseMap['message'].toString()}');
      }
    } else {
      throw ServerException(
          message:
              '[${response.statusCode}] ${responseMap['message'].toString()}');
    }
  }

  @override
  Future<bool>? setRoutines({required RoutineDetails? routines}) async {
    final response = await dio.put(
      "http://www.atd.com/api/setDispenserReports",
      queryParameters: {
        "apiKey": "If needed",
      },
      data: null,
    );
    if (response.statusCode == 200) {
      return Future.value(true);
    } else {
      final responseMap = Map<String, dynamic>.from(response.data);
      throw ServerException(
          message:
              '[${response.statusCode}] ${responseMap['message'].toString()}');
    }
  }

  @override
  Future<String>? postStartRoutine(
      {required Routine routine, required String apiToken}) async {
    dio.options.headers[HttpHeaders.contentTypeHeader] = 'application/json';
    dio.options.headers[HttpHeaders.authorizationHeader] = 'Bearer $apiToken';
    dio.options.headers['Accept'] = 'application/json';
       
    print('[api-test] postStartRoutine URL: $postStartRoutineUrl');
    print('[api-test] postStartRoutine postStartRoutine Headers: ${dio.options.headers}');
    print('[api-test] postStartRoutine Payload: ${routine.toStartTripMap()}'); 
    print('[api-test] postStartRoutine options: ${Options(validateStatus: (status) => true)}'); // Assuming `Routine` has a `toJson()` method

    final response = await dio.post(
      postStartRoutineUrl,
      options: Options(validateStatus: (status) => true),
      data: routine.toStartTripMap(),
    );

    final responseMap = Map<String, dynamic>.from(response.data);

    print('[api-test] Data: ${response.data}');

    debugPrint(responseMap.toString());

    if (response.statusCode == 200) {
      debugPrint(responseMap.toString());

      return responseMap['message'];
    } else {
      throw ServerException(
          message:
              '[${response.statusCode}] ${responseMap['message'].toString()}');
    }
  }

  @override
  Future<String>? postDeliveryReport(
      {required Routine routine, required String apiToken}) async {
    debugPrint(routine.toDeliveryMap().toString());
    String date = routine.toDeliveryMap()['arrived_date_time'];
    debugPrint(date);
    dio.options.headers[HttpHeaders.contentTypeHeader] = 'application/json';
    dio.options.headers[HttpHeaders.authorizationHeader] = 'Bearer $apiToken';
    dio.options.headers['Accept'] = 'application/json';

    
    print('[api-test] postDeliveryReport apiToken ${apiToken}');
    print('[api-test] postDeliveryReport URL: $postDeliveryReportUrl');
    print('[api-test] postDeliveryReport Headers: ${dio.options.headers}');
    print('[api-test] postDeliveryReport request: ${routine.toDeliveryMap()}');

    final response = await dio.post(
      postDeliveryReportUrl,
      options: Options(
        validateStatus: (status) => true,
      ), 
      data: routine.toDeliveryMap(),
    );

    final responseMap = Map<String, dynamic>.from(response.data);

    debugPrint(responseMap.toString());
    debugPrint(response.statusCode.toString());

    if (response.statusCode == 200) {
      debugPrint(responseMap.toString());
      return responseMap['message'];
    } else {
      throw ServerException(
          message: '[${response.statusCode}] ${responseMap['message'].toString()}');
    }
  }

  @override
  Future<String>? postTransferReport(
      {required Routine routine, required String apiToken}) async {
    debugPrint(routine.toTransferMap().toString());
    String date = routine.toTransferMap()['arrived_date_time'];
    debugPrint(date);
    dio.options.headers[HttpHeaders.contentTypeHeader] = 'application/json';
    dio.options.headers[HttpHeaders.authorizationHeader] = 'Bearer $apiToken';
    dio.options.headers['Accept'] = 'application/json';

    
    print('[api-test] postTransferReport apiToken ${apiToken}');
    print('[api-test] postTransferReport URL: $postTransferReportUrl');
    print('[api-test] postTransferReport Headers: ${dio.options.headers}');
    // print('[api-test] postTransferReport request: ${routine.toDeliveryMap()}');
    print('[api-test] postTransferReport request: ${routine.toTransferMap()}');

    final response = await dio.post(
      postTransferReportUrl
      // 'xxx'
      ,
      options: Options(
        validateStatus: (status) => true,
      ),
      data: routine.toTransferMap(),
    );

    final responseMap = Map<String, dynamic>.from(response.data);

    debugPrint(responseMap.toString());
    debugPrint(response.statusCode.toString());

    if (response.statusCode == 200) {
      debugPrint(responseMap.toString());
      return responseMap['message'];
    } else {
      throw ServerException(
          message:
              '[${response.statusCode}] ${responseMap['message'].toString()}');
    }
  }


   @override
  Future<String>? postTransferFromReport(
      {required Routine routine, required String apiToken}) async {
    debugPrint(routine.toTransferMap().toString());
    String date = routine.toTransferMap()['arrived_date_time'];
    debugPrint(date);
    dio.options.headers[HttpHeaders.contentTypeHeader] = 'application/json';
    dio.options.headers[HttpHeaders.authorizationHeader] = 'Bearer $apiToken';
    dio.options.headers['Accept'] = 'application/json';
    
    print('[api-test] postTransferFromReport apiToken ${apiToken}');
    print('[api-test] postTransferFromReport URL: $postTransferFromReportUrl');
    print('[api-test] postTransferFromReport request: ${routine.toTransferMap()}');

    final response = await dio.post(
      postTransferFromReportUrl,
      options: Options(
        validateStatus: (status) => true,
      ),
      data: routine.toTransferMap(),
    );

    final responseMap = Map<String, dynamic>.from(response.data);

    debugPrint(responseMap.toString());
    debugPrint(response.statusCode.toString());

    if (response.statusCode == 200) {
      debugPrint(responseMap.toString());
      return responseMap['message'];
    } else {
      throw ServerException(
          message:
              '[${response.statusCode}] ${responseMap['message'].toString()}');
    }
  }

  @override
  Future<String>? postEndRoutine(
      {required Routine routine, required String apiToken}) async {
    dio.options.headers[HttpHeaders.contentTypeHeader] = 'application/json';
    dio.options.headers[HttpHeaders.authorizationHeader] = 'Bearer $apiToken';
    dio.options.headers['Accept'] = 'application/json';
    
    final response = await dio.post(
      postEndRoutineUrl,
      options: Options(validateStatus: (status) => true),
      data: routine.toEndTripMap(),
      
    );

      debugPrint('[api-test] postEndRoutine rurl : ${postEndRoutineUrl}');
      debugPrint('[api-test] postEndRoutine request ${routine.toEndTripMap()}');

      final responseMap = Map<String, dynamic>.from(response.data);

      debugPrint('[api-test] postEndRoutine responseMap: ${responseMap}');

    debugPrint(responseMap.toString());

    if (response.statusCode == 200) {
      debugPrint(responseMap.toString());

      return responseMap['message'];
    } else {
      throw ServerException(
          message:
              '[${response.statusCode}] ${responseMap['message'].toString()}');
    }
  }

 @override
  Future<String>? storeVehicleEndLocation(
      {required Routine routine, required String apiToken}) async {
    dio.options.headers[HttpHeaders.contentTypeHeader] = 'application/json';
    dio.options.headers[HttpHeaders.authorizationHeader] = 'Bearer $apiToken';
    dio.options.headers['Accept'] = 'application/json';
    
    final response = await dio.post(
      postEndRoutineUrl,
      options: Options(validateStatus: (status) => true),
      data: routine.toEndTripMap(),
      
    );

      debugPrint('[api-test] postEndRoutine rurl : ${postEndRoutineUrl}');
      debugPrint('[api-test] postEndRoutine request ${routine.toEndTripMap()}');

      final responseMap = Map<String, dynamic>.from(response.data);

      debugPrint('[api-test] postEndRoutine responseMap: ${responseMap}');

    debugPrint(responseMap.toString());

    if (response.statusCode == 200) {
      debugPrint(responseMap.toString());

      return responseMap['message'];
    } else {
      throw ServerException(
          message:
              '[${response.statusCode}] ${responseMap['message'].toString()}');
    }
  }



  @override
  Future<String>? postRefillReport(
      {required Routine routine, required String apiToken}) async {
    debugPrint(routine.toRefillMap().toString());
    dio.options.headers[HttpHeaders.contentTypeHeader] = 'application/json';
    dio.options.headers[HttpHeaders.authorizationHeader] = 'Bearer $apiToken';
    dio.options.headers['Accept'] = 'application/json';
    final response = await dio.post(
      postRefillReportUrl,
      options: Options(validateStatus: (status) => true),
      data: routine.toRefillMap(),
    );

    print('[api-test] postRefillReport url : ${postRefillReportUrl}');
    print('[api-test] postRefillReport requsst : ${routine.toRefillMap()}');

    final responseMap = Map<String, dynamic>.from(response.data);

    debugPrint('[api-test] postRefillReport response ${responseMap}');

    if (response.statusCode == 200) {
      debugPrint(responseMap.toString());
      return responseMap['message'];
    } else {
      throw ServerException(
          message:
              '[${response.statusCode}] ${responseMap['message'].toString()}');
    }
  }

  @override
  Future<List<AdditionCharge>>? getBill(
      {required String apiToken, required Routine routine}) async {
    dio.options.headers[HttpHeaders.contentTypeHeader] = ContentType.json;
    dio.options.headers[HttpHeaders.authorizationHeader] = 'Bearer $apiToken';
    dio.options.headers['Accept'] = ContentType.json;

    print('[api-test] getBill URL: $getBillUrl');
    print('[api-test] getBill postStartRoutine Headers: ${dio.options.headers}');
    print('[api-test] getBill Payload: ${ routine.toBillMap()}');

    final response = await dio.get(
      getBillUrl,
      queryParameters: routine.toBillMap(),
      options: Options(validateStatus: (status) => true),
    );
    
    print('[api-test] getBill response 1 : ${response}');
    print('[api-test] getBill response 2: ${response.toString()}');

    if (response.statusCode == 200) {
      final responseMap = List<Map<String, dynamic>>.from(response.data);
      final List<AdditionCharge> additionalChargesList =
          List<Map<String, dynamic>>.from(responseMap)
              .map((e) => AdditionCharge.fromMap(e))
              .toList();
      return additionalChargesList;
    } else {
      final responseMap = Map<String, dynamic>.from(response.data);
      throw ServerException(
          message:
              '[${response.statusCode}] ${responseMap['message'].toString()}');
    }
  }

  @override
  Future<List<DuResponseData>>? getDuStatusResponse() async {
    dio.options.headers[HttpHeaders.contentTypeHeader] = 'application/json';
    dio.options.headers['Accept'] = 'application/json';
    final response = await dio.get(
      getduStatus,
      queryParameters: {'flag': 1},
      options: Options(validateStatus: (status) => true),
    );

    debugPrint('DU status response : ${response.toString()}');
    if (response.statusCode == 200) {
      final responseMap = List<Map<String, dynamic>>.from(response.data);
      final List<DuResponseData> duStatus =
          List<Map<String, dynamic>>.from(responseMap)
              .map((e) => DuResponseData.fromJson(e))
              .toList();

      return duStatus;
    } else {
      final responseMap = Map<String, dynamic>.from(response.data);
      throw ServerException(
          message:
              '[${response.statusCode}] ${responseMap['message'].toString()}');
    }
  }


  
   @override
  Future<String>? updateReacheadAt(
      {required Routine routine, required String apiToken}) async {
    debugPrint(routine.toDeliveryMap().toString());
    String date = routine.toDeliveryMap()['arrived_date_time'];
    debugPrint(date);
    dio.options.headers[HttpHeaders.contentTypeHeader] = 'application/json';
    dio.options.headers[HttpHeaders.authorizationHeader] = 'Bearer $apiToken';
    dio.options.headers['Accept'] = 'application/json';

    
    print('[api-test] updateReacheadAt apiToken ${apiToken}');
    print('[api-test] updateReacheadAt URL: $postTransferFromReportUrl');
    print('[api-test] updateReacheadAt request: ${ routine.toUpdateReachedMap()}');

    final response = await dio.post(
      updateReachedAt,
      options: Options(
        validateStatus: (status) => true,
      ),
      data: routine.toUpdateReachedMap(),
    );

    final responseMap = Map<String, dynamic>.from(response.data);

    debugPrint(responseMap.toString());
    debugPrint(response.statusCode.toString());

    if (response.statusCode == 200) {
      debugPrint(responseMap.toString());
      return responseMap['message'];
    } else {
      throw ServerException(
          message:
              '[${response.statusCode}] ${responseMap['message'].toString()}');
    }
  }
}
