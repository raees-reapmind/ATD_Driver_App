import 'dart:async';

import 'package:atd/core/services/location_service.dart';
import 'package:atd/features/image_upload_feature/display/providers/image_upload_provider.dart';
import 'package:atd/features/routine_feature/display/pages/delivery/delivery_screen.dart';
import 'package:atd/features/routine_feature/display/pages/delivery/transfer-from/transfer_from_report_screen.dart';
import 'package:atd/features/routine_feature/display/pages/delivery/transfer_to_report_screen.dart';
import 'package:atd/features/routine_feature/display/pages/refill/refill_screen.dart';
import 'package:atd/features/routine_feature/display/widgets/dashboard_card.dart';
import 'package:atd/features/vehicle_readings_feature/data/models/image_details.dart';
import 'package:atd/features/vehicle_readings_feature/display/providers/vehicle_details_provider.dart';
import 'package:atd/utils/constants.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:atd/utils/widgets/custom_alert_dialog.dart';
import 'package:atd/utils/widgets/failure_dialog.dart';
import 'package:atd/utils/widgets/provider_export.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../utils/utils_export.dart';
import '../../data/models/routine.dart';
import '../widgets/routine_card_new.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:atd/features/login_feature/data/models/session_stage.dart';
import '../../../login_feature/display/pages/login_screen.dart';

final ValueNotifier<double> desiredDifference = ValueNotifier(0.0);

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final TextEditingController odometerController = TextEditingController();
  final TextEditingController totalizerDuLeftController =
      TextEditingController();
  final TextEditingController totalizerDuRightController =
      TextEditingController();
  XFile? image;
  int count = 0;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final routineProvider = Provider.of<RoutinesProvider>(context, listen: false);
      final loginProvider = Provider.of<LoginProvider>(context, listen: false);
      routineProvider.eitherFailureOrGetRoutines(apiToken: loginProvider.userDetails!.apiToken!);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool isTripStarted = prefs.getBool('trip_started') ?? false; 
      if (isTripStarted) {
        startLocationUpdates(loginProvider, routineProvider);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final routineProvider = Provider.of<RoutinesProvider>(context);
    final loginProvider = Provider.of<LoginProvider>(context);
    final imageUploadProvider = Provider.of<ImageUploadProvider>(context);
    final vehicleReadingsProvider =
        Provider.of<VehicleReadingsProvider>(context);

    return Scaffold(
      body: Stack(
        children: [
          const CustomBackground(),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const DashboardCard(),
                  Expanded(
                    child: Card(
                      color: white300,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            const SizedBox(height: 10),
                            Center(
                              child: Text(
                                "Routine",
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Expanded(
                              child: ListView.builder(
                                physics: const BouncingScrollPhysics(),
                                itemCount: routineProvider.routines.length,
                                itemBuilder: ((context, index) {
                                  return RoutineCard(
                                    routine: routineProvider.routines[index],
                                    onTapArrived: () => arrivedClickEvent(
                                        context,
                                        routineProvider.routines[index],
                                        index,
                                        routineProvider,
                                        loginProvider,
                                        imageUploadProvider,
                                        vehicleReadingsProvider),
                                    onTapCancel: () {},
                                    onTapNavigate: () => openMapEvent(
                                        lat: routineProvider
                                            .routines[index].latitude,
                                        lng: routineProvider
                                            .routines[index].longitude),
                                    isRoutineEnd: routineProvider.isRoutineEnd,
                                  );
                                }),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void arrivedClickEvent(
    BuildContext context,
    Routine routine,
    int index,
    RoutinesProvider routineProvider,
    LoginProvider loginProvider,
    ImageUploadProvider imageUploadProvider,
    VehicleReadingsProvider vehicleReadingsProvider,
  ) async {
    // todo add geofencing
    // /* await vehicleReadingsProvider
    //     .eitherFailureOrGetVehicleDetails(
    //         apiToken: loginProvider.userDetails!.apiToken!)
    //   .then((isSuccess) {
    // if (isSuccess) {
    //   odometerController.text =
    //       vehicleReadingsProvider.vehicleReadings!.remoteOdometer.toString();
    /* totalizerDuLeftController.text = vehicleReadingsProvider
            .vehicleReadings!.remoteTotalizeDuLeft
            .toString();
        totalizerDuRightController.text = vehicleReadingsProvider
            .vehicleReadings!.remoteTotalizeDuRight
            .toString(); */
    //  stopLocationUpdates();

    switch (routine.type) {
      case "delivery":
        deliveryArrivedClickEvent(
            context, routine, index, routineProvider, loginProvider);
        break;
      case "refill":
        refillArrivedClickEvent(
            context, routine, index, routineProvider, loginProvider);
        break;
      case "start":
        startArrivedClickEvent(
            context, routine, index, routineProvider, loginProvider);
        break;
      case "end":
        endArrivedClickEvent(context, routine, index, routineProvider,
            loginProvider, imageUploadProvider);
        break;
      case "internal_transfer_to":
        transferArrivedClickEvent(
            context, routine, index, routineProvider, loginProvider);
        break;
      case "internal_transfer_from":
        transferFromArriverdClickEvent(
            context, routine, index, routineProvider, loginProvider);
        break;
    }
  }
  /* });
  } */

  void openMapEvent({required double lat, required double lng}) async {
    final Uri uri = Uri.parse("google.navigation:q=$lat,$lng&mode=d");
    try {
      await launchUrl(uri);
    } catch (e) {
      debugPrint('Could not open the map : ${e.toString()}');
    }
  }

  void startArrivedClickEvent(BuildContext context, Routine routine, int index,
      RoutinesProvider routineProvider, LoginProvider loginProvider) {
    debugPrint('[trip-test] startArrivedClickEvent called---');

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => CustomAlertDialog(
        isOdometer: true,
        odometerController: odometerController,
        isTotalizer: true,
        totalizerDuLeftController: totalizerDuLeftController,
        totalizerDuRightController: totalizerDuRightController,
        onTapSave: () async {
          if (odometerController.text.isNotEmpty) {
            routineProvider.routines[index].odometerReading =
                double.tryParse(odometerController.text.toString());
            routineProvider.routines[index].startTotalizerDuLeft =
                double.tryParse(totalizerDuLeftController.text.toString());
            routineProvider.routines[index].startTotalizerDuRight =
                double.tryParse(totalizerDuRightController.text.toString());

            debugPrint(
                '[data-test] startArrivedClickEvent Odometer: ${odometerController.text} DU Left: ${totalizerDuLeftController.text} DU Right: ${totalizerDuRightController.text}');

            await routineProvider
                .eitherFailureOrPostStartRoutine(
                    apiToken: loginProvider.userDetails!.apiToken!,
                    routine: routineProvider.routines[index])
                .then((isSuccess) {
              if (isSuccess) {
                startLocationUpdates(loginProvider, routineProvider);
                stopLocationUpdatesOfInit(true);
                clearTextFields([
                  odometerController,
                  totalizerDuLeftController,
                  totalizerDuRightController
                ]);
                routineProvider
                    .eitherFailureOrGetRoutines(
                        apiToken: loginProvider.userDetails!.apiToken!)
                    .whenComplete(() => Navigator.of(context).pop());
              } else {
                FailureDialog(
                  content: routineProvider.failure!.errorMessage.toString(),
                );
              }
            });
          }
        },
        onTapCancel: () {
          clearTextFields([
            odometerController,
            totalizerDuLeftController,
            totalizerDuRightController
          ]);
          Navigator.of(context).pop();
        },
      ),
    );
  }

  void transferArrivedClickEvent(
      BuildContext context,
      Routine routine,
      int index,
      RoutinesProvider routineProvider,
      LoginProvider loginProvider) async {
    debugPrint('[trip-test] transferArrivedClickEvent called---');

    showLoading();
    // await checkTOT(1, totalizerDuLeftController);
    // await checkTOT(2, totalizerDuRightController);

    bool permission = await Geolocator.isLocationServiceEnabled();
    if (!permission) {
      hideLoading();
      _showLocationServiceRequiredDialog();
      return;
    }
    bool isWithinAccuracy = await checkAccuracy(
        routineProvider.routines[index].latitude,
        routineProvider.routines[index].longitude);
    if (count <= 2) {
      hideLoading();
      if (isWithinAccuracy) {
        // if (routineProvider.planDetails?.id == 1) {
        // ignore: use_build_context_synchronously
        showDialog(
          context: context,
          builder: (context) {
            return CustomAlertDialog(
              title: 'Start Details',
              isOdometer: true,
              isTotalizer: true,
              odometerController: odometerController,
              totalizerDuLeftController: totalizerDuLeftController,
              totalizerDuRightController: totalizerDuRightController,
              onTapSave: () async {
                final odometerReading =
                    double.tryParse(odometerController.text.toString());
                final totalizerDuLeftReading =
                    double.tryParse(totalizerDuLeftController.text.toString());
                final totalizerDuRightReading =
                    double.tryParse(totalizerDuRightController.text.toString());
                if (odometerReading != null &&
                    totalizerDuLeftReading != null &&
                    totalizerDuRightReading != null) {
                  routineProvider.routines[index].odometerReading =
                      odometerReading;
                  routineProvider.routines[index].startTotalizerDuLeft =
                      totalizerDuLeftReading;
                  routineProvider.routines[index].startTotalizerDuRight =
                      totalizerDuRightReading;
                  routineProvider.routines[index].arrivedDatetime =
                      DateTime.now();

                  try {
                    await LocationService()
                        .determinePosition()
                        .then((position) {
                      routineProvider.routines[index].endLatitude =
                          position.latitude;
                      routineProvider.routines[index].endLongitude =
                          position.longitude;
                      routineProvider.notifyDataChange();
                      stopLocationUpdates();
                      debugPrint(
                          '[data-test] transferArrivedClickEvent Odometer: ${routineProvider.routines[index].odometerReading} DU Left: ${routineProvider.routines[index].startTotalizerDuLeft} DU Right: ${routineProvider.routines[index].startTotalizerDuRight} time: ${routineProvider.routines[index].arrivedDatetime}');

                      Navigator.of(context).push(MaterialPageRoute(
                          builder: ((context) => TransferScreen(
                                index: index,
                              ))));
                      clearTextFields([
                        odometerController,
                        totalizerDuLeftController,
                        totalizerDuRightController
                      ]);
                    });
                  } catch (e) {
                    // ignore: use_build_context_synchronously
                    showSnackBar(context: context, message: e.toString());
                  }
                }
              },
              onTapCancel: () {
                Navigator.of(context).pop();
                clearTextFields([
                  odometerController,
                  totalizerDuLeftController,
                  totalizerDuRightController
                ]);
              },
            );
          },
        );
      } else {
        hideLoading();
        _showOutOfRangePopup();
        setState(() {
          count++;
        });
      }
    } else {
      // ignore: use_build_context_synchronously
      showDialog(
          context: context,
          builder: (context) {
            return CustomAlertDialog(
              title:
                  'You have not reached delivery location. Do you want to proceed with delivery?',
              onTapSave: () async {
                Navigator.of(context).pop();

                showDialog(
                  context: context,
                  builder: (context) {
                    return CustomAlertDialog(
                      title: 'Start Details',
                      isOdometer: true,
                      isTotalizer: true,
                      odometerController: odometerController,
                      totalizerDuLeftController: totalizerDuLeftController,
                      totalizerDuRightController: totalizerDuRightController,
                      onTapSave: () async {
                        final odometerReading =
                            double.tryParse(odometerController.text.toString());
                        final totalizerDuLeftReading = double.tryParse(
                            totalizerDuLeftController.text.toString());
                        final totalizerDuRightReading = double.tryParse(
                            totalizerDuRightController.text.toString());

                        if (odometerReading != null &&
                            totalizerDuLeftReading != null &&
                            totalizerDuRightReading != null) {
                          routineProvider.routines[index].odometerReading =
                              odometerReading;
                          routineProvider.routines[index].startTotalizerDuLeft =
                              totalizerDuLeftReading;
                          routineProvider.routines[index]
                              .startTotalizerDuRight = totalizerDuRightReading;
                          routineProvider.routines[index].arrivedDatetime =
                              DateTime.now();

                          try {
                            await LocationService()
                                .determinePosition()
                                .then((position) {
                              routineProvider.routines[index].endLatitude =
                                  position.latitude;
                              routineProvider.routines[index].endLongitude =
                                  position.longitude;
                              routineProvider.notifyDataChange();
                              stopLocationUpdates();
                              debugPrint(
                                  '[data-test] transferArrivedClickEvent Odometer: ${routineProvider.routines[index].odometerReading} DU Left: ${routineProvider.routines[index].startTotalizerDuLeft} DU Right: ${routineProvider.routines[index].startTotalizerDuRight} time: ${routineProvider.routines[index].arrivedDatetime}');

                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: ((context) => TransferScreen(
                                        index: index,
                                      ))));
                              // Navigator.of(context).pop();
                              clearTextFields([
                                odometerController,
                                totalizerDuLeftController,
                                totalizerDuRightController
                              ]);
                            });
                          } catch (e) {
                            // ignore: use_build_context_synchronously
                            showSnackBar(
                                context: context, message: e.toString());
                          }
                        }
                      },
                      onTapCancel: () {
                        Navigator.of(context).pop();
                        clearTextFields([
                          odometerController,
                          totalizerDuLeftController,
                          totalizerDuRightController
                        ]);
                      },
                    );
                  },
                );
              },
              onTapCancel: () {
                Navigator.of(context).pop();
                clearTextFields([
                  odometerController,
                  totalizerDuLeftController,
                  totalizerDuRightController
                ]);
              },
            );
          });
    }
  }

  void transferFromArriverdClickEvent(
      BuildContext context,
      Routine routine,
      int index,
      RoutinesProvider routineProvider,
      LoginProvider loginProvider) async {
    debugPrint('[trip-test] transferFromArriverdClickEvent called---');

    showLoading();
    // await checkTOT(1, totalizerDuLeftController);
    // await checkTOT(2, totalizerDuRightController);

    bool permission = await Geolocator.isLocationServiceEnabled();
    if (!permission) {
      hideLoading();
      _showLocationServiceRequiredDialog();
      return;
    }
    bool isWithinAccuracy = await checkAccuracy(
        routineProvider.routines[index].latitude,
        routineProvider.routines[index].longitude);
    if (count <= 2) {
      hideLoading();
      if (isWithinAccuracy) {
        if (routineProvider.planDetails?.id == 1) {
          // ignore: use_build_context_synchronously
          showDialog(
            context: context,
            builder: (context) {
              return CustomAlertDialog(
                title: 'Start Details',
                isOdometer: true,
                odometerController: odometerController,
                onTapSave: () async {
                  Navigator.of(context).pop();

                  showDialog(
                    context: context,
                    builder: (context) {
                      return CustomAlertDialog(
                        title: 'Start Details',
                        isOdometer: true,
                        odometerController: odometerController,
                        onTapSave: () async {
                          final odometerReading = double.tryParse(
                              odometerController.text.toString());

                          if (odometerReading != null) {
                            routineProvider.routines[index].odometerReading =
                                odometerReading;
                            routineProvider.routines[index].arrivedDatetime =
                                DateTime.now();

                            try {
                              await LocationService()
                                  .determinePosition()
                                  .then((position) {
                                routineProvider.routines[index].endLatitude =
                                    position.latitude;
                                routineProvider.routines[index].endLongitude =
                                    position.longitude;
                                routineProvider.notifyDataChange();
                                stopLocationUpdates();
                                debugPrint(
                                    '[data-test] transferArrivedClickEvent Odometer: ${routineProvider.routines[index].odometerReading} DU Left: ${routineProvider.routines[index].startTotalizerDuLeft} DU Right: ${routineProvider.routines[index].startTotalizerDuRight} time: ${routineProvider.routines[index].arrivedDatetime}');

                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: ((context) => TransferFromScreen(
                                          index: index,
                                        ))));
                                // Navigator.of(context).pop();
                                clearTextFields([odometerController]);
                              });
                            } catch (e) {
                              // ignore: use_build_context_synchronously
                              showSnackBar(
                                  context: context, message: e.toString());
                            }
                          }
                        },
                        onTapCancel: () {
                          Navigator.of(context).pop();
                          clearTextFields([odometerController]);
                        },
                      );
                    },
                  );
                },
                onTapCancel: () {
                  Navigator.of(context).pop();
                  clearTextFields([
                    odometerController,
                    totalizerDuLeftController,
                    totalizerDuRightController
                  ]);
                },
              );
            },
          );

          // Navigator.of(context).pop();
          // ignore: use_build_context_synchronously
          Navigator.of(context).push(MaterialPageRoute(
              builder: ((context) => TransferFromScreen(
                    index: index,
                  ))));
        } else {
          hideLoading();
          _showOutOfRangePopup();
          setState(() {
            count++;
          });
        }
      } else {
        // ignore: use_build_context_synchronously
        showDialog(
            context: context,
            builder: (context) {
              return CustomAlertDialog(
                title:
                    'You have not reached delivery location. Do you want to proceed with delivery?',
                onTapSave: () async {
                  Navigator.of(context).pop();

                  showDialog(
                    context: context,
                    builder: (context) {
                      return CustomAlertDialog(
                        title: 'Start Details',
                        isOdometer: true,
                        odometerController: odometerController,
                        onTapSave: () async {
                          final odometerReading = double.tryParse(
                              odometerController.text.toString());

                          if (odometerReading != null) {
                            routineProvider.routines[index].odometerReading =
                                odometerReading;
                            routineProvider.routines[index].arrivedDatetime =
                                DateTime.now();
                            // routineProvider.routines[index].arrivedDatetime = getCurrentTimeWithoutMilliseconds();

                            try {
                              await LocationService()
                                  .determinePosition()
                                  .then((position) {
                                routineProvider.routines[index].endLatitude =
                                    position.latitude;
                                routineProvider.routines[index].endLongitude =
                                    position.longitude;
                                routineProvider.notifyDataChange();
                                stopLocationUpdates();
                                debugPrint(
                                    '[data-test] transferArrivedClickEvent Odometer: ${routineProvider.routines[index].odometerReading} DU Left: ${routineProvider.routines[index].startTotalizerDuLeft} DU Right: ${routineProvider.routines[index].startTotalizerDuRight} time: ${routineProvider.routines[index].arrivedDatetime}');

                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: ((context) => TransferFromScreen(
                                          index: index,
                                        ))));
                                clearTextFields([odometerController]);
                              });
                            } catch (e) {
                              // ignore: use_build_context_synchronously
                              showSnackBar(
                                  context: context, message: e.toString());
                            }
                          }
                        },
                        onTapCancel: () {
                          Navigator.of(context).pop();
                          clearTextFields([odometerController]);
                        },
                      );
                    },
                  );
                },
                onTapCancel: () {
                  Navigator.of(context).pop();
                  clearTextFields([odometerController]);
                },
              );
            });
      }
    }
  }

  void stopLocationUpdatesOfInit(bool isStart) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();  
      prefs.setBool('trip_started', isStart); 
  }

  void endArrivedClickEvent(
      BuildContext context,
      Routine routine,
      int index,
      RoutinesProvider routineProvider,
      LoginProvider loginProvider,
      ImageUploadProvider imageUploadProvider) {
    debugPrint('[click-test] endArrivedClickEvent');

    List<ImageDetails> imageList = [];
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => CustomAlertDialog(
        imageContent:
            'Kindly upload the images of odometer and totalizer readings',
        isOdometer: true,
        isTotalizer: true,
        isImage: true,
        totalizerDuLeftController: totalizerDuLeftController,
        totalizerDuRightController: totalizerDuRightController,
        onTapImage: (images) {
          imageList = images;
        },
        odometerController: odometerController,
        onTapSave: () async {
          routineProvider
              .submitEndRoutine(
            index: index,
            loginProvider: loginProvider,
            imageUploadProvider: imageUploadProvider,
            imageList: imageList,
            odometerReading:
                double.tryParse(odometerController.text.toString()),
            totalizerDuLeft:
                double.tryParse(totalizerDuLeftController.text.toString()),
            totalizerDuRight:
                double.tryParse(totalizerDuRightController.text.toString()),
          )
              .then((response) {
            switch (response) {
              case Response.nullData:
                showSnackBar(
                    context: context, message: 'All fields are mandatory');
                break;
              case Response.imageUploadError:
                showSnackBar(
                    context: context, message: 'Failed to upload images');
                break;
              case Response.apiError:
                showSnackBar(
                    context: context, message: 'Error in sending data');
                break;
              case Response.success:
                stopLocationUpdates();
                routineProvider.isRoutineEnd = true;
                showSnackBar(context: context, message: 'Success');
                clearTextFields([
                  odometerController,
                  totalizerDuLeftController,
                  totalizerDuRightController
                ]);
                stopLocationUpdatesOfInit(false);
                logOutClickEvent(context, loginProvider);
                // Navigator.of(context).pop();

                break;
            }
          });
        },
        onTapCancel: () {
          Navigator.of(context).pop();
        },
      ),
    );
  }

  void refillArrivedClickEvent(BuildContext context, Routine routine, int index,
      RoutinesProvider routineProvider, LoginProvider loginProvider) {
    showDialog(
        context: context,
        builder: (context) {
          return CustomAlertDialog(
            isOdometer: true,
            odometerController: odometerController,
            onTapSave: () async {
              routineProvider.routines[index].odometerReading =
                  double.parse(odometerController.text.toString());
              routineProvider.routines[index].arrivedDatetime = DateTime.now();
              // routineProvider.routines[index].arrivedDatetime = getCurrentTimeWithoutMilliseconds();

              try {
                await LocationService().determinePosition().then((position) {
                  routineProvider.routines[index].endLatitude =
                      position.latitude;
                  routineProvider.routines[index].endLongitude =
                      position.longitude;
                  stopLocationUpdates();
                  clearTextFields([odometerController]);
                  Navigator.of(context).pop();
                  routineProvider.updateReachedAt(
                      apiToken: loginProvider.userDetails!.apiToken!,
                      routine: routineProvider.routines[index]);
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: ((context) => RefillScreen(
                            index: index,
                          ))));
                });
              } catch (e) {
                clearTextFields([odometerController]);
                // ignore: use_build_context_synchronously
                showSnackBar(context: context, message: e.toString());
              }
            },
            onTapCancel: () {
              Navigator.of(context).pop();
            },
          );
        });
  }

///////Actual Code
  // void deliveryArrivedClickEvent(
  //     BuildContext context,
  //     Routine routine,
  //     int index,
  //     RoutinesProvider routineProvider,
  //     LoginProvider loginProvider) async {
  //   showDialog(
  //       context: context,
  //       builder: (context) {
  //         return CustomAlertDialog(
  //           title: 'Start Details',
  //           isOdometer: true,
  //           isTotalizer: true,
  //           odometerController: odometerController,
  //           totalizerDuLeftController: totalizerDuLeftController,
  //           totalizerDuRightController: totalizerDuRightController,
  //           onTapSave: () async {
  //             final odometerReading =
  //                 double.tryParse(odometerController.text.toString());
  //             final totalizerDuLeftReading =
  //                 double.tryParse(totalizerDuLeftController.text.toString());
  //             final totalizerDuRightReading =
  //                 double.tryParse(totalizerDuRightController.text.toString());
  //             if (odometerReading != null &&
  //                 totalizerDuLeftReading != null &&
  //                 totalizerDuRightReading != null) {
  //               routineProvider.routines[index].odometerReading =
  //                   odometerReading;
  //               routineProvider.routines[index].startTotalizerDuLeft =
  //                   totalizerDuLeftReading;
  //               routineProvider.routines[index].startTotalizerDuRight =
  //                   totalizerDuRightReading;
  //               routineProvider.routines[index].arrivedDatetime =
  //                   DateTime.now();
  //               try {
  //                 await LocationService().determinePosition().then((position) {
  //                   routineProvider.routines[index].endLatitude =
  //                       position.latitude;
  //                   routineProvider.routines[index].endLongitude =
  //                       position.longitude;
  //                   routineProvider.notifyDataChange();
  //                   Navigator.of(context).push(MaterialPageRoute(
  //                       builder: ((context) => DeliveryScreen(
  //                             index: index,
  //                           ))));
  //                 });
  //               } catch (e) {
  //                 showSnackBar(context: context, message: e.toString());
  //               }
  //             }
  //           },
  //           onTapCancel: () {
  //             Navigator.of(context).pop();
  //           },
  //         );
  //       });
  // }

/////////Amita
  String mainUrl = "http://192.168.202.155:8001";
// //  // final Dio dio = Dio();

  Future<void> checkTOT(int flag, TextEditingController controller) async {
    debugPrint('[trip-test] dashboard Check TOT clicked $flag');

    final String baseUrl1 = '$mainUrl/api/v1/du-totalizer-readings';
    final String baseUrl2 = '$mainUrl/api/v1/gvr-du-totalizer-readings';

    try {
      final response = await http.get(Uri.parse(baseUrl1)
          .replace(queryParameters: {'flag': flag.toString()}));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final responseData = jsonResponse['response'];
        debugPrint('CheckTOT is $responseData');

        final double totalizerReading = responseData['totalizerReading'];
        debugPrint('Totalizer Reading: $totalizerReading');

        // Update the relevant controller
        controller.text = totalizerReading.toStringAsFixed(2);
      } else {
        debugPrint('Failed to load data: ${response.statusCode}');
      }
    } catch (error) {
      debugPrint('An error occurred: $error');
    }
  }

  void logOutClickEvent(
      BuildContext context, LoginProvider loginProvider) async {
    await loginProvider
        .changeSessionStage(sessionStage: SessionStage.logout)
        .whenComplete(() {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => const LoginScreen()));
    });
  }

  void deliveryArrivedClickEvent(
      BuildContext context,
      Routine routine,
      int index,
      RoutinesProvider routineProvider,
      LoginProvider loginProvider) async {
    showLoading();
    // await checkTOT(1, totalizerDuLeftController);
    // await checkTOT(2, totalizerDuRightController);

    debugPrint('[click-test] deliveryArrivedClickEvent');

    bool permission = await Geolocator.isLocationServiceEnabled();
    if (!permission) {
      hideLoading();
      _showLocationServiceRequiredDialog();
      return;
    }
    bool isWithinAccuracy = await checkAccuracy(
        routineProvider.routines[index].latitude,
        routineProvider.routines[index].longitude);
    if (count <= 2) {
      hideLoading();
      if (isWithinAccuracy) {
        // if (routineProvider.planDetails?.id == 1) {
        // ignore: use_build_context_synchronously
        showDialog(
          context: context,
          builder: (context) {
            return CustomAlertDialog(
              title: 'Start Details',
              isOdometer: true,
              isTotalizer: true,
              odometerController: odometerController,
              totalizerDuLeftController: totalizerDuLeftController,
              totalizerDuRightController: totalizerDuRightController,
              onTapSave: () async {
                final odometerReading =
                    double.tryParse(odometerController.text.toString());
                final totalizerDuLeftReading =
                    double.tryParse(totalizerDuLeftController.text.toString());
                final totalizerDuRightReading =
                    double.tryParse(totalizerDuRightController.text.toString());
                if (odometerReading != null &&
                    totalizerDuLeftReading != null &&
                    totalizerDuRightReading != null) {
                  routineProvider.routines[index].odometerReading =
                      odometerReading;
                  routineProvider.routines[index].startTotalizerDuLeft =
                      totalizerDuLeftReading;
                  routineProvider.routines[index].startTotalizerDuRight =
                      totalizerDuRightReading;
                  routineProvider.routines[index].arrivedDatetime =
                      DateTime.now();
                  // routineProvider.routines[index].arrivedDatetime = getCurrentTimeWithoutMilliseconds();
                  debugPrint(
                      'routineProvider.routines[index].arrivedDatetime: ${routineProvider.routines[index].arrivedDatetime}');

                  try {
                    await LocationService()
                        .determinePosition()
                        .then((position) {
                      routineProvider.routines[index].endLatitude =
                          position.latitude;
                      routineProvider.routines[index].endLongitude =
                          position.longitude;
                      routineProvider.notifyDataChange();
                      stopLocationUpdates();
                      routineProvider.updateReachedAt(
                          apiToken: loginProvider.userDetails!.apiToken!,
                          routine: routineProvider.routines[index]);
                      clearTextFields([
                        odometerController,
                        totalizerDuLeftController,
                        totalizerDuRightController
                      ]);
                      Navigator.of(context).pop();
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: ((context) => DeliveryScreen(
                                index: index,
                              ))));
                    });
                  } catch (e) {
                    // ignore: use_build_context_synchronously
                    showSnackBar(context: context, message: e.toString());
                  }
                }
              },
              onTapCancel: () {
                clearTextFields([
                  odometerController,
                  totalizerDuLeftController,
                  totalizerDuRightController
                ]);
                Navigator.of(context).pop();
              },
            );
          },
        );
      } else {
        hideLoading();
        _showOutOfRangePopup();
        setState(() {
          count++;
        });
      }
    } else {
      // ignore: use_build_context_synchronously
      showDialog(
          context: context,
          builder: (context) {
            return CustomAlertDialog(
              title:
                  'You have not reached delivery location. Do you want to proceed with delivery?',
              onTapSave: () async {
                showDialog(
                  context: context,
                  builder: (context) {
                    return CustomAlertDialog(
                      title: 'Start Details',
                      isOdometer: true,
                      isTotalizer: true,
                      odometerController: odometerController,
                      totalizerDuLeftController: totalizerDuLeftController,
                      totalizerDuRightController: totalizerDuRightController,
                      onTapSave: () async {
                        final odometerReading =
                            double.tryParse(odometerController.text.toString());
                        final totalizerDuLeftReading = double.tryParse(
                            totalizerDuLeftController.text.toString());
                        final totalizerDuRightReading = double.tryParse(
                            totalizerDuRightController.text.toString());
                        if (odometerReading != null &&
                            totalizerDuLeftReading != null &&
                            totalizerDuRightReading != null) {
                          routineProvider.routines[index].odometerReading =
                              odometerReading;
                          routineProvider.routines[index].startTotalizerDuLeft =
                              totalizerDuLeftReading;
                          routineProvider.routines[index]
                              .startTotalizerDuRight = totalizerDuRightReading;
                          routineProvider.routines[index].arrivedDatetime =
                              DateTime.now();
                          // routineProvider.routines[index].arrivedDatetime = getCurrentTimeWithoutMilliseconds();
                          debugPrint(
                              'routineProvider.routines[index].arrivedDatetime: ${routineProvider.routines[index].arrivedDatetime}');

                          try {
                            await LocationService()
                                .determinePosition()
                                .then((position) {
                              routineProvider.routines[index].endLatitude =
                                  position.latitude;
                              routineProvider.routines[index].endLongitude =
                                  position.longitude;
                              routineProvider.notifyDataChange();
                              stopLocationUpdates();
                              routineProvider.updateReachedAt(
                                  apiToken:
                                      loginProvider.userDetails!.apiToken!,
                                  routine: routineProvider.routines[index]);
                              clearTextFields([
                                odometerController,
                                totalizerDuLeftController,
                                totalizerDuRightController
                              ]);
                              Navigator.of(context).pop();
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: ((context) => DeliveryScreen(
                                        index: index,
                                      ))));
                            });
                          } catch (e) {
                            // ignore: use_build_context_synchronously
                            showSnackBar(
                                context: context, message: e.toString());
                          }
                        }
                      },
                      onTapCancel: () {
                        clearTextFields([
                          odometerController,
                          totalizerDuLeftController,
                          totalizerDuRightController
                        ]);
                        Navigator.of(context).pop();
                      },
                    );
                  },
                );
              },
              onTapCancel: () {
                Navigator.of(context).pop();
              },
            );
          });
    }
    // }
  }
///////////
}

void _showOutOfRangePopup() {
  debugPrint('Error msg is coming');
  Fluttertoast.cancel();
  Fluttertoast.showToast(
    msg:
        "You have not reached destination, pls try again after reaching delivery location.",
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.CENTER,
    timeInSecForIosWeb: 1,
    backgroundColor: Colors.yellow,
    textColor: Colors.black,
    fontSize: 16.0,
  );
}

void _showLocationServiceRequiredDialog() {
  Fluttertoast.showToast(
    msg: "location services are denied please enable the location sevices",
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.CENTER,
    timeInSecForIosWeb: 1,
    backgroundColor: Colors.yellow,
    textColor: Colors.black,
    fontSize: 16.0,
  );
}

Future<bool> checkAccuracy(double lat, double long) async {
  // Replace these values with your desired latitude and longitude
  double desiredLatitude = lat;
  double desiredLongitude = long;

  //12.918597684729301, 77.56417040916841

  // Replace this value with your desired accuracy in meters
  double desiredAccuracy = 100.0;

  Position currentPosition = await Geolocator.getCurrentPosition(
    desiredAccuracy: LocationAccuracy.best,
  );

  double distance = Geolocator.distanceBetween(
    currentPosition.latitude,
    currentPosition.longitude,
    desiredLatitude,
    desiredLongitude,
  );

  debugPrint('[loc-test] lat:${currentPosition.latitude}');
  debugPrint('[loc-test] long:${currentPosition.longitude}');
  debugPrint('[loc-test] distance:$distance');

  double accuracyDifference = distance - desiredAccuracy;
  desiredDifference.value = accuracyDifference;
  debugPrint('[loc-test] lat:$accuracyDifference');

  if (distance > desiredAccuracy) {
    // The current position is outside the desired accuracy range
    // _showOutOfRangePopup();
    return false;
  } else {
    // The current position is within the desired accuracy range
    debugPrint("Within the desired accuracy range");
    return true;
  }
}
