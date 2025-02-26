//const mainUrl = 'http://13.127.149.69'; // uat
//const mainUrl = 'http://65.0.125.193'; // live
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

// const mainUrl = 'https://uat.anytimediesel.com'; // took from postman
const duUrl = 'http://192.168.202.155:8001';
//const mainUrl = 'http://3.110.218.28'; // new live
//const mainUrl = 'https://oms.anytimediesel.com';// Prod Url
const getOtpUrl = '$mainUrl/api/driver/login';
const mainUrl = 'https://phpstack-906681-5029380.cloudwaysapps.com';// Dev Url

const putOtpUrl = '$mainUrl/api/otp';
const getVehicleChecksUrl = '$mainUrl/api/app/vehicle-checklists';
const postVehicleChecksUrl = '$mainUrl/api/app/vehicle-checklists';
const postVehicleLocationUrl = '$mainUrl/api/app/vehicle-location';
const getDispenserChecksUrl = '$mainUrl/api/app/vehicle-dispenser-checks';
const postDispenserChecksUrl = '$mainUrl/api/app/vehicle-dispenser-checks';
const getVehicleReadingsUrl = '$mainUrl/api/app/vehicle-readings';
const postVehicleReadingsUrl = '$mainUrl/api/app/vehicle-readings';
const getRoutinesUrl = '$mainUrl/api/app/routines';
const postStartRoutineUrl = '$mainUrl/api/app/routines/start';
const postEndRoutineUrl = '$mainUrl/api/app/routines/end';
const postRefillReportUrl = '$mainUrl/api/app/routines/refill';
const postDeliveryReportUrl = '$mainUrl/api/app/routines/delivery';
const postImageUploadUrl = '$mainUrl/api/app/media';
const postVehicleDetailsUrl = '$mainUrl/api/app/vehicle-readings';
const getVehicleDetailsUrl = '$mainUrl/api/app/vehicle-readings';
const getduStatus = '$duUrl/api/v1/du-date-time';
const getBillUrl = '$mainUrl/api/app/routines/bill';
const userDetailsBoxKey = 'user_details_box_key';
const vehicleChecksBoxKey = 'vehicle_checks_box_key';
const dispenserChecksBoxKey = 'dispenser_checks_box_key';
const routinesBoxKey = 'routines_box_key';


void showLoading() {
  if (Get.isDialogOpen == true) {
    //log("Show loading called ...");
    Get.dialog(
      //barrierDismissible: false,
      Dialog(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(
                color: Colors.grey,
              ),
              // const SizedBox(height: 8),
              Text(
                 'Loading...',
                style: const TextStyle(fontSize: 12, color: Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
void hideLoading() {
  //log("Show loading dismissed ...");
  if (Get.isDialogOpen == true) {
    Get.back();
  }
}
