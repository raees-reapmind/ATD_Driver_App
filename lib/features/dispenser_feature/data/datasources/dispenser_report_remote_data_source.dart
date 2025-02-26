import 'package:dio/dio.dart';

import '../../../../core/errors/exceptions.dart';
import '../../domain/entities/dispenser_report.dart';

abstract class DispenserReportRemoteDataSource {
  Future<bool>? setDispenserReports(
      {required List<DispenserReport>? dispenserReports});

  Future<List<DispenserReport>>? getDispenserReports();
}

class DispenserReportRemoteDataSourceImpl
    implements DispenserReportRemoteDataSource {
  final Dio dio;

  DispenserReportRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<DispenserReport>>? getDispenserReports() async {
    final response = await dio.get(
      "http://www.atd.com/api/getDispenserReports",
      queryParameters: {
        "apiKey": "If needed",
      },
    );
    if (response.statusCode == 200) {
      return response.data.map((e) => DispenserReport.fromJson(e)).fromList();
    } else {
      throw ServerException();
    }
  }

  @override
  Future<bool>? setDispenserReports(
      {required List<DispenserReport>? dispenserReports}) async {
    final response = await dio.put(
      "http://www.atd.com/api/setDispenserReports",
      queryParameters: {
        "apiKey": "If needed",
      },
      data: dispenserReports?.map((e) => e.toJson()).toList(),
    );
    if (response.statusCode == 200) {
      return Future.value(true);
    } else {
      throw ServerException();
    }
  }
}
