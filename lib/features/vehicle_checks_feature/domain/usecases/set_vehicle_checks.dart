import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/vehicle_check.dart';
import '../repository/vehicle_check_repository.dart';

class SetVehicleChecks {
  final VehicleChecksRepository repository;

  SetVehicleChecks({required this.repository});

  Future<Either<Failure, String?>?> call({
    required List<VehicleCheck>? vehicleChecks,
    required String apiToken,
  }) async {
    return await repository.setVehicleChecks(vehicleChecks: vehicleChecks, apiToken: apiToken);
  }
}
