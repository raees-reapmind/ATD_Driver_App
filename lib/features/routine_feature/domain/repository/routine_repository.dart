import 'package:atd/features/login_feature/data/models/user_details.dart';
import 'package:atd/features/routine_feature/data/models/du_response_data.dart';
import 'package:atd/features/routine_feature/data/models/routine_details.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../data/models/additonal_charge.dart';
import '../../data/models/routine.dart';

abstract class RoutineRepository {
  Future<Either<Failure, RoutineDetails?>>? getRoutines(
      {required String apiToken});

  Future<Either<Failure, List<AdditionCharge>?>>? getBill({
    required String apiToken,
    required Routine routine,
  });

  Future<Either<Failure, bool?>>? setRoutines({
    required RoutineDetails routines,
  });

  Future<Either<Failure, String?>>? postStartRoutine({
    required Routine routine,
    required String apiToken,
  });
  Future<Either<Failure, List<DuResponseData>?>>? getDuStatusResponse();

  Future<Either<Failure, String?>>? postRefillReport(
      {required Routine routine, required String apiToken});

  Future<Either<Failure, String?>>? postEndRoutine(
      {required Routine routine, required String apiToken});
 
   Future<Either<Failure, String?>>? storeVehicleLocationEnd({
    required int vehicleId,
    required int driverId,
    required double lat,
    required double long,
    required String address,
    required String reachedAt, // Format: "yyyy-MM-dd HH:mm:ss"
    required String date, // Format: "yyyy-MM-dd"
    required String apiToken,
  });

  Future<Either<Failure, String?>>? postDeliveryReport(
      {required Routine routine, required String apiToken});

  Future<Either<Failure, String?>>? postTransferReport(
      {required Routine routine, required String apiToken});

  Future<Either<Failure, String?>>? postTransferFromReport(
      {required Routine routine, required String apiToken});

  Future<Either<Failure, String?>>? updateReacheadAt(
      {required Routine routine, required String apiToken});
}
