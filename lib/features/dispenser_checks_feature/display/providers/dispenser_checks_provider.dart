import 'package:atd/core/database/database_helper.dart';
import 'package:atd/core/errors/failures.dart';
import 'package:atd/features/dispenser_checks_feature/data/datasources/dispenser_check_local_data_source.dart';
import 'package:atd/features/dispenser_checks_feature/data/datasources/dispenser_check_remote_data_source.dart';
import 'package:atd/features/dispenser_checks_feature/data/repository/dispenser_check_repository_impl.dart';
import 'package:atd/features/dispenser_checks_feature/domain/usecases/get_dispenser_checks.dart';
import 'package:atd/features/dispenser_checks_feature/domain/usecases/set_dispenser_checks.dart';
import 'package:data_connection_checker_tv/data_connection_checker.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import '../../../../core/connection/network_info.dart';
import '../../data/models/dispenser_check.dart';

class DispenserChecksProvider extends ChangeNotifier {
  List<DispenserCheck> dispenserChecksList = [];
  Failure? failure;
  String? message;

  final List<String> fromList = [
    'SELECT',
    'du left',
    'du right',
    'measuring can',
    'drum',
  ];

  final List<String> toList = [
    'SELECT',
    'main tank',
    'side service tank',
    'measuring can',
    'drum'
  ];

  void add({required DispenserCheck dispenserCheck}) async {
    dispenserChecksList.add(dispenserCheck);
    notifyListeners();
  }

  void eitherFailureOrGetDispenserChecks({required String apiToken}) async {
    DispenserCheckRepositoryImpl repository = DispenserCheckRepositoryImpl(
      remoteDataSource: DispenserCheckRemoteDataSourceImpl(dio: Dio()),
      localDataSource: DispenserCheckLocalDataSourceImpl(
          dispenserChecksBox: DatabaseHelper().dispenserChecksBox),
      networkInfo: NetworkInfoImpl(connectionChecker: DataConnectionChecker()),
    );
    final failureOrDispenserChecks =
        await GetDispenserChecks(repository: repository)
            .call(apiToken: apiToken);
    failureOrDispenserChecks?.fold((newFailure) {
      dispenserChecksList = [];
      failure = newFailure;
      notifyListeners();
    }, (data) {
      if (data != null) {
        dispenserChecksList = data;
        failure = null;
        notifyListeners();
      }
    });
  }

  Future<bool> eitherFailureOrSetDispenserChecks(
      {required String apiToken}) async {
    DispenserCheckRepositoryImpl repository = DispenserCheckRepositoryImpl(
      remoteDataSource: DispenserCheckRemoteDataSourceImpl(dio: Dio()),
      localDataSource: DispenserCheckLocalDataSourceImpl(
          dispenserChecksBox: DatabaseHelper().dispenserChecksBox),
      networkInfo: NetworkInfoImpl(connectionChecker: DataConnectionChecker()),
    );
    bool isSuccess = true;
    final result = await SetDispenserChecks(repository: repository)
        .call(dispenserChecks: dispenserChecksList, apiToken: apiToken);
    result?.fold((newFailure) {
      message = newFailure.errorMessage;
      failure = newFailure;
      notifyListeners();
      isSuccess = false;
    }, (data) {
      failure = null;
      message = data;
      notifyListeners();
      isSuccess = true;
    });
    return isSuccess;
  }
}
