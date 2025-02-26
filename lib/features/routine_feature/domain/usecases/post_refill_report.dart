import 'package:atd/features/routine_feature/domain/repository/routine_repository.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../data/models/routine.dart';

class PostRefillReport {
  final RoutineRepository repository;

  PostRefillReport({required this.repository});

  Future<Either<Failure, String?>?> call({
    required Routine routine,
    required String apiToken,
  }) async {
    return await repository.postRefillReport(
        routine: routine, apiToken: apiToken);
  }
}
