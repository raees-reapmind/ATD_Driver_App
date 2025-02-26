import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';

abstract class ImageRepository {
  Future<Either<Failure, int?>>? postImage(
      {required String imagePath, required String apiToken});
}
