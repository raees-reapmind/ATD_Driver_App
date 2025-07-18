import 'package:atd/features/routine_feature/domain/repository/routine_repository.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';

class StoreVehicleEndLocation {
  final RoutineRepository repository;

  StoreVehicleEndLocation({required this.repository});

  Future<Either<Failure, String?>?> call({
    required int vehicleId,
    required int driverId,
    required double lat,
    required double long,
    required String address,
    required String reachedAt, // Format: "yyyy-MM-dd HH:mm:ss"
    required String date, // Format: "yyyy-MM-dd"
    required String apiToken,
  }) async {
    return await repository.storeVehicleLocationEnd(
      reachedAt: reachedAt,
      date: date,
      apiToken: apiToken,
      vehicleId: vehicleId,
      driverId: driverId,
      lat: lat,
      long: long,
      address: address,
    );
  }
}
