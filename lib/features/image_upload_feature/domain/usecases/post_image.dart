import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repository/image_upload_repository.dart';

class PostImage {
  final ImageRepository repository;

  PostImage({required this.repository});

  Future<Either<Failure, int?>?> call({
    required String imagePath,
    required String apiToken,
  }) async {
    return await repository.postImage(imagePath: imagePath, apiToken: apiToken);
  }
}
