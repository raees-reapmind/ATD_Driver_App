import 'package:atd/core/connection/network_info.dart';
import 'package:atd/core/errors/failures.dart';
import 'package:atd/features/image_upload_feature/data/datasources/image_upload_remote_data_source.dart';
import 'package:atd/features/image_upload_feature/data/repository/image_upload_repository_impl.dart';
import 'package:data_connection_checker_tv/data_connection_checker.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class ImageUploadProvider extends ChangeNotifier {
  int? imageId;
  Failure? failure;

  Future<int?> eitherFailureOrUploadImage(
      {required String imagePath, required String apiToken}) async {
    final repository = ImageRepositoryImpl(
        remoteDataSource: ImageUploadRemoteDataSourceImpl(dio: Dio()),
        networkInfo:
            NetworkInfoImpl(connectionChecker: DataConnectionChecker()));
    final response =
        await repository.postImage(imagePath: imagePath, apiToken: apiToken);
    response?.fold((newFailure) {
      failure = newFailure;
      imageId = null;
      notifyListeners();
    }, (data) {
      failure = null;
      imageId = data;
      notifyListeners();
    });
    return imageId;
  }
}
