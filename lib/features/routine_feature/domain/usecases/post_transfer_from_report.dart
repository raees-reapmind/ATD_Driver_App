import 'package:atd/features/routine_feature/domain/repository/routine_repository.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../data/models/routine.dart';


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