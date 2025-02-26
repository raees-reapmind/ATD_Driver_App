import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../data/models/dispenser_check.dart';

abstract class DispenserCheckRepository {
  Future<Either<Failure, List<DispenserCheck>?>>? getDispenserChecks(
      {required String apiToken});

  Future<Either<Failure, String?>>? setDispenserChecks({
    required List<DispenserCheck> dispenserChecks,
    required String apiToken,
  });
}
