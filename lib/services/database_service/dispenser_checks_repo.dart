// import 'package:atd/models/dispenser_check.dart';
// import 'package:atd/services/database_service/keys.dart';
// import 'package:flutter/material.dart';
//
// import 'database_service.dart';
//
// class DispenserChecksRepo {
//   DispenserChecksRepo._privateConstructor();
//
//   static final DispenserChecksRepo _instance =
//       DispenserChecksRepo._privateConstructor();
//
//   factory DispenserChecksRepo() => _instance;
//
//   Future<void> create(List<DispenserCheck> value) async {
//     debugPrint("DISPENSER CHECK CREATE : $value");
//     await DatabaseService().dispenserChecksBox.put(dispenserChecksBoxKey, value);
//   }
//
//   Future<List<DispenserCheck>> get() async {
//     List<DispenserCheck> result =
//         await DatabaseService().dispenserChecksBox.get(dispenserChecksBoxKey);
//     debugPrint("DISPENSER CHECK GET : $result");
//     return result;
//   }
// }
