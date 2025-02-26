import 'dart:convert';

import 'package:atd/features/image_upload_feature/display/providers/image_upload_provider.dart';
import 'package:atd/features/login_feature/data/models/session_stage.dart';
import 'package:atd/features/login_feature/display/provider/login_provider.dart';
import 'package:atd/features/routine_feature/display/providers/routines_provider.dart';
import 'package:atd/features/routine_feature/display/widgets/title_content.dart';
import 'package:atd/features/vehicle_checks_feature/display/pages/vehicle_checks_screen.dart';
import 'package:atd/features/vehicle_readings_feature/data/models/image_details.dart';
import 'package:atd/features/vehicle_readings_feature/data/models/vehicle_details.dart';
import 'package:atd/features/vehicle_readings_feature/display/providers/vehicle_details_provider.dart';
import 'package:atd/utils/widgets/custom_alert_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../utils/utils_export.dart';
import 'package:intl/intl.dart';
import '../../../../utils/widgets/failure_dialog.dart';
import 'package:http/http.dart' as http;

class LoginDetailsScreen extends StatefulWidget {
  const LoginDetailsScreen({Key? key}) : super(key: key);

  @override
  State<LoginDetailsScreen> createState() => _LoginDetailsScreenState();
}

class _LoginDetailsScreenState extends State<LoginDetailsScreen> {
  final TextEditingController odometerController = TextEditingController();
  final TextEditingController totalizerDuLeftController = TextEditingController();
  final TextEditingController totalizerDuRightController = TextEditingController();
  // String mainUrl = "http://192.168.202.155:8001";
  String mainUrl = "https://phpstack-906681-5029380.cloudwaysapps.com";
  var duStatus = "Status";
  double? startTotalizer = 0.0;
  final Dio dio = Dio();
  final quantityController = TextEditingController();
  double? quantity = 0.0;

  double? endTotalizer = 0.0;
  double? finalQty = 0.0;
  int DuConnectCounter = 0;
  int totCount = 0;
  String formattedVlueQty = "";
  ////////////////Pallab
  Future<void> checkTOT(int flag, TextEditingController controller) async {
    print('[api-test] login Check TOT clicked $flag');

    final String baseUrl1 = '$mainUrl/api/v1/du-totalizer-readings';
    final String baseUrl2 = '$mainUrl/api/v1/du-totalizer-readings';
    // Printing the base URL and the full URL with query parameters
    print('[api-test] CheckTOT url is $baseUrl1');
    print('[api-test] CheckTOT full URL with parameters is ${Uri.parse(baseUrl1).replace(queryParameters: {'flag': flag.toString()}).toString()}');

    try {
      final response = await http.get(Uri.parse(baseUrl1).replace(queryParameters: {'flag': flag.toString()}));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final responseData = jsonResponse['response'];
        print('[api-test] CheckTOT is $responseData');

        final double totalizerReading = responseData['totalizerReading'];
        print('[api-test] CheckTOT Totalizer Reading: $totalizerReading');

        // Update the relevant controller
        controller.text = totalizerReading.toStringAsFixed(2);
      } else {
        print('Failed to load data: ${response.statusCode}');
      }
    } catch (error) {
      print('An error occurred: $error');
    }
  }

  Future<void> setPreset(int flag, double? quantity) async {
    print('Set preset called $flag');
    final String baseUrl1 = '$mainUrl/api/v1/du-preset-data-volume';
    final String baseUrl2 = '$mainUrl/api/v1/du-preset-data-volume';

    print('value: ${flag}');
    print('Qty : $quantity');

    try {
      final response = await dio.post(
        baseUrl1,
        queryParameters: {'flag': flag},
        data: {'value': quantity},
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = response.data;
        final responseData = jsonResponse['response'];
        print('Set preset response: $responseData');

        final String description = responseData['description'];
        if (responseData != null) {
          startDispensing(flag);
        }
        setState(() {
          duStatus = description;
        });
      } else {
        print('Failed to set preset. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('An error occurred: $error');
    }
  }

////Actual code

  // Future<void> startDispensing(int flag) async {
  //   final String baseUrl1 = '$mainUrl/api/v1/du-start';
  //   final String baseUrl2 = '$mainUrl/api/v1/gvr-du-start';

  //   try {
  //     final response = await dio.post(
  //       baseUrl1,
  //       queryParameters: {'flag': flag},
  //     );

  //     if (response.statusCode == 200) {
  //       final Map<String, dynamic> jsonResponse = response.data;
  //       final responseData = jsonResponse['response'];
  //       final String description = responseData['description'];
  //       setState(() {
  //         duStatus = description;
  //       });
  //       print('Du Start response: $responseData');
  //     } else {
  //       print('Failed to set preset. Status code: ${response.statusCode}');
  //     }
  //   } catch (error) {
  //     print('An error occurred: $error');
  //   }
  // }


 Future<void> startDispensing(int flag) async {
  final String baseUrl1 = '$mainUrl/api/v1/du-start';
  final String baseUrl2 = '$mainUrl/api/v1/gvr-du-start';

  try {
    // Make both API calls simultaneously
    final responses = await Future.wait([
      dio.post(baseUrl1, queryParameters: {'flag': flag}),
      dio.post(baseUrl2, queryParameters: {'flag': flag}),
    ]);

    // Handle the responses
    for (var response in responses) {
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = response.data;
        final responseData = jsonResponse['response'];
        final String description = responseData['description'];
        
        // Update state for each response (this will overwrite for the second response)
        setState(() {
          duStatus = description;
        });
        print('Response from ${response.realUri}: $responseData');
      } else {
        print('Failed to call ${response.realUri}. Status code: ${response.statusCode}');
      }
    }
  } catch (error) {
    print('An error occurred: $error');
  }
}

  Future<void> stopDispensing(int flag) async {
    final String baseUrl1 = '$mainUrl/api/v1/du-stop';
    final String baseUrl2 = '$mainUrl/api/v1/du-stop';

    try {
      final response = await dio.post(
        baseUrl1,
        queryParameters: {'flag': flag},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = response.data;
        final responseData = jsonResponse['response'];
        final String description = responseData['description'];
        print('DU Stop response: $responseData');
        setState(() {
          duStatus = description;
        });
      } else {
        print('Failed to set preset. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('An error occurred: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final routineProvider = Provider.of<RoutinesProvider>(context);
    final vehicleDetailsProvider = Provider.of<VehicleReadingsProvider>(context);
    final loginProvider = Provider.of<LoginProvider>(context);
    final imageUploadProvider = Provider.of<ImageUploadProvider>(context);

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(actions: [
          const Center(child: Text('Logout')),
          IconButton(
              onPressed: () async {
                await loginProvider
                    .changeSessionStage(sessionStage: SessionStage.logout)
                    .whenComplete(() {
                  Navigator.of(context).pushNamed('/login');
                });
              },
              icon: const Icon(Icons.logout)),
          const SizedBox(width: 10),
        ]),
        body: Stack(
          children: [
            const CustomBackground(),
            SingleChildScrollView(
              child: Center(
                child: SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Center(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Card(
                                color: white500,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30)),
                                child: Padding(
                                  padding: const EdgeInsets.all(30),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const SizedBox(height: 10),
                                      const Center(
                                        child: Text(
                                          "Details",
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w900,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      routineProvider.routines.isNotEmpty &&
                                              routineProvider.planDetails !=
                                                  null &&
                                              routineProvider.vehicleDetails !=
                                                  null &&
                                              routineProvider.productDetails !=
                                                  null
                                          ? Column(
                                              children: [
                                                TitleContent(
                                                    isBold: true,
                                                    title: 'Vehicle Reg No',
                                                    content: routineProvider
                                                        .vehicleDetails!
                                                        .vehicleRegNo),
                                                TitleContent(
                                                    title: 'Make',
                                                    content: routineProvider
                                                        .vehicleDetails!.make),
                                                TitleContent(
                                                    title: 'Model',
                                                    content: routineProvider
                                                        .vehicleDetails!.model),
                                                TitleContent(
                                                    title: 'Tank Capacity',
                                                    content:
                                                        '${routineProvider.vehicleDetails!.tankCapacity} L'),
                                                TitleContent(
                                                    isBold: true,
                                                    title:
                                                        'Quantity Availaible',
                                                    content:
                                                        '${routineProvider.vehicleDetails!.availableQuantity.toStringAsFixed(2)} L'),
                                                const Divider(),
                                                TitleContent(
                                                    isBold: true,
                                                    title: 'Product',
                                                    content: routineProvider
                                                        .productDetails!.name),
                                                const Divider(),
                                                TitleContent(
                                                    isBold: true,
                                                    title: 'Date',
                                                    content: DateFormat(
                                                            'dd MMM, yyyy')
                                                        .format(routineProvider
                                                            .planDetails!
                                                            .startDateTime)),
                                                TitleContent(
                                                    isBold: true,
                                                    title: 'Report Time',
                                                    content: DateFormat(
                                                            'hh : mm aa')
                                                        .format(routineProvider
                                                            .planDetails!
                                                            .startDateTime)),
                                                TitleContent(
                                                    isBold: true,
                                                    title: 'Current Time',
                                                    content: DateFormat(
                                                            'hh : mm aa')
                                                        .format(
                                                            DateTime.now())),
                                                const SizedBox(height: 10),
                                                DateTime.now()
                                                            .difference(
                                                                routineProvider
                                                                    .planDetails!
                                                                    .startDateTime)
                                                            .inMinutes >=
                                                        0
                                                    ? Container(
                                                        decoration: BoxDecoration(
                                                            color: red500,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5)),
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                top: 5,
                                                                bottom: 5),
                                                        child: Center(
                                                          child: Text(
                                                            'You are ${DateTime.now().difference(routineProvider.planDetails!.startDateTime).inMinutes.toString()} mins late',
                                                            style:
                                                                const TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                          ),
                                                        ),
                                                      )
                                                    : Container(
                                                        decoration: BoxDecoration(
                                                            color: green500,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5)),
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                top: 5,
                                                                bottom: 5),
                                                        child: Center(
                                                          child: Text(
                                                            'You are ${DateTime.now().difference(routineProvider.planDetails!.startDateTime).inMinutes.toString().substring(1)} mins early',
                                                            style: const TextStyle(
                                                                color:
                                                                    secondary500),
                                                          ),
                                                        ),
                                                      ),
                                              ],
                                            )
                                          : const Center(
                                              child: Text('No Data Found')),
                                      const SizedBox(height: 10),
                                      CustomButton(
                                          onTap: () => getRoutineClickEvent(
                                              context,
                                              routineProvider,
                                              loginProvider,
                                              vehicleDetailsProvider),
                                          title: "Get Routines"),
                                      const SizedBox(height: 10),
                                      routineProvider.routines.isNotEmpty
                                          ? CustomButton(
                                              onTap: () => startTripClickEvent(
                                                  context,
                                                  vehicleDetailsProvider,
                                                  loginProvider,
                                                  imageUploadProvider),
                                              textColor: white500,
                                              backgroundColor: secondary500,
                                              splashColor: primary500,
                                              title: "Start Trip",
                                            )
                                          : const SizedBox.shrink(),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ///Actual code //
  // void startTripClickEvent(
  //     BuildContext context,
  //     VehicleReadingsProvider vehicleReadingsProvider,
  //     LoginProvider loginProvider,
  //     ImageUploadProvider imageUploadProvider) {
  //   vehicleReadingsProvider.vehicleReadings = VehicleReadings();
  //   showDialog(
  //     barrierDismissible: false,
  //     context: context,
  //     builder: (context) {
  //       return CustomAlertDialog(
  //         imageContent: 'Kindly upload the image of the odometer & totalizer',
  //         isOdometer: true,
  //         odometerController: odometerController,
  //         isTotalizer: true,
  //         isImage: true,
  //         onTapImage: (imageList) {
  //           debugPrint(imageList.length.toString());
  //           vehicleReadingsProvider.vehicleReadings?.imageDetailsList =
  //               imageList;
  //         },
  //         totalizerDuLeftController: totalizerDuLeftController,
  //         totalizerDuRightController: totalizerDuRightController,
  //         onTapSave: () async {
  //           final odometerReading =
  //               double.tryParse(odometerController.text.toString());
  //           final totalizerLeftReading =
  //               double.tryParse(odometerController.text.toString());
  //           final totalizerRightReading =
  //               double.tryParse(odometerController.text.toString());
  //           if (vehicleReadingsProvider
  //                   .vehicleReadings!.imageDetailsList.isNotEmpty &&
  //               odometerReading != null &&
  //               totalizerLeftReading != null &&
  //               totalizerRightReading != null) {
  //             vehicleReadingsProvider.vehicleReadings!.odometer =
  //                 odometerReading;
  //             vehicleReadingsProvider.vehicleReadings!.totalizeDuLeft =
  //                 totalizerLeftReading;
  //             vehicleReadingsProvider.vehicleReadings!.totalizeDuRight =
  //                 totalizerRightReading;
  //             bool isUploaded = false;
  //             for (ImageDetails imageDetails in vehicleReadingsProvider
  //                 .vehicleReadings!.imageDetailsList) {
  //               int? imageId =
  //                   await imageUploadProvider.eitherFailureOrUploadImage(
  //                       imagePath: imageDetails.imagePath!,
  //                       apiToken: loginProvider.userDetails!.apiToken!);
  //               if (imageId != null) {
  //                 imageDetails.imageId = imageId;
  //               } else {
  //                 isUploaded = false;
  //                 break;
  //               }
  //               isUploaded = true;
  //             }
  //             if (isUploaded) {
  //               await vehicleReadingsProvider
  //                   .eitherFailureOrPostVehicleDetails(
  //                       apiToken: loginProvider.userDetails!.apiToken!)
  //                   .then((value) {
  //                 loginProvider.changeSessionStage(
  //                     sessionStage: SessionStage.vehicleChecks);
  //                 navigateToNextScreen(context);
  //               });
  //             } else {
  //               showSnackBar(
  //                   context: context, message: 'Error in uploading data');
  //             }
  //           } else {
  //             showSnackBar(
  //                 context: context, message: 'All fields are mandatory');
  //           }
  //         },
  //         onTapCancel: () => Navigator.of(context).pop(),
  //       );
  //     },
  //   );
  // }

  ///Changes made here//Amita
//  // final Dio dio = Dio();

Future<String?> getPlanId() async {
  try {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? planId = prefs.getString('planId'); // Fetch and store the value
    print('[api-test] getPlanId planId: $planId');
    return planId; // Return the fetched ID
  } catch (e) {
    print('[api-test] SharedPreferences error: $e');
    return null; // Return null in case of an error
  }
}


  void startTripClickEvent(
      BuildContext context,
      VehicleReadingsProvider vehicleReadingsProvider,
      LoginProvider loginProvider,
      ImageUploadProvider imageUploadProvider) async {
        print('[api-test] startTripClickEvent called--');
        print('[api-test]   plan id popup : ${vehicleReadingsProvider?.vehicleReadings?.referenceId}');

    await checkTOT(1, totalizerDuLeftController);
    await checkTOT(2, totalizerDuRightController);
    vehicleReadingsProvider.vehicleReadings = VehicleReadings();
    // ignore: use_build_context_synchronously
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return CustomAlertDialog(
          imageContent: 'Kindly upload the image of the odometer & totalizer',
          isOdometer: true,
          odometerController: odometerController,
          isTotalizer: true,
          isImage: true,
          onTapImage: (imageList) {
            debugPrint(imageList.length.toString());
            vehicleReadingsProvider.vehicleReadings?.imageDetailsList =
                imageList;
          },
          totalizerDuLeftController: totalizerDuLeftController,
          totalizerDuRightController: totalizerDuRightController,
          onTapSave: () async {

            final odometerReading = double.tryParse(odometerController.text.toString());
            final totalizerLeftReading = double.tryParse(odometerController.text.toString());
            final totalizerRightReading = double.tryParse(odometerController.text.toString());

            if (vehicleReadingsProvider.vehicleReadings!.imageDetailsList.isNotEmpty &&  
                odometerReading != null &&
                totalizerLeftReading != null &&
                totalizerRightReading != null) {

              String? planId = await getPlanId(); 

              vehicleReadingsProvider.vehicleReadings!.odometer = odometerReading;
              vehicleReadingsProvider.vehicleReadings!.totalizeDuLeft = totalizerLeftReading;
              vehicleReadingsProvider.vehicleReadings!.totalizeDuRight = totalizerRightReading;
              // vehicleReadingsProvider.vehicleReadings!.referenceType =  "route-plan-details";
              vehicleReadingsProvider.vehicleReadings!.referenceType =  "route-plan";

              if (planId != null) {
                vehicleReadingsProvider.vehicleReadings!.referenceId = planId;
              }

              bool isUploaded = false;

              for (ImageDetails imageDetails in vehicleReadingsProvider.vehicleReadings!.imageDetailsList) {
                int? imageId = await imageUploadProvider.eitherFailureOrUploadImage(
                        imagePath: imageDetails.imagePath!,
                        apiToken: loginProvider.userDetails!.apiToken!);
                if (imageId != null) {
                  imageDetails.imageId = imageId;
                } else {
                  isUploaded = false;
                  break;
                }
                isUploaded = true;
              }
              if (isUploaded) {
                await vehicleReadingsProvider.eitherFailureOrPostVehicleDetails(
                        apiToken: loginProvider.userDetails!.apiToken!)
                    .then((value) {
                  loginProvider.changeSessionStage(
                      sessionStage: SessionStage.vehicleChecks);
                  navigateToNextScreen(context);
                });
              } else {
                // ignore: use_build_context_synchronously
                showSnackBar(
                    context: context, message: 'Error in uploading data');
              }
            } else {
              showSnackBar(
                  context: context, message: 'All fields are mandatory');
            }
          },
          onTapCancel: () => Navigator.of(context).pop(),
        );
      },
    );
  }

  void getRoutineClickEvent(
      BuildContext context,
      RoutinesProvider routineProvider,
      LoginProvider loginProvider,
      VehicleReadingsProvider vehicleDetailsProvider) async {
    debugPrint(loginProvider.userDetails.toString());
    final isSuccess = await routineProvider.eitherFailureOrGetRoutines(
        apiToken: loginProvider.userDetails!.apiToken!);
    print('login data $isSuccess');
    if (!isSuccess) {
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (context) => FailureDialog(
            content: routineProvider.failure!.errorMessage!.toString()),
      );
    }
  }

  void navigateToNextScreen(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const VehicleChecksScreen(),
    ));
  }
}
