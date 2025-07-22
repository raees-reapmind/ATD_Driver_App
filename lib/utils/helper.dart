import 'dart:async';

import 'package:atd/features/dispenser_checks_feature/display/providers/dispenser_checks_provider.dart';
import 'package:atd/features/location_feature/display/provider/location_provider.dart';
import 'package:atd/features/login_feature/display/provider/login_provider.dart';
import 'package:atd/features/routine_feature/display/providers/routines_provider.dart';
import 'package:atd/features/vehicle_checks_feature/display/provider/vehicle_checks_provider.dart';
import 'package:atd/utils/palette.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

const imagesPath = "lib/utils/images";
Timer? _locationTimer;

void showSnackBar({required BuildContext context, required String message}) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        message,
        style: const TextStyle(color: Colors.black),
      ),
      backgroundColor: primary500));
}

Future<void> savePlanId(String planId) async {
  try {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('planId', planId.toString());
    debugPrint('[api-test] Saved planId: $planId');
  } catch (e) {
    debugPrint('[api-test] savePlanId SharedPreferences error: $e');
  }
}

Future<String?> getPlanId() async {
  try {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? planId = prefs.getString('planId');
    debugPrint('[api-test] getPlanId planId: $planId');
    return planId;
  } catch (e) {
    debugPrint('[api-test] getPlanId SharedPreferences error: $e');
    return null;
  }
}

Future<void> clearDataOnLogOut(
  BuildContext context,
  DispenserChecksProvider dispenserChecksProvider,
  VehicleChecksProvider vehicleChecksProvider,
) async {
  debugPrint('clearDataOnLogOut called----');
  dispenserChecksProvider.clearDispenserChecksList();
  vehicleChecksProvider.clearVehicleChecks();
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

Future<void> saveUserIdOnce(int vehicleId) async {
  final prefs = await SharedPreferences.getInstance();
  final existing = prefs.getString('id_userstep');

  if (existing == null || !existing.contains('_')) {
    await prefs.setString('id_userstep', '${vehicleId}_1'); // initial step is 0
  }
}

Future<void> updateUserStep(int newStep) async {
  final prefs = await SharedPreferences.getInstance();
  final data = prefs.getString('id_userstep');
  if (data != null && data.contains('_')) {
    final parts = data.split('_');
    final vehicleId = parts[0];
    await prefs.setString('id_userstep', '${vehicleId}_$newStep');
    final confirmedValue = prefs.getString('id_userstep');
    debugPrint('[SharedPref] Confirmed updated value: $confirmedValue');
  }
}

Future<void> checkAndRedirect(
    int currentVehicleId, BuildContext context) async {
  final prefs = await SharedPreferences.getInstance();
  final data = prefs.getString('id_userstep');

  if (data != null && data.contains('_')) {
    final parts = data.split('_');
    final storedId = int.tryParse(parts[0]);
    final step = int.tryParse(parts[1]);

    if (storedId == currentVehicleId) {
      switch (step) {
        case 1:
          Navigator.pushNamed(context, '/step1');
          break;
        case 2:
          Navigator.pushNamed(context, '/step2');
          break;
        // Add more steps if needed
        default:
          break;
      }
    }
  }
}

// void startLocationUpdates(
//     LoginProvider loginProvider, RoutinesProvider routineProvider) {
//   if (_locationTimer != null && _locationTimer!.isActive) {
//     debugPrint("[time-test] Location updates already running");
//     return;
//   }

//   _locationTimer = Timer.periodic(const Duration(minutes: 2), (timer) {
//     debugPrint("[time-test] Calling API...");
//     LocationProvider locationProvider = LocationProvider();
//     locationProvider.sendLocationToServer(
//         apiToken: loginProvider.userDetails!.apiToken!,
//         routineProvider: routineProvider);
//   });

//   debugPrint("[time-test] Location updates started");
// }
void startLocationUpdates(
    LoginProvider loginProvider, RoutinesProvider routineProvider) {
  if (_locationTimer != null && _locationTimer!.isActive) {
    debugPrint("[time-test] Location updates already running");
    return;
  }

  _locationTimer = Timer.periodic(const Duration(minutes: 2), (timer) async {
    debugPrint("[time-test] Calling API...");

    try {
      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Reverse geocode to get address
      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      final address =
          "${placemarks.first.street ?? ''}, ${placemarks.first.locality ?? ''}";

      // Call the API with address
      LocationProvider locationProvider = LocationProvider();
      await locationProvider.sendLocationToServer(
        apiToken: loginProvider.userDetails!.apiToken!,
        routineProvider: routineProvider,
        address: address,
        planId: await getPlanId() ?? '',
      );
    } catch (e) {
      debugPrint("[time-test] Error while getting location or sending: $e");
    }
  });

  debugPrint("[time-test] Location updates started");
}

void stopLocationUpdates() {
  debugPrint("[time-test] stopLocationUpdates called---");
  if (_locationTimer != null) {
    _locationTimer!.cancel();
    _locationTimer = null;
    debugPrint("[time-test] Location updates stopped");
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
  return int.parse(DateTime.now()
      .toLocal()
      .toString()
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
