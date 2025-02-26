import 'package:atd/features/vehicle_readings_feature/data/models/vehicle_details.dart';
import 'package:atd/features/vehicle_readings_feature/domain/repository/vehicle_details_repository.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';

class PostVehicleDetails {
  final VehicleDetailsRepository repository;

  PostVehicleDetails({required this.repository});

  Future<Either<Failure, String?>?> call({
    required VehicleReadings vehicleReadings,
    required String apiToken,
  }) async {
    return await repository.postVehicleDetails(
        vehicleReadings: vehicleReadings, apiToken: apiToken);
  }
}
