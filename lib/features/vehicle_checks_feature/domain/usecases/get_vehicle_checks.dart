import 'package:atd/features/vehicle_checks_feature/domain/entities/vehicle_check.dart';
import 'package:atd/features/vehicle_checks_feature/domain/repository/vehicle_check_repository.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';

class GetVehicleChecks {
  final VehicleChecksRepository repository;

  GetVehicleChecks({required this.repository});

  Future<Either<Failure, List<VehicleCheck>?>?> call(
      {required String apiToken}) async {
    return await repository.getVehicleChecks(apiToken: apiToken);
  }
}
