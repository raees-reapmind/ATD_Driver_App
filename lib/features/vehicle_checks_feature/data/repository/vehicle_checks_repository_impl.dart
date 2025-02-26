import 'dart:convert';
import 'package:atd/core/errors/exceptions.dart';
import 'package:atd/core/errors/failures.dart';
import 'package:atd/features/vehicle_checks_feature/data/datasources/vehicle_checks_local_data_source.dart';
import 'package:atd/features/vehicle_checks_feature/data/datasources/vehicle_checks_remote_data_source.dart';
import 'package:atd/features/vehicle_checks_feature/domain/entities/vehicle_check.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../../../core/connection/network_info.dart';
import '../../domain/repository/vehicle_check_repository.dart';

class VehicleChecksRepositoryImpl implements VehicleChecksRepository {
  final VehicleChecksRemoteDataSource remoteDataSource;
  final VehicleChecksLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  VehicleChecksRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<VehicleCheck>?>>? getVehicleChecks(
      {required String apiToken}) async {
    if (await networkInfo.isConnected!) {
      try {
        final response = await remoteDataSource.getVehicleChecks(apiToken: apiToken);
        return Right(response);
      } on DioError catch (errorMessage) {
        debugPrint(errorMessage.response.toString());
        return Left(ServerFailure(
            errorMessage: json.decode(errorMessage.response.toString())['message']));
      } on ServerException catch (errorMessage) {
        return Left(ServerFailure(errorMessage: errorMessage.toString()));
      }
    } else {
      return Left(
          NetworkConnectionFailure(errorMessage: 'No internet connection !'));
    }
  }

  @override
  Future<Either<Failure, String?>>? setVehicleChecks(
      {required List<VehicleCheck>? vehicleChecks,
      required String apiToken}) async {
    if (await networkInfo.isConnected!) {
      try {
        await localDataSource.setVehicleChecks(vehicleChecks: vehicleChecks);
        if (vehicleChecks != null) {
          final result = await remoteDataSource.setVehicleChecks(vehicleChecks: vehicleChecks, apiToken: apiToken);
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
