import 'dart:io';
import 'package:atd/features/routine_feature/data/models/additonal_charge.dart';
import 'package:atd/features/routine_feature/data/models/du_response_data.dart';
import 'package:atd/features/routine_feature/data/models/routine_details.dart';
import 'package:atd/features/vehicle_readings_feature/display/providers/vehicle_details_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
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
 
  Future<String>? storeVehicleLocationEnd({
    required int vehicleId,
    required int driverId,
    required double lat,
    required double long,
    required String address,
    required String reachedAt, // Format: "yyyy-MM-dd HH:mm:ss"
    required String date, // Format: "yyyy-MM-dd"
    required String apiToken,
  });

  Future<String>? updateReacheadAt(
      {required Routine routine, required String apiToken});
}

class RoutineRemoteDataSourceImpl implements RoutineRemoteDataSource {
  final Dio dio;
  VehicleReadingsProvider? vehicleReadingsProvider;

  RoutineRemoteDataSourceImpl(
      {required this.dio, this.vehicleReadingsProvider});

  @override
  Future<RoutineDetails>? getRoutines({required String apiToken}) async {
    dio.options.headers[HttpHeaders.contentTypeHeader] = ContentType.json;
    dio.options.headers[HttpHeaders.authorizationHeader] = 'Bearer $apiToken';
    dio.options.headers['Accept'] = ContentType.json;

    final response = await dio.get(
      getRoutinesUrl,
      options: Options(validateStatus: (status) => true),
    );

    debugPrint('[api-test] getRoutines apiToken $apiToken');
    debugPrint('[api-test] getRoutines URL: $getRoutinesUrl');
    debugPrint('[api-test] getRoutines Headers: ${dio.options.headers}');

    final responseMap = Map<String, dynamic>.from(response.data);

    log('[api-test] getRoutines response ${responseMap.toString()}');

    if (response.statusCode == 200) {
      debugPrint(responseMap.toString());
      if (responseMap['result'] != null) {
        final result = RoutineDetails.fromMap(responseMap['result']);
        var plan = responseMap['result']['plan']['id'];
        debugPrint('[api-test] plan: $plan');

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

    debugPrint('[api-test] postStartRoutine URL: $postStartRoutineUrl');
    debugPrint(
        '[api-test] postStartRoutine postStartRoutine Headers: ${dio.options.headers}');
    debugPrint('[api-test] postStartRoutine Payload: ${routine.toStartTripMap()}');
    debugPrint(
        '[api-test] postStartRoutine options: ${Options(validateStatus: (status) => true)}'); // Assuming `Routine` has a `toJson()` method

    final response = await dio.post(
      postStartRoutineUrl,
      options: Options(validateStatus: (status) => true),
      data: routine.toStartTripMap(),
    );

    final responseMap = Map<String, dynamic>.from(response.data);

    debugPrint('[api-test] Data: ${response.data}');

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

    log('[api-test] postDeliveryReport apiToken $apiToken');
    log('[api-test] postDeliveryReport URL: $postDeliveryReportUrl');
    log('[api-test] postDeliveryReport Headers: ${dio.options.headers}');
    log('[api-test] postDeliveryReport request: ${routine.toDeliveryMap()}');

    final response = await dio.post(
      postDeliveryReportUrl,
      options: Options(
        validateStatus: (status) => true,
      ),
      data: routine.toDeliveryMap(),
    );

    log('[api-test] postDeliveryReport response: ${response.data}'); 

    final responseMap = Map<String, dynamic>.from(response.data); 

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
  Future<String>? postTransferReport(
      {required Routine routine, required String apiToken}) async {
    debugPrint(routine.toTransferMap().toString());
    String date = routine.toTransferMap()['arrived_date_time'];
    debugPrint(date);
    dio.options.headers[HttpHeaders.contentTypeHeader] = 'application/json';
    dio.options.headers[HttpHeaders.authorizationHeader] = 'Bearer $apiToken';
    dio.options.headers['Accept'] = 'application/json';

    debugPrint('[api-test] postTransferReport apiToken $apiToken');
    debugPrint('[api-test] postTransferReport URL: $postTransferReportUrl');
    debugPrint('[api-test] postTransferReport Headers: ${dio.options.headers}');
    // debugPrint('[api-test] postTransferReport request: ${routine.toDeliveryMap()}');
    debugPrint('[api-test] postTransferReport request: ${routine.toTransferMap()}');

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

    debugPrint('[api-test] postTransferFromReport apiToken $apiToken');
    debugPrint('[api-test] postTransferFromReport URL: $postTransferFromReportUrl');
    debugPrint(
        '[api-test] postTransferFromReport request: ${routine.toTransferMap()}');

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

    debugPrint('[api-test] postEndRoutine rurl : $postEndRoutineUrl');
    debugPrint('[api-test] postEndRoutine request ${routine.toEndTripMap()}');

    final responseMap = Map<String, dynamic>.from(response.data);

    debugPrint('[api-test] postEndRoutine responseMap: $responseMap');

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
  Future<String>? storeVehicleLocationEnd({
    required int vehicleId,
    required int driverId,
    required double lat,
    required double long,
    required String address,
    required String reachedAt, // Format: "yyyy-MM-dd HH:mm:ss"
    required String date, // Format: "yyyy-MM-dd"
    required String apiToken,
  }) async {
    dio.options.headers[HttpHeaders.contentTypeHeader] = 'application/json';
    dio.options.headers[HttpHeaders.authorizationHeader] = 'Bearer $apiToken';
    dio.options.headers['Accept'] = 'application/json';

    final requestData = {
      'vehicle_id': vehicleId,
      'driver_id': driverId,
      'lat': lat,
      'long': long,
      'address': address,
      'reatch_at': reachedAt,
      'date': date,
    };

    debugPrint('[api-test] storeVehicleLocationEnd request: $requestData');

    final response = await dio.post(
      storeVehicleEndLocation,
      data: requestData,
      options: Options(validateStatus: (status) => true),
    );

    final responseMap = Map<String, dynamic>.from(response.data);

    debugPrint('[api-test] storeVehicleLocationEnd responseMap: $responseMap');

    debugPrint(responseMap.toString());

   if (response.statusCode != null && response.statusCode! >= 200 && response.statusCode! < 300) {
    return responseMap['message'];
    }
  else {
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

    debugPrint('[api-test] postRefillReport url : $postRefillReportUrl');
    debugPrint('[api-test] postRefillReport requsst : ${routine.toRefillMap()}');

    final responseMap = Map<String, dynamic>.from(response.data);

    debugPrint('[api-test] postRefillReport response $responseMap');

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

    debugPrint('[api-test] getBill URL: $getBillUrl');
    debugPrint(
        '[api-test] getBill postStartRoutine Headers: ${dio.options.headers}');
    debugPrint('[api-test] getBill Payload: ${routine.toBillMap()}');

    final response = await dio.get(
      getBillUrl,
      queryParameters: routine.toBillMap(),
      options: Options(validateStatus: (status) => true),
    );

    debugPrint('[api-test] getBill response 1 : $response');
    debugPrint('[api-test] getBill response 2: ${response.toString()}');

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

    debugPrint('[api-test] updateReacheadAt apiToken $apiToken');
    debugPrint('[api-test] updateReacheadAt URL: $postTransferFromReportUrl');
    debugPrint('[api-test] updateReacheadAt request: ${routine.toUpdateReachedMap()}');

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
