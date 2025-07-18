import 'package:atd/features/location_feature/domain/entities/location.dart';
import 'package:dio/dio.dart';
import '../../../../core/errors/exceptions.dart';

abstract class LocationRemoteDataSource {
  Future<bool>? setLocation({required List<Location> locationList});
}

class LocationRemoteDataSourceImpl implements LocationRemoteDataSource {
  final Dio dio;

  LocationRemoteDataSourceImpl({required this.dio});

  @override
  Future<bool>? setLocation({required List<Location> locationList}) async {
    final response = await dio.put(
      "http://www.atd.com/api/setLocation",
      queryParameters: {
        "apiKey": "If needed",
      },
      data: locationList.map((e) => e.toMap()).toList(),
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      throw ServerException();
    }
  }
}
