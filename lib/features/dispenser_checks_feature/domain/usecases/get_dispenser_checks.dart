import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../data/models/dispenser_check.dart';
import '../repository/dispenser_check_repository.dart';

class GetDispenserChecks {
  final DispenserCheckRepository repository;

  GetDispenserChecks({required this.repository});

  Future<Either<Failure, List<DispenserCheck>?>?> call(
      {required String apiToken}) async {
    return await repository.getDispenserChecks(apiToken: apiToken);
  }
}
