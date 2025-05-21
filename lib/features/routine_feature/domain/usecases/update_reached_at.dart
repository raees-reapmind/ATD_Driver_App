import 'package:atd/features/routine_feature/domain/repository/routine_repository.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../data/models/routine.dart';


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