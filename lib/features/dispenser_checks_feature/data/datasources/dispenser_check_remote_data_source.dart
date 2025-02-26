import 'dart:io';

import 'package:atd/features/dispenser_checks_feature/data/models/dispenser_check.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../utils/constants.dart';

abstract class DispenserCheckRemoteDataSource {
  Future<List<DispenserCheck>>? getDispenserChecks({required String apiToken});

  Future<String>? setDispenserChecks({
    required List<DispenserCheck> dispenserChecks,
    required String apiToken,
  });
}

class DispenserCheckRemoteDataSourceImpl
    implements DispenserCheckRemoteDataSource {
  final Dio dio;

  DispenserCheckRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<DispenserCheck>>? getDispenserChecks(
      {required String apiToken}) async {
    final Dio dio = Dio();
    dio.options.headers[HttpHeaders.contentTypeHeader] = 'application/json';
    dio.options.headers[HttpHeaders.authorizationHeader] = 'Bearer $apiToken';
    dio.options.headers['Accept'] = 'application/json';

    var response = await dio.get(
      getDispenserChecksUrl,
      options: Options(validateStatus: (status) => true),
    );

    if (response.statusCode == 200) {
      return response.data.map((e) => DispenserCheck.fromMap(e)).fromList();
    } else {
      throw ServerException();
    }
  }


  @override
  Future<String>? setDispenserChecks({
    required List<DispenserCheck> dispenserChecks,
    required String apiToken,
  }) async {
    dio.options.headers[HttpHeaders.contentTypeHeader] = 'application/json';
    dio.options.headers[HttpHeaders.authorizationHeader] = 'Bearer $apiToken';
    dio.options.headers['Accept'] = 'application/json';
    dispenserChecks.map((e) => debugPrint(e.toMap().toString())).toList();

    debugPrint('[api-test] setDispenserChecks URL: $postDispenserChecksUrl');
    debugPrint('[api-test] setDispenserChecks Headers: ${dio.options.headers}');

    String? planId = await getPlanId(); 

    final response = await dio.post(
      postDispenserChecksUrl,
      data: {
        "route_plan_id": planId,
        "list": dispenserChecks.map((e) => e.toMap()).toList(),
      },
      options: Options(validateStatus: (status) => true),
    );

    debugPrint('[api-test] setDispenserChecks Request Data: ${
      {
        "route_plan_id": planId,
        "list": dispenserChecks.map((e) => e.toMap()).toList(),
      }
    }');
    debugPrint('[api-test] setDispenserChecks Response Data: ${response.data.toString()}');

    final responseMap = response.data;
    debugPrint(responseMap.toString());
    if (response.statusCode! >= 200 && response.statusCode! < 300) {
      return responseMap['message'];
    } else {
      throw ServerException();
    }
  }

  Future<String?> getPlanId() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? planId = prefs.getString('planId'); // Fetch and store the value
      print('[api-test] getPlanId planId: $planId');
      return planId; // Return the fetched ID
    } catch (e) {
      print('[api-test] SharedPreferences error: $e');
      return null; // Return null in case of an error
    }
  }
}
