
import 'package:flutter/material.dart';
import 'package:get/get.dart';

const String appEnv = String.fromEnvironment('APP_ENV', defaultValue: 'uat');
const String mainUrl = String.fromEnvironment('MAIN_URL', defaultValue: 'https://uat.anytimediesel.com');
const String duUrl = String.fromEnvironment('DU_URL', defaultValue: 'http://192.168.202.155:8001');



const getOtpUrl = '$mainUrl/api/driver/login';
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

const liveLocationPostApi = '$mainUrl/endpoint';
const postTransferReportUrl = '$mainUrl/api/app/routines/internal-transfer';
const postTransferFromReportUrl = '$mainUrl/api/app/routines/internal-transfer-from';
const updateReachedAt = '$mainUrl/api/app/update-reached-at';
const storeVehicleEndLocation = '$mainUrl/api/app/v2/store-vehicle-end-location';

void showLoading() {
  if (Get.isDialogOpen == true) {
    //log("Show loading called ...");
    Get.dialog(
      //barrierDismissible: false,
      const Dialog(
        child: Padding(
          padding:  EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
               CircularProgressIndicator(
                color: Colors.grey,
              ),
              // const SizedBox(height: 8),
              Text(
                 'Loading...',
                style:  TextStyle(fontSize: 12, color: Colors.black),
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
