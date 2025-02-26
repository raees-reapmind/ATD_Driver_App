import 'package:atd/features/vehicle_readings_feature/data/datasources/vehicle_details_remote_data_source.dart';
import 'package:dartz/dartz.dart';
import 'package:atd/core/errors/failures.dart';

import '../../../../core/connection/network_info.dart';
import '../../../../core/errors/exceptions.dart';
import '../../domain/repository/vehicle_details_repository.dart';
import '../models/vehicle_details.dart';

class VehicleDetailsRepositoryImpl implements VehicleDetailsRepository {
  final VehicleDetailsRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  VehicleDetailsRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, VehicleReadings?>>? getVehicleDetails(
      {required String apiToken}) async {
    if (await networkInfo.isConnected!) {
      try {
        final result =
            await remoteDataSource.getVehicleDetails(apiToken: apiToken);
        return Right(result);
      } on ServerException catch (errorMessage) {
        return Left(ServerFailure(errorMessage: errorMessage.toString()));
      }
    } else {
      return Left(
          NetworkConnectionFailure(errorMessage: "No internet connection"));
    }
  }

  @override
  Future<Either<Failure, String?>>? postVehicleDetails(
      {required VehicleReadings vehicleReadings,
      required String apiToken}) async {
    if (await networkInfo.isConnected!) {
      try {
        final result = await remoteDataSource.postVehicleDetails(
            apiToken: apiToken, vehicleReadings: vehicleReadings);
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
