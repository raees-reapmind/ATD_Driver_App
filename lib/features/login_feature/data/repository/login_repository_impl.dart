import 'dart:convert';

import 'package:atd/core/errors/failures.dart';
import 'package:atd/features/login_feature/data/datasources/login_local_data_source.dart';
import 'package:atd/features/login_feature/data/datasources/login_remote_data_source.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import '../../../../core/connection/network_info.dart';
import '../../../../core/errors/exceptions.dart';
import '../../domain/repository/login_repository.dart';
import '../models/user_details.dart';

class LoginRepositoryImpl implements LoginRepository {
  final LoginRemoteDataSource remoteDataSource;
  final LoginLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  LoginRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, String?>>? getOtp(
      {required UserDetails userDetails}) async {
    if (await networkInfo.isConnected!) {
      try {
        final response =
            await remoteDataSource.getOtp(userDetails: userDetails);
            print('[otp-test] getOtp: $response');
        if (response != null) {
          //details are valid
          return Right(response);
        } else {
          //details are invalid
          return Right(response.toString());
        }
      } on DioError catch (errorMessage) {
        debugPrint(errorMessage.response.toString());
        return Left(ServerFailure(
            errorMessage:
                json.decode(errorMessage.response.toString())['message']));
      } on ServerException catch (errorMessage) {
        return Left(ServerFailure(errorMessage: errorMessage.toString()));
      }
    } else {
      return Left(
          NetworkConnectionFailure(errorMessage: 'No internet connection !'));
    }
  }

  Future<Either<Failure, bool>>? logout(
      {required UserDetails userDetails}) async {
    try {
      await localDataSource.setUserDetails(userDetails: null);
      return const Right(true);
    } on DatabaseException catch (errorMessage) {
      return Left(DatabaseFailure(errorMessage: errorMessage.toString()));
    }
  }

  @override
  Future<Either<Failure, UserDetails?>>? putOtp(
      {required UserDetails userDetails}) async {
    if (await networkInfo.isConnected!) {
      try {
        final response =
            await remoteDataSource.putOtp(userDetails: userDetails);
        if (response != null) {
          //details are valid
          return Right(response);
        } else {
          //details are invalid
          return Right(response);
        }
      } on DioError catch (errorMessage) {
        debugPrint(errorMessage.response.toString());
        return Left(ServerFailure(
            errorMessage:
                json.decode(errorMessage.response.toString())['message']));
      } on ServerException catch (errorMessage) {
        return Left(ServerFailure(errorMessage: errorMessage.toString()));
      }
    } else {
      return Left(
          NetworkConnectionFailure(errorMessage: 'No internet connection !'));
    }
  }

  @override
  Future<Either<Failure, UserDetails?>>? getLocalUserDetails() async {
    try {
      final response = await localDataSource.getUserDetails();
      return Right(response);
    } on DatabaseException catch (errorMessage) {
      return Left(DatabaseFailure(errorMessage: errorMessage.toString()));
    }
  }

  @override
  Future<Either<Failure, void>>? setLocalUserDetails(
      {required UserDetails? userDetails}) async {
    try {
      await localDataSource.setUserDetails(userDetails: userDetails);
      return const Right(null);
    } on DatabaseException catch (errorMessage) {
      return Left(DatabaseFailure(errorMessage: errorMessage.toString()));
    }
  }
}
