import 'package:atd/features/dispenser_feature/domain/entities/dispenser_report.dart';
import 'package:atd/features/dispenser_feature/domain/repository/dispenser_report_repository.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';

class SetDispenserReports {
  final DispenserReportRepository repository;

  SetDispenserReports({required this.repository});

  Future<Either<Failure, bool?>?> call(
      {required List<DispenserReport> dispenserReports}) async {
    return await repository.setDispenserReport(
        dispenserReports: dispenserReports);
  }
}
