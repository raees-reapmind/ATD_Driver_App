import 'package:atd/features/routine_feature/data/models/routine_details.dart';
import 'package:hive/hive.dart';
import '../../../../core/errors/exceptions.dart';

abstract class RoutineLocalDataSource {
  Future<void>? setRoutines({required RoutineDetails? routines});

  Future<RoutineDetails>? getRoutines();
}

const routinesKey = "routines_key";

class RoutineLocalDataSourceImpl implements RoutineLocalDataSource {
  final Box routinesBox;

  RoutineLocalDataSourceImpl({required this.routinesBox});

  @override
  Future<RoutineDetails>? getRoutines() {
    final Future<RoutineDetails>? result = routinesBox.get(routinesKey);
    if (result != null) {
      return result;
    } else {
      throw DatabaseException();
    }
  }

  @override
  Future<void>? setRoutines({required RoutineDetails? routines}) {
    if (routines != null) {
      return routinesBox.put(routinesKey, routines);
    } else {
      throw DatabaseException();
    }
  }
}
