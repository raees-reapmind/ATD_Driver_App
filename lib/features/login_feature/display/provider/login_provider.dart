import 'dart:async';
import 'package:atd/core/database/database_helper.dart';
import 'package:atd/core/errors/failures.dart';
import 'package:atd/features/login_feature/data/datasources/login_local_data_source.dart';
import 'package:atd/features/login_feature/data/datasources/login_remote_data_source.dart';
import 'package:atd/features/login_feature/data/models/session_stage.dart';
import 'package:atd/features/login_feature/data/repository/login_repository_impl.dart';
import 'package:atd/features/login_feature/domain/usecases/get_local_user_details.dart';
import 'package:atd/features/login_feature/domain/usecases/get_otp.dart';
import 'package:atd/features/login_feature/domain/usecases/put_otp.dart';
import 'package:atd/utils/helper.dart';
import 'package:data_connection_checker_tv/data_connection_checker.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/connection/network_info.dart';
import '../../data/models/user_details.dart';

class LoginProvider extends ChangeNotifier {
  UserDetails? userDetails;
  Failure? failure;
  bool isTimerActive = false;
  String otpTitle = 'GET OTP';
  String response = '';

  void startOtpTimer({required int sec}) async {
    isTimerActive = true;
    otpTitle = sec.toString();
    notifyListeners();
    if (sec > 0) {
      await Future.delayed(const Duration(seconds: 1), () {
        startOtpTimer(sec: sec - 1);
      });
    } else {
      isTimerActive = false;
      otpTitle = 'GET OTP';
      response = '';
      notifyListeners();
    }
  }

  Future<void> changeSessionStage({required SessionStage sessionStage}) async {
    LoginRepositoryImpl repository = LoginRepositoryImpl(
      remoteDataSource: LoginRemoteDataSourceImpl(dio: Dio()),
      localDataSource: LoginLocalDataSourceImpl(
          loginDetailsBox: DatabaseHelper().userDetailsBox),
      networkInfo: NetworkInfoImpl(connectionChecker: DataConnectionChecker()),
    );
    switch (sessionStage) {
      case SessionStage.login:
        userDetails?.sessionStage = sessionStage;
        await repository.localDataSource
            .setUserDetails(userDetails: userDetails);
        break;
      case SessionStage.loginDetails:
        userDetails?.sessionStage = sessionStage;
        await repository.localDataSource
            .setUserDetails(userDetails: userDetails);
        break;
      case SessionStage.vehicleChecks:
        userDetails?.sessionStage = sessionStage;
        await repository.localDataSource
            .setUserDetails(userDetails: userDetails);
        break;
      case SessionStage.dispenserChecks:
        userDetails?.sessionStage = sessionStage;
        await repository.localDataSource
            .setUserDetails(userDetails: userDetails);
        break;
      case SessionStage.dashboard:
        userDetails?.sessionStage = sessionStage;
        await repository.localDataSource
            .setUserDetails(userDetails: userDetails);
        break;
      case SessionStage.logout:
        await repository.localDataSource.setUserDetails(userDetails: null);
        break;
    }
  }

  Future<void> checkUserDataIsValid() async {
    LoginRepositoryImpl repository = LoginRepositoryImpl(
      remoteDataSource: LoginRemoteDataSourceImpl(dio: Dio()),
      localDataSource: LoginLocalDataSourceImpl(
          loginDetailsBox: DatabaseHelper().userDetailsBox),
      networkInfo: NetworkInfoImpl(connectionChecker: DataConnectionChecker()),
    );
    final response = await GetLocalUserDetails(repository: repository).call();
    response?.fold((newFailure) {
      debugPrint(newFailure.errorMessage.toString());
    }, (data) {
      userDetails = data;
    });
  }

  Future<void> eitherFailureOrGetOtp() async {
    LoginRepositoryImpl repository = LoginRepositoryImpl(
      remoteDataSource: LoginRemoteDataSourceImpl(dio: Dio()),
      localDataSource: LoginLocalDataSourceImpl(
          loginDetailsBox: DatabaseHelper().userDetailsBox),
      networkInfo: NetworkInfoImpl(connectionChecker: DataConnectionChecker()),
    );
    final failureOrGetOtp = await GetOtp(repository: repository).call(userDetails: userDetails!);
    failureOrGetOtp?.fold((newFailure) {
      userDetails = null; //todo change to null
      failure = newFailure;
      debugPrint(newFailure.errorMessage.toString());
      response = newFailure.errorMessage.toString();
      notifyListeners();
    }, (data) {
      if (data != null) {
        //todo navigate to next page
        startOtpTimer(sec: 120);
        failure = null;
        response = 'OTP has been sent';
        notifyListeners();
      }
    });
  }

  Future<void> eitherFailureOrPutOtp() async {
    LoginRepositoryImpl repository = LoginRepositoryImpl(
      remoteDataSource: LoginRemoteDataSourceImpl(dio: Dio()),
      localDataSource: LoginLocalDataSourceImpl(
          loginDetailsBox: DatabaseHelper().userDetailsBox),
      networkInfo: NetworkInfoImpl(connectionChecker: DataConnectionChecker()),
    );
    final failureOrPutOtp = await PutOtp(repository: repository).call(userDetails: userDetails!);
    failureOrPutOtp?.fold((newFailure) {
      userDetails = null; //todo change to null
      failure = newFailure;
      response = newFailure.errorMessage.toString();
      notifyListeners();
    }, (data) async {
      if (data != null) {
        //todo navigate to next page
        debugPrint(data.toString());
        userDetails = data;
        failure = null;
        repository.localDataSource.setUserDetails(userDetails: userDetails);
        notifyListeners();
      }
    });
  }
}
