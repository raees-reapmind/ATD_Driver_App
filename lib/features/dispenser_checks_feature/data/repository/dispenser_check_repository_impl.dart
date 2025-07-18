import 'package:atd/core/errors/failures.dart';
import 'package:atd/features/dispenser_checks_feature/data/datasources/dispenser_check_local_data_source.dart';
import 'package:atd/features/dispenser_checks_feature/data/datasources/dispenser_check_remote_data_source.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/connection/network_info.dart';
import '../../../../core/errors/exceptions.dart';
import '../../domain/repository/dispenser_check_repository.dart';
import '../models/dispenser_check.dart';

class DispenserCheckRepositoryImpl implements DispenserCheckRepository {
  final DispenserCheckRemoteDataSource remoteDataSource;
  final DispenserCheckLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  DispenserCheckRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<DispenserCheck>?>>? getDispenserChecks(
      {required String apiToken}) async {
    if (await networkInfo.isConnected!) {
      try {
        final remoteDispenserChecks =
            await remoteDataSource.getDispenserChecks(apiToken: apiToken);
        return Right(remoteDispenserChecks);
      } on ServerException catch (errorMessage) {
        return Left(ServerFailure(errorMessage: errorMessage.toString()));
      }
    } else {
      // try {
      //   final localVehicleChecks = await localDataSource.getDispenserChecks();
      //   return Right(localVehicleChecks);
      // } on DatabaseException catch (errorMessage) {
      return Left(DatabaseFailure(errorMessage: "errorMessage.toString()"));
      // }
    }
  }

  @override
  Future<Either<Failure, String?>>? setDispenserChecks({
    required List<DispenserCheck> dispenserChecks,
    required String apiToken,
  }) async {
    if (await networkInfo.isConnected!) {
      try {
        // final localDispenserChecks = await localDataSource.getDispenserChecks();
        
        final result = await remoteDataSource.setDispenserChecks(
            dispenserChecks: dispenserChecks, apiToken: apiToken);
        return Right(result);
      } on ServerException catch (errorMessage) {
        return Left(ServerFailure(errorMessage: errorMessage.toString()));
      }
    } else {
      return Left( 
          NetworkConnectionFailure(errorMessage: "No internet connection"));
    }
  }
}
