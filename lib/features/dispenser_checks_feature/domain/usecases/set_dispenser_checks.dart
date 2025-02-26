import 'package:atd/features/dispenser_checks_feature/domain/repository/dispenser_check_repository.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../data/models/dispenser_check.dart';

class SetDispenserChecks {
  final DispenserCheckRepository repository;

  SetDispenserChecks({required this.repository});

  Future<Either<Failure, String?>?> call({
    required List<DispenserCheck> dispenserChecks,
    required String apiToken,
  }) async {
    return await repository.setDispenserChecks(
        dispenserChecks: dispenserChecks, apiToken: apiToken);
  }
}
