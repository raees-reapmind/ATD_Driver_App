// import 'package:atd/services/database_service/database_service.dart';
// import 'package:atd/services/database_service/keys.dart';
// import 'package:flutter/material.dart';
// import 'package:atd/models/vehicle_check.dart';
//
// class VehicleChecksRepo {
//   VehicleChecksRepo._privateConstructor();
//
//   static final VehicleChecksRepo _instance =
//       VehicleChecksRepo._privateConstructor();
//
//   factory VehicleChecksRepo() => _instance;
//
//   Future<void> create(List<VehicleCheck> value) async {
//     debugPrint("VEHICLE CHECK CREATE : $value");
//     await DatabaseService().vehicleChecksBox.put(vehicleChecksKey, value);
//   }
//
//   Future<List<VehicleCheck>> get() async {
//     List<VehicleCheck> result =
//         await DatabaseService().vehicleChecksBox.get(vehicleChecksKey);
//     debugPrint("VEHICLE CHECK GET : $result");
//     return result;
//   }
// }
