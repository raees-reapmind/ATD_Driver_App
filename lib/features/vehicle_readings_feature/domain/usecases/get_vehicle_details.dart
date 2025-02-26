import 'package:atd/features/vehicle_readings_feature/data/models/vehicle_details.dart';
import 'package:atd/features/vehicle_readings_feature/domain/repository/vehicle_details_repository.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';

class GetVehicleDetails {
  final VehicleDetailsRepository repository;

  GetVehicleDetails({required this.repository});

  Future<Either<Failure, VehicleReadings?>?> call({
    required VehicleReadings vehicleReadings,
    required String apiToken,
  }) async {
    return await repository.getVehicleDetails(apiToken: apiToken);
  }
}
