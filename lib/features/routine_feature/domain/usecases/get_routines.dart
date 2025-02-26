import 'package:atd/features/routine_feature/data/models/routine_details.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repository/routine_repository.dart';

class GetRoutines {
  final RoutineRepository repository;

  GetRoutines({required this.repository});

  Future<Either<Failure, RoutineDetails?>?> call(
      {required String apiToken}) async {
    return await repository.getRoutines(apiToken: apiToken);
  }
}
