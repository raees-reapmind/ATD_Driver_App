import 'package:atd/core/errors/failures.dart';
import 'package:atd/features/location_feature/data/datasources/location_local_data_source.dart';
import 'package:atd/features/location_feature/data/datasources/location_remote_data_source.dart';
import 'package:atd/features/location_feature/data/repository/location_repository_impl.dart';
import 'package:atd/features/location_feature/domain/entities/location.dart';
import 'package:data_connection_checker_tv/data_connection_checker.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../../core/connection/network_info.dart';

class LocationProvider extends ChangeNotifier {
  Location? _location;
  Failure? _failure;

  Location? get location => _location;
  List<Location> locationList = [];

  Failure? get failure => _failure;

  void add({required Location location}){
    locationList.add(location);
    notifyListeners();
  }

  void eitherFailureOrSetLocation({required Location location}) async {
    LocationRepositoryImpl repository = LocationRepositoryImpl(
      remoteDataSource: LocationRemoteDataSourceImpl(dio: Dio()),
      localDataSource: LocationLocalDataSourceImpl(
          locationBox: Hive.box('location_box_key')),
      networkInfo: NetworkInfoImpl(connectionChecker: DataConnectionChecker()),
    );
    final result = await repository.setLocation(locationList: locationList);
    result?.fold((newFailure) {
      _failure = newFailure;
      notifyListeners();
    }, (data) {
      if (data != null) {
        if (data == true) {
          _failure = null;
          locationList = [];
        } else {
          _failure = null;
        }
      }
    });
  }
}
