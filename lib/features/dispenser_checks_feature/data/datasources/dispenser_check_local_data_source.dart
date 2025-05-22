import 'package:atd/features/dispenser_checks_feature/data/models/dispenser_check.dart';
import 'package:hive/hive.dart';
import '../../../../core/errors/exceptions.dart';

abstract class DispenserCheckLocalDataSource {
  Future<void>? setDispenserChecks(
      {required List<DispenserCheck>? dispenserCheckModel});

  Future<List<DispenserCheck>>? getDispenserChecks();
}

const dispenserChecksKey = "local_dispenser_checks_key";

class DispenserCheckLocalDataSourceImpl
    implements DispenserCheckLocalDataSource {
  final Box dispenserChecksBox;

  DispenserCheckLocalDataSourceImpl({required this.dispenserChecksBox});

  @override
  Future<List<DispenserCheck>>? getDispenserChecks() {
    final Future<List<DispenserCheck>>? result =
        dispenserChecksBox.get(dispenserChecksKey);
    if (result != null) {
      return Future.value(result);  
    } else {
      throw DatabaseException();
    }
  }

  @override
  Future<void>? setDispenserChecks(
      {required List<DispenserCheck>? dispenserCheckModel}) {
    if (dispenserCheckModel != null) {
      return dispenserChecksBox.put(dispenserChecksKey, dispenserCheckModel);
    } else {
      throw DatabaseException();
    }
  }


  
}
