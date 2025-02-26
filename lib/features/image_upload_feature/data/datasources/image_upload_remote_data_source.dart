import 'dart:io';
import 'package:atd/core/errors/exceptions.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../utils/constants.dart';

abstract class ImageUploadRemoteDataSource {
  Future<int>? postImage({required String imagePath, required String apiToken});
}

class ImageUploadRemoteDataSourceImpl implements ImageUploadRemoteDataSource {
  final Dio dio;

  ImageUploadRemoteDataSourceImpl({required this.dio});

  @override
  Future<int>? postImage(
      {required String imagePath, required String apiToken}) async {
    dio.options.headers[HttpHeaders.contentTypeHeader] = 'application/json';
    dio.options.headers[HttpHeaders.authorizationHeader] = 'Bearer $apiToken';
    dio.options.headers['Accept'] = 'application/json';

    final imageForm = FormData.fromMap({
      'media': await MultipartFile.fromFile(imagePath),
    });

    debugPrint('[api-test] postImage URL: $postImageUploadUrl');
    debugPrint('[api-test] postImage Headers: ${dio.options.headers}');
    debugPrint('[api-test] postImage  Request Data: ${imageForm.fields}');
    debugPrint('[api-test] postImage  Request Data 1: ${imageForm.files}');
    debugPrint('[api-test] postImage  Request Data 2: ${imageForm.boundary}');

    final response = await dio.post(
      postImageUploadUrl,
      data: imageForm,
      options: Options(validateStatus: (status) => true),
    );

    debugPrint('[api-test] postImage Response Data: ${response.data}');

    if (response.statusCode == 200) {
      final responseMap = Map<String, dynamic>.from(response.data);
      int id = int.parse(responseMap['result']['id']);
      debugPrint('image id : $id');
      return id;
    } else {
      throw ServerException();
    }
  }
}
