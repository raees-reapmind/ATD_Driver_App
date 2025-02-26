// import 'package:atd/services/database_service/keys.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
//
// class AuthHelper {
//   AuthHelper._privateConstructor();
//
//   static final AuthHelper _instance = AuthHelper._privateConstructor();
//
//   factory AuthHelper() => _instance;
//
//   Future<void> login(UserDetails value) async {
//     debugPrint("LOGIN EVENT : $value");
//     await DatabaseService().userDetailsBox.put(userDetailsKey, value);
//   }
//
//   Future<UserDetails> get() async {
//     UserDetails userDetails = await DatabaseService().userDetailsBox.get(userDetailsKey);
//     debugPrint("GET USER EVENT : $userDetails");
//     return userDetails;
//   }
//
//   Future<void> logOut() async {
//     debugPrint("LOGOUT EVENT");
//     await DatabaseService().userDetailsBox.put(userDetailsKey, null);
//   }
//
//   Future<bool> checkStatus() async {
//     UserDetails? auth = await DatabaseService().userDetailsBox.get(userDetailsKey);
//     if (auth != null) {
//       // login same day
//       if (DateFormat("yyyy-MM-dd").format(auth.dateTime) ==
//           DateFormat("yyyy-MM-dd").format(DateTime.now())) {
//         debugPrint("LOGIN STATUS SAME DAY : $auth");
//         return true;
//       } else {
//         // login another day
//         debugPrint("LOGIN STATUS ANOTHER DAY : $auth");
//         return false;
//       }
//     } else {
//       // no login data found
//       debugPrint("LOGIN STATUS NO DATA FOUND : $auth");
//       return false;
//     }
//   }
// }
