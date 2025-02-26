import 'package:atd/core/errors/failures.dart';
import 'package:atd/features/dispenser_feature/data/datasources/dispenser_report_local_data_source.dart';
import 'package:atd/features/dispenser_feature/data/datasources/dispenser_report_remote_data_source.dart';
import 'package:atd/features/dispenser_feature/domain/entities/dispenser_report.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/connection/network_info.dart';
import '../../../../core/errors/exceptions.dart';
import '../../domain/repository/dispenser_report_repository.dart';

class DispenserReportRepositoryImpl implements DispenserReportRepository {
  final DispenserReportRemoteDataSource remoteDataSource;
  final DispenserReportLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  DispenserReportRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<DispenserReport>?>>? getDispenserReport() async {
    if (await networkInfo.isConnected!) {
      try {
        final remoteDispenserReports = await remoteDataSource.getDispenserReports();
        localDataSource.setDispenserReports(dispenserReports: remoteDispenserReports);
        return Right(remoteDispenserReports);
      } on ServerException catch (errorMessage) {
        return Left(ServerFailure(errorMessage: errorMessage.toString()));
      }
    } else {
      try {
        final localDispenserReports = await localDataSource.getDispenserReports();
        return Right(localDispenserReports);
      } on DatabaseException catch (errorMessage) {
        return Left(DatabaseFailure(errorMessage: errorMessage.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, bool?>>? setDispenserReport(
      {required List<DispenserReport> dispenserReports}) async {
    if (await networkInfo.isConnected!) {
      try {
        final localDispenserReport = await localDataSource.getDispenserReports();
        if (localDispenserReport != null) {
          final result = await remoteDataSource.setDispenserReports(dispenserReports: localDispenserReport);
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
