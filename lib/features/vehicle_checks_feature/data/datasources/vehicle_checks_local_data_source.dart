import 'package:atd/core/errors/exceptions.dart';
import 'package:atd/features/vehicle_checks_feature/domain/entities/vehicle_check.dart';
import 'package:hive/hive.dart';

abstract class VehicleChecksLocalDataSource {
  Future<void>? setVehicleChecks({required List<VehicleCheck>? vehicleChecks});

  Future<List<VehicleCheck>>? getVehicleChecks();

    Future<void> savePendingVehicleChecks(List<VehicleCheck> checks);
  Future<Map<String, List<VehicleCheck>>> getPendingVehicleChecks();
  Future<void> removePendingChecks(String id); // <-- Add this method
}

const vehicleChecksKey = "local_vehicle_checks_key";

class VehicleChecksLocalDataSourceImpl implements VehicleChecksLocalDataSource {
  final Box vehicleChecksBox;
  final Box pendingChecksSyncBox;
 

  VehicleChecksLocalDataSourceImpl({required this.vehicleChecksBox, required this.pendingChecksSyncBox});

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
  
  // for data sync
  Future<void> savePendingVehicleChecks(List<VehicleCheck> checks) async {
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final jsonList = checks.map((e) => e.toJson()).toList(); // Ensure you have toJson
    await pendingChecksSyncBox.put(id, {'checks': jsonList});
  }

  Future<Map<String, List<VehicleCheck>>> getPendingVehicleChecks() async {
    final Map<String, List<VehicleCheck>> pending = {};
    for (var key in pendingChecksSyncBox.keys) {
      final data = pendingChecksSyncBox.get(key);
      if (data != null) {
        final checks = (data['checks'] as List)
    .map((e) => VehicleCheck.fromJson(Map<String, dynamic>.from(e)))
    .toList();

        pending[key] = checks;
      }
    }
    return pending;
  }


  Future<void> removePendingChecks(String id) async {
    await pendingChecksSyncBox.delete(id);
  }
  
}



