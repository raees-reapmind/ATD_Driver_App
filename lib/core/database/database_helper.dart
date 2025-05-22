import 'package:atd/features/dispenser_checks_feature/data/models/dispenser_check.dart';
import 'package:atd/features/login_feature/data/models/session_stage.dart';
import 'package:atd/features/routine_feature/data/models/asset.dart';
import 'package:atd/features/routine_feature/data/models/bill.dart';
import 'package:atd/features/routine_feature/data/models/routine.dart';
import 'package:atd/features/vehicle_checks_feature/domain/entities/vehicle_check.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../features/login_feature/data/models/user_details.dart';
import '../../utils/constants.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();

  static final DatabaseHelper _instance = DatabaseHelper._privateConstructor();

  factory DatabaseHelper() => _instance;

  late final Box _userDetailsBox;
  late final Box _vehicleChecksBox;
  late final Box _dispenserChecksBox;
  late final Box _routinesBox;

  late final Box _pendingVehicleChecksBox;
  // late final Box _offlineVehicleReadingsBox;


  Box get userDetailsBox => _userDetailsBox;
  Box get vehicleChecksBox => _vehicleChecksBox;
  Box get dispenserChecksBox => _dispenserChecksBox;
  Box get routinesBox => _routinesBox;

  Box get pendingVehicleChecksBox => _pendingVehicleChecksBox;
  // Box get offlineVehicleReadingsBox => _offlineVehicleReadingsBox;



  Future<void> init() async {
    try {
      await Hive.initFlutter().whenComplete(() async {
        _registerAdapter();
        await _openBox();
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> _openBox() async {
    _userDetailsBox = await Hive.openBox(userDetailsBoxKey);
    _vehicleChecksBox = await Hive.openBox(vehicleChecksBoxKey);
    _dispenserChecksBox = await Hive.openBox(dispenserChecksBoxKey);
    _routinesBox = await Hive.openBox(routinesBoxKey);
    _pendingVehicleChecksBox = await Hive.openBox(pendingVehicleChecksBoxKey);
    // _offlineVehicleReadingsBox = await Hive.openBox(vehicleReadingDetails);
  }

  Future<void> _closeBox() async {
    // _userDetailsBox.close();
    // _vehicleChecksBox.close();
    // _dispenserChecksBox.close();
  }

  void _registerAdapter() {
    Hive.registerAdapter(UserDetailsAdapter());
    Hive.registerAdapter(SessionStageAdapter());
    Hive.registerAdapter(VehicleCheckAdapter());
    Hive.registerAdapter(DispenserCheckAdapter());
    Hive.registerAdapter(RoutineAdapter());
    Hive.registerAdapter(AssetAdapter());
    Hive.registerAdapter(BillAdapter());
  }
}
