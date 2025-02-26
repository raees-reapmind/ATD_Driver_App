import 'package:atd/features/dispenser_feature/domain/entities/dispenser_report.dart';
import 'package:atd/features/dispenser_feature/domain/repository/dispenser_report_repository.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';

class GetDispenserReports {
  final DispenserReportRepository repository;

  GetDispenserReports({required this.repository});

  Future<Either<Failure, List<DispenserReport>?>?> call(NoParams params) async {
    return await repository.getDispenserReport();
  }
}
