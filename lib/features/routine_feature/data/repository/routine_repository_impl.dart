import 'package:atd/core/errors/failures.dart';
import 'package:atd/features/routine_feature/data/datasources/routine_local_data_source.dart';
import 'package:atd/features/routine_feature/data/datasources/routine_remote_data_source.dart';
import 'package:atd/features/routine_feature/data/models/additonal_charge.dart';
import 'package:atd/features/routine_feature/data/models/du_response_data.dart';
import 'package:atd/features/routine_feature/data/models/routine_details.dart';
import 'package:atd/features/routine_feature/domain/repository/routine_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import '../../../../core/connection/network_info.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/routine.dart';

class RoutineRepositoryImpl implements RoutineRepository {
  final RoutineRemoteDataSource remoteDataSource;
  final RoutineLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  RoutineRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, RoutineDetails?>>? getRoutines(
      {required String apiToken}) async {
    debugPrint('[api-test] getRoutines called---');

    if (await networkInfo.isConnected!) {
      try {
        final remoteRoutines =
            await remoteDataSource.getRoutines(apiToken: apiToken);
        return Right(remoteRoutines);
      } on ServerException catch (error) {
        return Left(ServerFailure(errorMessage: error.message.toString()));
      }
    } else {
      try {
        final localRoutines = await localDataSource.getRoutines();
        return Right(localRoutines);
      } on DatabaseException catch (errorMessage) {
        return Left(DatabaseFailure(errorMessage: errorMessage.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, bool?>>? setRoutines(
      {required RoutineDetails routines}) async {
    if (await networkInfo.isConnected!) {
      try {
        final localRoutines = await localDataSource.getRoutines();
        if (localRoutines != null) {
          final result = await remoteDataSource.setRoutines(routines: routines);
          return Right(result);
        } else {
          return Left(DatabaseFailure(errorMessage: "data is null"));
        }
      } on ServerException catch (errorMessage) {
        return Left(ServerFailure(errorMessage: errorMessage.toString()));
      }
    } else {
      return Left(
          NetworkConnectionFailure(errorMessage: "No internet connection"));
    }
  }

  @override
  Future<Either<Failure, String?>>? postStartRoutine({
    required Routine routine,
    required String apiToken,
  }) async {
    if (await networkInfo.isConnected!) {
      try {
        final result = await remoteDataSource.postStartRoutine(
          apiToken: apiToken,
          routine: routine,
        );
        return Right(result);
      } on ServerException catch (error) {
        return Left(ServerFailure(errorMessage: error.message.toString()));
      }
    } else {
      return Left(
          NetworkConnectionFailure(errorMessage: "No internet connection"));
    }
  }

  @override
  Future<Either<Failure, String?>>? postDeliveryReport(
      {required Routine routine, required String apiToken}) async {
    if (await networkInfo.isConnected!) {
      try {
        final result = await remoteDataSource.postDeliveryReport(
          apiToken: apiToken,
          routine: routine,
        );
        return Right(result);
      } on ServerException catch (error) {
        return Left(ServerFailure(errorMessage: error.message.toString()));
      }
    } else {
      return Left(
          NetworkConnectionFailure(errorMessage: "No internet connection"));
    }
  }

  @override
  Future<Either<Failure, String?>>? postTransferReport(
      {required Routine routine, required String apiToken}) async {
    if (await networkInfo.isConnected!) {
      try {
        final result = await remoteDataSource.postTransferReport(
          apiToken: apiToken,
          routine: routine,
        );
        return Right(result);
      } on ServerException catch (error) {
        return Left(ServerFailure(errorMessage: error.message.toString()));
      }
    } else {
      return Left(
          NetworkConnectionFailure(errorMessage: "No internet connection"));
    }
  }


   @override
  Future<Either<Failure, String?>>? postTransferFromReport(
      {required Routine routine, required String apiToken}) async {
    if (await networkInfo.isConnected!) {
      try {
        final result = await remoteDataSource.postTransferFromReport(
          apiToken: apiToken,
          routine: routine,
        );
        return Right(result);
      } on ServerException catch (error) {
        return Left(ServerFailure(errorMessage: error.message.toString()));
      }
    } else {
      return Left(
          NetworkConnectionFailure(errorMessage: "No internet connection"));
    }
  }

  @override
  Future<Either<Failure, String?>>? postEndRoutine(
      {required Routine routine, required String apiToken}) async {
    if (await networkInfo.isConnected!) {
      try {
        final result = await remoteDataSource.postEndRoutine(
          apiToken: apiToken,
          routine: routine,
        );
        return Right(result);
      } on ServerException catch (error) {
        return Left(ServerFailure(errorMessage: error.message.toString()));
      }
    } else {
      return Left(
          NetworkConnectionFailure(errorMessage: "No internet connection"));
    }
  }

@override
Future<Either<Failure, String?>>? storeVehicleLocationEnd({
  required int vehicleId,
  required int driverId,
  required double lat,
  required double long,
  required String address,
  required String reachedAt,
  required String date,
  required String apiToken,
}) async {
  if (await networkInfo.isConnected!) {
  try {
    final message = await remoteDataSource.storeVehicleLocationEnd(
      vehicleId: vehicleId,
      driverId: driverId,
      lat: lat,
      long: long,
      address: address,
      reachedAt: reachedAt,
      date: date,
      apiToken: apiToken,
    );

    return Right(message);
      } on ServerException catch (error) {
        return Left(ServerFailure(errorMessage: error.message.toString()));
      }
    } else {
      return Left(
          NetworkConnectionFailure(errorMessage: "No internet connection"));
    }
  }

  @override
  Future<Either<Failure, String?>>? postRefillReport(
      {required Routine routine, required String apiToken}) async {
    if (await networkInfo.isConnected!) {
      try {
        final result = await remoteDataSource.postRefillReport(
          apiToken: apiToken,
          routine: routine,
        );
        return Right(result);
      } on ServerException catch (error) {
        return Left(ServerFailure(errorMessage: error.message.toString()));
      }
    } else {
      return Left(
          NetworkConnectionFailure(errorMessage: "No internet connection"));
    }
  }

  @override
  Future<Either<Failure, List<AdditionCharge>?>>? getBill(
      {required String apiToken, required Routine routine}) async {
    if (await networkInfo.isConnected!) {
      try {
        final additionalChargesList = await remoteDataSource.getBill(
            apiToken: apiToken, routine: routine);
        return Right(additionalChargesList);
      } on ServerException catch (error) {
        return Left(ServerFailure(errorMessage: error.message.toString()));
      }
    } else {
      return Left(
          NetworkConnectionFailure(errorMessage: 'No internet connection'));
    }
  }
    @override
  Future<Either<Failure, List<DuResponseData>?>>? getDuStatusResponse(
      ) async {
    if (await networkInfo.isConnected!) {
      try {
        final additionalChargesList = await remoteDataSource.getDuStatusResponse();
        return Right(additionalChargesList);
      } on ServerException catch (error) {
        return Left(ServerFailure(errorMessage: error.message.toString()));
      }
    } else {
      return Left(
          NetworkConnectionFailure(errorMessage: 'No internet connection'));
    }
  }

     @override
  Future<Either<Failure, String?>>? updateReacheadAt(
      {required Routine routine, required String apiToken}) async {
    if (await networkInfo.isConnected!) {
      try {
        final result = await remoteDataSource.updateReacheadAt(
          apiToken: apiToken,
          routine: routine,
        );
        return Right(result);
      } on ServerException catch (error) {
        return Left(ServerFailure(errorMessage: error.message.toString()));
      }
    } else {
      return Left(
          NetworkConnectionFailure(errorMessage: "No internet connection"));
    }
  }

}
