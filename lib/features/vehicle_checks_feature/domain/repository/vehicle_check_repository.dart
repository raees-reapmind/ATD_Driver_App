import 'package:atd/features/vehicle_checks_feature/domain/entities/vehicle_check.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';

abstract class VehicleChecksRepository {
  Future<Either<Failure, List<VehicleCheck>?>>? getVehicleChecks(
      {required String apiToken});

  Future<Either<Failure, String?>>? setVehicleChecks({
    required List<VehicleCheck>? vehicleChecks,
    required String apiToken,
  });
}
