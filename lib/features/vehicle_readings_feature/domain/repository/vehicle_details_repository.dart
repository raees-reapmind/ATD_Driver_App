import 'package:atd/features/vehicle_readings_feature/data/models/vehicle_details.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';

abstract class VehicleDetailsRepository {
  Future<Either<Failure, VehicleReadings?>>? getVehicleDetails(
      {required String apiToken});

  Future<Either<Failure, String?>>? postVehicleDetails({
    required VehicleReadings vehicleReadings,
    required String apiToken,
  });
}
