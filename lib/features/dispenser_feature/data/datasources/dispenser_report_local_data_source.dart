import 'package:hive/hive.dart';

import '../../../../core/errors/exceptions.dart';
import '../../domain/entities/dispenser_report.dart';

abstract class DispenserReportLocalDataSource {
  Future<void>? setDispenserReports(
      {required List<DispenserReport>? dispenserReports});

  Future<List<DispenserReport>>? getDispenserReports();
}

const dispenserReportsKey = "dispenser_reports_key";

class DispenserReportLocalDataSourceImpl
    implements DispenserReportLocalDataSource {
  final Box dispenserReportsBox;

  DispenserReportLocalDataSourceImpl({required this.dispenserReportsBox});

  @override
  Future<List<DispenserReport>>? getDispenserReports() {
    final Future<List<DispenserReport>>? result =
        dispenserReportsBox.get(dispenserReportsKey);
    if (result != null) {
      return result;
    } else {
      throw DatabaseException();
    }
  }

  @override
  Future<void>? setDispenserReports(
      {required List<DispenserReport>? dispenserReports}) {
    if (dispenserReports != null) {
      return dispenserReportsBox.put(dispenserReportsKey, dispenserReports);
    } else {
      throw DatabaseException();
    }
  }
}
