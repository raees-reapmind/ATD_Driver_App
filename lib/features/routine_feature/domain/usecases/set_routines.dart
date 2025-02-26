import 'package:atd/features/routine_feature/data/models/routine_details.dart';
import 'package:atd/features/routine_feature/domain/repository/routine_repository.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';

class SetRoutines {
  final RoutineRepository repository;

  SetRoutines({required this.repository});

  Future<Either<Failure, bool?>?> call(
      {required RoutineDetails routines}) async {
    return await repository.setRoutines(routines: routines);
  }
}
