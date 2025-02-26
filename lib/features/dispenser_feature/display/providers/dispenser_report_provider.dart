import 'package:atd/core/errors/failures.dart';
import 'package:atd/core/usecases/usecase.dart';
import 'package:atd/features/dispenser_feature/data/datasources/dispenser_report_local_data_source.dart';
import 'package:atd/features/dispenser_feature/data/datasources/dispenser_report_remote_data_source.dart';
import 'package:atd/features/dispenser_feature/domain/usecases/get_dispenser_reports.dart';
import 'package:data_connection_checker_tv/data_connection_checker.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import '../../../../core/connection/network_info.dart';
import '../../data/repository/dipenser_report_repository_impl.dart';
import '../../domain/entities/dispenser_report.dart';
import '../../domain/usecases/set_dispenser_reports.dart';

class DispenserReportsProvider extends ChangeNotifier {
  List<DispenserReport> dispenserReports = [];
  Failure? failure;

  final List<String> dispenserNameList = [
    "SELECT",
    "DU 1",
    "DU 2",
  ];

  final List<String> assetList = ["SELECT", "Asset 1", "Asset 2", "Asset 3"];

  void add({required DispenserReport dispenserReport}) {
    dispenserReports.add(dispenserReport);
    notifyListeners();
  }

  void eitherFailureOrGetDispenserReports() async {
    DispenserReportRepositoryImpl repository = DispenserReportRepositoryImpl(
      remoteDataSource: DispenserReportRemoteDataSourceImpl(dio: Dio()),
      localDataSource: DispenserReportLocalDataSourceImpl(
          dispenserReportsBox: Hive.box('dispenser_reports_box_key')),
      networkInfo: NetworkInfoImpl(connectionChecker: DataConnectionChecker()),
    );
    final failureOrDispenserReports =
        await GetDispenserReports(repository: repository).call(NoParams());
    failureOrDispenserReports?.fold((newFailure) {
      dispenserReports = [];
      failure = newFailure;
      notifyListeners();
    }, (data) {
      if (data != null) {
        dispenserReports = data;
        failure = null;
        notifyListeners();
      }
    });
  }

  Future<bool?> eitherFailureOrSetDispenserReports() async {
    DispenserReportRepositoryImpl repository = DispenserReportRepositoryImpl(
      remoteDataSource: DispenserReportRemoteDataSourceImpl(dio: Dio()),
      localDataSource: DispenserReportLocalDataSourceImpl(
          dispenserReportsBox: Hive.box('dispenser_reports_box_key')),
      networkInfo: NetworkInfoImpl(connectionChecker: DataConnectionChecker()),
    );
    final failureOrDispenserChecks =
    await SetDispenserReports(repository: repository).call(dispenserReports: dispenserReports);
    failureOrDispenserChecks?.fold((newFailure) {
      dispenserReports = [];
      failure = newFailure;
      notifyListeners();
      return false;
    }, (data) {
      if (data != null) {
        if(data == true){
         //todo send data success message
          notifyListeners();
          return true;
        }else{
          notifyListeners();
          return false;
        }
      }else{
        notifyListeners();
        return false;
      }
    });
    return null;
  }
}
