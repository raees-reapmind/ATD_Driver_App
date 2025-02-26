import 'package:atd/core/connection/network_info.dart';
import 'package:atd/core/errors/failures.dart';
import 'package:atd/features/location_feature/data/datasources/location_local_data_source.dart';
import 'package:atd/features/location_feature/data/datasources/location_remote_data_source.dart';
import 'package:atd/features/location_feature/domain/entities/location.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../domain/repository/location_repository.dart';

class LocationRepositoryImpl implements LocationRepository {
  final LocationRemoteDataSource remoteDataSource;
  final LocationLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  LocationRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, bool?>>? setLocation(
      {required List<Location> locationList}) async {
    if (await networkInfo.isConnected!) {
      try {
        final localLocationData = await localDataSource.getLocation();
        if (localLocationData != null) {
          final result = await remoteDataSource.setLocation(locationList: locationList);
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
}
