 
import 'package:atd/features/location_feature/domain/entities/location.dart';
import 'package:hive/hive.dart';
import '../../../../core/errors/exceptions.dart';

abstract class LocationLocalDataSource {
  Future<void>? setLocation({required List<Location>? locationList});

  Future<List<Location>>? getLocation();
}

const locationKey = 'location_key';

class LocationLocalDataSourceImpl implements LocationLocalDataSource {
  final Box locationBox;

  LocationLocalDataSourceImpl({required this.locationBox});

  @override
  Future<void>? setLocation({required List<Location>? locationList}) {
    if (locationList != null) {
      return locationBox.put(locationKey, locationList);
    } else {
      throw DatabaseException();
    }
  }

  @override
  Future<List<Location>>? getLocation() {
    final Future<List<Location>>? result = locationBox.get(locationKey);
    if (result != null) {
      return result;
    } else {
      throw DatabaseException();
    }
  }
}
