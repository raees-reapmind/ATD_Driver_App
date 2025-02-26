import 'package:atd/core/services/location_service.dart';
import 'package:atd/features/image_upload_feature/display/providers/image_upload_provider.dart';
import 'package:atd/features/routine_feature/display/pages/delivery/delivery_screen.dart';
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
import 'package:url_launcher/url_launcher.dart';
import '../../../../utils/utils_export.dart';
import '../../data/models/routine.dart';
import '../widgets/routine_card_new.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
  Widget build(BuildContext context) {
    final routineProvider = Provider.of<RoutinesProvider>(context);
    final loginProvider = Provider.of<LoginProvider>(context);
    final imageUploadProvider = Provider.of<ImageUploadProvider>(context);
    final vehicleReadingsProvider = Provider.of<VehicleReadingsProvider>(context);

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
                                              .routines[index].longitude));
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
    //todo add geofencing
    /* await vehicleReadingsProvider
        .eitherFailureOrGetVehicleDetails(
            apiToken: loginProvider.userDetails!.apiToken!)
        .then((isSuccess) {
      if (isSuccess) {
        odometerController.text =
            vehicleReadingsProvider.vehicleReadings!.remoteOdometer.toString();
        /* totalizerDuLeftController.text = vehicleReadingsProvider
            .vehicleReadings!.remoteTotalizeDuLeft
            .toString();
        totalizerDuRightController.text = vehicleReadingsProvider
            .vehicleReadings!.remoteTotalizeDuRight
            .toString(); */ */

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
               print('[trip-test] startArrivedClickEvent called---');

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


            print('[data-test] startArrivedClickEvent Odometer: ${odometerController.text}');
            print('[data-test] startArrivedClickEvent DU Left: ${totalizerDuLeftController.text}');
            print('[data-test] startArrivedClickEvent DU Right: ${totalizerDuRightController.text}');

            await routineProvider
                .eitherFailureOrPostStartRoutine(
                    apiToken: loginProvider.userDetails!.apiToken!,
                    routine: routineProvider.routines[index])
                .then((isSuccess) {
              if (isSuccess) {
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
          Navigator.of(context).pop();
        },
      ),
    );
  }

  void endArrivedClickEvent(
      BuildContext context,
      Routine routine,
      int index,
      RoutinesProvider routineProvider,
      LoginProvider loginProvider,
      ImageUploadProvider imageUploadProvider) {
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
          routineProvider.submitEndRoutine(
            index: index,
            loginProvider: loginProvider,
            imageUploadProvider: imageUploadProvider,
            imageList: imageList,
            odometerReading: double.tryParse(odometerController.text.toString()),
            totalizerDuLeft: double.tryParse(totalizerDuLeftController.text.toString()),
            totalizerDuRight: double.tryParse(totalizerDuRightController.text.toString()),
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
                showSnackBar(context: context, message: 'Success');
                Navigator.of(context).pop();
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
              try {
                await LocationService().determinePosition().then((position) {
                  routineProvider.routines[index].endLatitude =
                      position.latitude;
                  routineProvider.routines[index].endLongitude =
                      position.longitude;
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: ((context) => RefillScreen(
                            index: index,
                          ))));
                });
              } catch (e) {
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
             print('[trip-test] dashboard Check TOT clicked $flag');

    final String baseUrl1 = '$mainUrl/api/v1/du-totalizer-readings';
        final String baseUrl2 = '$mainUrl/api/v1/gvr-du-totalizer-readings';

    try {
      final response = await http.get(Uri.parse(baseUrl1)
          .replace(queryParameters: {'flag': flag.toString()}));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final responseData = jsonResponse['response'];
        print('CheckTOT is $responseData');

        final double totalizerReading = responseData['totalizerReading'];
        print('Totalizer Reading: $totalizerReading');

        // Update the relevant controller
        controller.text = totalizerReading.toStringAsFixed(2);
      } else {
        print('Failed to load data: ${response.statusCode}');
      }
    } catch (error) {
      print('An error occurred: $error');
    }
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
                          try {
                            await LocationService()
                                .determinePosition()
                                .then((position) {
                              routineProvider.routines[index].endLatitude =
                                  position.latitude;
                              routineProvider.routines[index].endLongitude =
                                  position.longitude;
                              routineProvider.notifyDataChange();
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
  print('Error msg is coming');
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

  print('lat:${currentPosition.latitude}');
  print('long:${currentPosition.longitude}');
  print('distance:${distance}');

  double accuracyDifference = distance - desiredAccuracy;
  desiredDifference.value = accuracyDifference;
  print('lat:$accuracyDifference');

  if (distance > desiredAccuracy) {
    // The current position is outside the desired accuracy range
    // _showOutOfRangePopup();
    return false;
  } else {
    // The current position is within the desired accuracy range
    print("Within the desired accuracy range");
    return true;
  }
}
