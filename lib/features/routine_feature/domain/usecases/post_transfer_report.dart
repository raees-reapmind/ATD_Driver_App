import 'package:atd/features/routine_feature/domain/repository/routine_repository.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../data/models/routine.dart';


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