import 'package:hive/hive.dart';
part 'session_stage.g.dart';

@HiveType(typeId: 7)
enum SessionStage {
  @HiveField(0)
  login,
  @HiveField(1)
  loginDetails,
  @HiveField(2)
  vehicleChecks,
  @HiveField(3)
  dispenserChecks,
  @HiveField(4)
  dashboard,
  @HiveField(5)
  logout,
}
