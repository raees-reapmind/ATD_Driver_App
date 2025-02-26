import 'package:atd/utils/palette.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const imagesPath = "lib/utils/images";

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






