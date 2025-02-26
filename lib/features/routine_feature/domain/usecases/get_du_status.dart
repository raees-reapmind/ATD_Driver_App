import 'package:atd/core/errors/failures.dart';
import 'package:atd/features/routine_feature/data/models/du_response_data.dart';
import 'package:atd/features/routine_feature/domain/repository/routine_repository.dart';
import 'package:dartz/dartz.dart';

class GetDuStatusResponse{
 final RoutineRepository repository;

  GetDuStatusResponse({required this.repository});

  Future<Either<Failure, List<DuResponseData>?>?> call() async {
    return await repository.getDuStatusResponse();
  }
}