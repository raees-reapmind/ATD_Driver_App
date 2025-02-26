import 'package:atd/features/dispenser_feature/domain/entities/dispenser_report.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';

abstract class DispenserReportRepository {
  Future<Either<Failure, List<DispenserReport>?>>? getDispenserReport();

  Future<Either<Failure, bool?>>? setDispenserReport({
    required List<DispenserReport> dispenserReports,
  });
}