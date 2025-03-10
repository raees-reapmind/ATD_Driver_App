import 'dart:async';

import 'package:atd/features/location_feature/display/provider/location_provider.dart';
import 'package:atd/features/login_feature/display/provider/login_provider.dart';
import 'package:atd/features/routine_feature/display/providers/routines_provider.dart';
import 'package:atd/utils/palette.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';



const imagesPath = "lib/utils/images";
  Timer? _locationTimer;


void showSnackBar({required BuildContext context, required String message}) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message,style: const TextStyle(color: Colors.black),), backgroundColor: primary500));
}

 Future<void> savePlanId(String planId) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('planId', planId.toString());
      print('[api-test] Saved planId: $planId');
    } catch (e) {
      print('[api-test] savePlanId SharedPreferences error: $e');
    }
  }

Future<String?> getPlanId() async {
  try {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? planId = prefs.getString('planId'); 
    print('[api-test] getPlanId planId: $planId');
    return planId; 
  } catch (e) {
    print('[api-test] getPlanId SharedPreferences error: $e');
    return null; 
  }
}

Future<void> clearSharedPref() async {
  try {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? planId = prefs.getString('planId');
    debugPrint('[pref-test] clearSharedPref planId before clear: $planId');
    // Clear all stored preferences
    await prefs.clear();
    debugPrint('[pref-test] SharedPreferences cleared successfully');
  } catch (e) {
    debugPrint('[pref-test] SharedPreferences error: $e');
  }
}

void startLocationUpdates(LoginProvider loginProvider,RoutinesProvider routineProvider) {
  
  if (_locationTimer != null && _locationTimer!.isActive) {
    print("[time-test] Location updates already running");
    return;
  }

  _locationTimer = Timer.periodic(Duration(seconds: 45), (timer) {
    print("[time-test] Calling API...");
    LocationProvider locationProvider = LocationProvider();
    locationProvider.sendLocationToServer(apiToken: loginProvider.userDetails!.apiToken!,routineProvider: routineProvider);
  });

  print("[time-test] Location updates started");
}

void stopLocationUpdates() {
    print("[time-test] stopLocationUpdates called---");
  if (_locationTimer != null) {
    _locationTimer!.cancel();
    _locationTimer = null;
    print("[time-test] Location updates stopped");
  }
}


String getCurrentTime() {
  DateTime now = DateTime.now();
  return DateFormat('HH:mm').format(now);
}


void clearTextFields(List<TextEditingController> controllers) {
  for (var controller in controllers) {
    controller.clear();
  }
}


int generateYYYYMMDDHHMMSSUniqueId() {
  return int.parse(DateTime.now().toLocal().toString()
      .replaceAll(RegExp(r'[^0-9]'), '')
      .substring(0, 14)); // Extracts YYYYMMDDHHMMSS
}

DateTime getCurrentTimeWithoutMilliseconds() {
  final now = DateTime.now();
  final formattedTime = DateFormat('HH.mm.ss').format(now);
  final parsedTime = DateFormat('HH.mm.ss').parse(formattedTime);

  return DateTime(
    now.year,
    now.month,
    now.day,
    parsedTime.hour,
    parsedTime.minute,
    parsedTime.second,
  );
}
