import 'package:atd/core/errors/failures.dart';
import 'package:atd/features/image_upload_feature/data/datasources/image_upload_remote_data_source.dart';
import 'package:atd/features/image_upload_feature/domain/repository/image_upload_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/connection/network_info.dart';
import '../../../../core/errors/exceptions.dart';

class ImageRepositoryImpl implements ImageRepository {
  final ImageUploadRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  ImageRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, int?>>? postImage(
      {required String imagePath, required String apiToken}) async {
    if (await networkInfo.isConnected!) {
      try {
        final result = await remoteDataSource.postImage(
          imagePath: imagePath,
          apiToken: apiToken,
        );
        return Right(result);
      } on ServerException catch (errorMessage) {
        return Left(ServerFailure(errorMessage: errorMessage.toString()));
      }
    } else {
      return Left(
          NetworkConnectionFailure(errorMessage: "No internet connection"));
    }
  }
}
