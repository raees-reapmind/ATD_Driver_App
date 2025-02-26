import 'package:atd/core/errors/exceptions.dart';
import 'package:atd/features/vehicle_checks_feature/domain/entities/vehicle_check.dart';
import 'package:hive/hive.dart';

abstract class VehicleChecksLocalDataSource {
  Future<void>? setVehicleChecks({required List<VehicleCheck>? vehicleChecks});

  Future<List<VehicleCheck>>? getVehicleChecks();
}

const vehicleChecksKey = "local_vehicle_checks_key";

class VehicleChecksLocalDataSourceImpl implements VehicleChecksLocalDataSource {
  final Box vehicleChecksBox;

  VehicleChecksLocalDataSourceImpl({required this.vehicleChecksBox});

  @override
  Future<List<VehicleCheck>>? getVehicleChecks() async {
    final Future<List<VehicleCheck>>? result = vehicleChecksBox.get(vehicleChecksKey);
    if (result != null) {
      return Future.value(result);
    } else {
      throw DatabaseException();
    }
  }

  @override
  Future<void>? setVehicleChecks(
      {required List<VehicleCheck>? vehicleChecks}) {
    if (vehicleChecks != null) {
      return vehicleChecksBox.put(vehicleChecksKey, vehicleChecks);
    } else {
      throw DatabaseException();
    }
  }
}
