import 'package:atd/core/database/database_helper.dart';
import 'package:atd/features/login_feature/data/datasources/login_local_data_source.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'features/login_feature/data/models/user_details.dart';

class DatabaseTestScreen extends StatelessWidget {
  const DatabaseTestScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          ElevatedButton(
              onPressed: () => getClickEvent(), child: const Text('GET')),
          ElevatedButton(
              onPressed: () => setClickEvent(), child: const Text('SET')),
        ],
      )),
    );
  }
}

void setClickEvent() async {
  Box box = DatabaseHelper().userDetailsBox;
  // try {
  //   // await box.put(
  //   //     loginKey,
  //   //     UserDetails(
  //   //         phoneNo: '9876543210',
  //   //         vehicleRegNo: 'vehicleRegNo',
  //   //         dateTime: DateTime.now()));
  //   await box.put(loginKey, null);
  // } catch (e) {
  //   debugPrint(e.toString());
  // }

  final repo = LoginLocalDataSourceImpl(loginDetailsBox: box);
  try {
    await repo.setUserDetails(
        userDetails: UserDetails(
            phoneNo: '1234',
            vehicleRegNo: 'vehicleRegNo',
            dateTime: DateTime.now()));
  } catch (e) {
    debugPrint(e.toString());
  }
}

void getClickEvent() async {
  Box box = DatabaseHelper().userDetailsBox;
  // try {
  //   final result = await box.get(loginKey);
  //   debugPrint(result.toString());
  // } catch (e) {
  //   debugPrint(e.toString());
  // }

  final repo = LoginLocalDataSourceImpl(loginDetailsBox: box);
  try {
    final result = await repo.getUserDetails();
    debugPrint(result.toString());
  } catch (e) {
    debugPrint(e.toString());
  }
}
