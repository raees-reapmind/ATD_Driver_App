import 'package:atd/features/routine_feature/data/models/additonal_charge.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../data/models/routine.dart';
import '../repository/routine_repository.dart';

class GetBill {
  final RoutineRepository repository;

  GetBill({required this.repository});

  Future<Either<Failure, List<AdditionCharge>?>?> call(
      {required String apiToken, required Routine routine}) async {
    return await repository.getBill(apiToken: apiToken, routine: routine);
  }
}
