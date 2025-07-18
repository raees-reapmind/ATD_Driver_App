import 'dart:convert';
import 'dart:io'; 
import 'package:dio/dio.dart'; 
import 'package:flutter/material.dart'; 
import '../../../../core/errors/exceptions.dart';
import '../../../../utils/constants.dart';
import '../models/user_details.dart';


abstract class LoginRemoteDataSource {
  Future<String>? getOtp({required UserDetails userDetails});

  Future<UserDetails>? putOtp({required UserDetails userDetails});
}

class LoginRemoteDataSourceImpl implements LoginRemoteDataSource {
  final Dio dio;

  const LoginRemoteDataSourceImpl({required this.dio});

  @override
  Future<String>? getOtp({required UserDetails userDetails}) async {
    dio.options.headers[HttpHeaders.contentTypeHeader] = 'application/json';
    dio.options.headers['Accept'] = 'application/json';

    final response = await dio.post(
      getOtpUrl,
      data: json.encode(userDetails.toMap()),
    );
      debugPrint('[api-test] getOtpUrl url : ${json.encode(userDetails.toMap())}');
      debugPrint('[api-test] getOtpUrl request: ${json.encode(userDetails.toMap())}');
    
    if (response.statusCode == 200) {
      debugPrint(response.data.toString());
      return response.data.toString();
    } else {
      throw ServerException();
    }
  }

  // @override
  // Future<UserDetails>? putOtp({required UserDetails userDetails}) async {
  //   dio.options.headers[HttpHeaders.contentTypeHeader] =
  //       Headers.formUrlEncodedContentType;
  //   dio.options.headers['Accept'] = 'application/json';
  //   final response = await dio.put(
  //     putOtpUrl,
  //     data: userDetails.toMap(),
  //     options: Options(
  //       followRedirects: false,
  //     ),
  //   );
    
  //     debugPrint('[api-test] putOtpUrl url: putOtpUrl');
  //     debugPrint('[api-test] putOtpUrl request: ${userDetails.toMap()}');
  //     debugPrint('[api-test] putOtpUrl response: ${response.data}');

  //   if (response.statusCode == 200 || response.statusCode == 422) {
  //     Map<String, dynamic> map = (response.data);
  //     debugPrint(map.toString());
  //     final result = map['result'];
  //     String apiToken = result['token'];
  //     return UserDetails(
  //       phoneNo: userDetails.phoneNo,
  //       vehicleRegNo: userDetails.vehicleRegNo,
  //       dateTime: DateTime.now(),
  //       apiToken: apiToken,
  //       otp: userDetails.otp,
  //     );
  //   } else {
  //     throw ServerException();
  //   }
  // }



  @override
  Future<UserDetails>? putOtp({required UserDetails userDetails}) async {
    dio.options.headers[HttpHeaders.contentTypeHeader] =
        Headers.formUrlEncodedContentType;
    dio.options.headers['Accept'] = 'application/json';

    final response = await dio.put(
      putOtpUrl,
      data: userDetails.toMap(),
      options: Options(
        followRedirects: false,
      ),
    );
    
      debugPrint('[api-test] putOtpUrl url: $putOtpUrl');
      debugPrint('[api-test] putOtpUrl request: ${userDetails.toMap()}');
      debugPrint('[api-test] putOtpUrl response: ${response.data}');

    if (response.statusCode == 200 || response.statusCode == 422) {
      Map<String, dynamic> map = (response.data);
      debugPrint(map.toString());

      final result = map['result'];
      String apiToken = result['token'];
      final step = map['step']; // e.g., '1'
      final userId = map['user_id']; // e.g., '1'
      final vehicleId = map['vehicle_id']; // e.g., '1'

      return UserDetails(
        phoneNo: userDetails.phoneNo,
        vehicleRegNo: userDetails.vehicleRegNo,
        dateTime: DateTime.now(),
        apiToken: apiToken,
        otp: userDetails.otp,
        step: step,
        userId: userId,
        vehicleId: vehicleId,
      );
    } else {
      throw ServerException();
    }
  }

}