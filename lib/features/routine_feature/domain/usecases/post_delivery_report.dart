import 'package:atd/features/routine_feature/domain/repository/routine_repository.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../data/models/routine.dart';

class PostDeliveryReport {
  final RoutineRepository repository;

  PostDeliveryReport({required this.repository});

  Future<Either<Failure, String?>?> call({
    required Routine routine,
    required String apiToken,
  }) async {
    return await repository.postDeliveryReport(
        routine: routine, apiToken: apiToken);
  }
}
class PostTransferReport {
  final RoutineRepository repository;

  PostTransferReport({required this.repository});

  Future<Either<Failure, String?>?> call({
    required Routine routine,
    required String apiToken,
  }) async {
    return await repository.postTransferReport(
        routine: routine, apiToken: apiToken);
  }
}
class PostTransferFromReport {
  final RoutineRepository repository;

  PostTransferFromReport({required this.repository});

  Future<Either<Failure, String?>?> call({
    required Routine routine,
    required String apiToken,
  }) async {
    return await repository.postTransferFromReport(
        routine: routine, apiToken: apiToken);
  }
}
class UpdateReacheadAt {
  final RoutineRepository repository;

  UpdateReacheadAt({required this.repository});

  Future<Either<Failure, String?>?> call({
    required Routine routine,
    required String apiToken,
  }) async {
    return await repository.updateReacheadAt(
        routine: routine, apiToken: apiToken);
  }
}
