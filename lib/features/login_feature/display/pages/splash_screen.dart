// import 'package:atd/features/dispenser_checks_feature/display/pages/dispenser_checks_screen.dart';
// import 'package:atd/features/home_navigation_feature/display/pages/home_screen.dart';
// import 'package:atd/features/login_feature/display/pages/login_details_screen.dart';
// import 'package:atd/features/login_feature/display/pages/login_screen.dart';
// import 'package:atd/features/login_feature/display/provider/login_provider.dart';
// import 'package:atd/features/routine_feature/display/pages/dashboard_screen.dart';
// import 'package:atd/features/routine_feature/display/providers/routines_provider.dart';
// import 'package:atd/features/vehicle_checks_feature/display/pages/vehicle_checks_screen.dart';
// import 'package:atd/features/vehicle_checks_feature/display/provider/vehicle_checks_provider.dart';
// import 'package:atd/utils/utils_export.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// import '../../data/models/session_stage.dart';

// class SplashScreen extends StatelessWidget {
//   const SplashScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final loginProvider = Provider.of<LoginProvider>(context);
//     final vehicleChecksProvider = Provider.of<VehicleChecksProvider>(context);
//     final routinesProvider = Provider.of<RoutinesProvider>(context);
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: FutureBuilder(
//           future: navigateUser(
//               loginProvider, vehicleChecksProvider, routinesProvider, context),
//           builder: (context, snapshot) {
//             if (snapshot.hasData && snapshot.data != null) {
//               return snapshot.data!;
//             } else {
//               return Stack(
//                 children: [
//                   const CustomBackground(),
//                   SafeArea(
//                     child: Padding(
//                       padding: const EdgeInsets.all(20),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Align(
//                             alignment: AlignmentDirectional.centerEnd,
//                             child: Image.asset(
//                               "$imagesPath/atd_logo_dark.png",
//                               width: 100,
//                             ),
//                           ),
//                           const SizedBox(height: 50),
//                           const Text(
//                             "YOU ORDER",
//                             style: TextStyle(
//                                 fontWeight: FontWeight.w900,
//                                 fontSize: 20,
//                                 color: Colors.white),
//                           ),
//                           const Text(
//                             "WE DELIVER",
//                             style: TextStyle(
//                                 fontWeight: FontWeight.w900,
//                                 fontSize: 30,
//                                 color: Colors.white),
//                           ),
//                           const Spacer(),
//                           const Align(
//                             alignment: AlignmentDirectional.centerEnd,
//                             child: Text(
//                               "Driver Application",
//                               style: TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 12,
//                                   color: secondary500),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               );
//             }
//           }),
//     );
//   }

//   Future<Widget> navigateUser(
//       LoginProvider loginProvider,
//       VehicleChecksProvider vehicleChecksProvider,
//       RoutinesProvider routinesProvider,
//       BuildContext context) async {
//     await loginProvider.checkUserDataIsValid();
//     if (loginProvider.userDetails != null && loginProvider.failure == null) {
//       switch (loginProvider.userDetails!.sessionStage) {
//         case SessionStage.login:
//           return const LoginScreen();
//         case SessionStage.loginDetails:
//           return const LoginDetailsScreen();
//         case SessionStage.vehicleChecks:
//           return const VehicleChecksScreen();
//         case SessionStage.dispenserChecks:
//           return const DispenserChecksScreen();
//         case SessionStage.dashboard:
//           return const HomeScreen();
//         case SessionStage.logout:
//           return const LoginScreen();
//       }
//     } else {
//       return const LoginScreen();
//     }
//   }
// }

// ignore_for_file: null_argument_to_non_null_type

import 'package:atd/features/dispenser_checks_feature/display/pages/dispenser_checks_screen.dart';
import 'package:atd/features/home_navigation_feature/display/pages/home_screen.dart';
import 'package:atd/features/login_feature/display/pages/login_details_screen.dart';
import 'package:atd/features/login_feature/display/pages/login_screen.dart';
import 'package:atd/features/login_feature/display/provider/login_provider.dart';
import 'package:atd/features/routine_feature/display/pages/dashboard_screen.dart';
import 'package:atd/features/routine_feature/display/providers/routines_provider.dart';
import 'package:atd/features/vehicle_checks_feature/display/pages/vehicle_checks_screen.dart';
import 'package:atd/features/vehicle_checks_feature/display/provider/vehicle_checks_provider.dart';
import 'package:atd/utils/constants.dart';
import 'package:atd/utils/utils_export.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

import '../../data/models/session_stage.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loginProvider = Provider.of<LoginProvider>(context);
    final vehicleChecksProvider = Provider.of<VehicleChecksProvider>(context);
    final routinesProvider = Provider.of<RoutinesProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder(
        future: navigateUser(
          loginProvider,
          vehicleChecksProvider,
          routinesProvider,
          context,
        ),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            return snapshot.data!;
          } else {
            return Stack(
              children: [
                const CustomBackground(),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                          alignment: AlignmentDirectional.centerEnd,
                          child: Image.asset(
                            "$imagesPath/atd_logo_dark.png",
                            width: 100,
                          ),
                        ),
                        const SizedBox(height: 50),
                        const Text(
                          "YOU ORDER",
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                        const Text(
                          "WE DELIVER",
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 30,
                            color: Colors.white,
                          ),
                        ),
                        const Spacer(),
                        const Align(
                          alignment: AlignmentDirectional.centerEnd,
                          child: Text(
                            "Driver Application",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              color: secondary500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  // Future<Widget> navigateUser(
  //   LoginProvider loginProvider,
  //   VehicleChecksProvider vehicleChecksProvider,
  //   RoutinesProvider routinesProvider,
  //   BuildContext context,
  // ) async {
  //   await Future.delayed(
  //       const Duration(milliseconds: 300)); // Reduced splash delay

  //   // Step 1: Check location permission
  //   var status = await Permission.location.status;
  //   if (!status.isGranted) {
  //     status = await Permission.location.request();
  //   }

  //   // Step 2: If granted, try to get location with timeout
  //   if (status.isGranted) {
  //     bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //     if (!serviceEnabled) {
  //       // 🚨 Show toast and redirect
  //       Fluttertoast.showToast(
  //         msg: "Location is turned off. Please enable GPS.",
  //         toastLength: Toast.LENGTH_LONG,
  //         gravity: ToastGravity.CENTER,
  //         backgroundColor: Colors.black87,
  //         textColor: Colors.white,
  //       );
  //       await Geolocator.getCurrentPosition(); // Open device's GPS settings
  //       return const LoginScreen(); // fallback
  //     }
  //     try {
  //       await Geolocator.getCurrentPosition(
  //         desiredAccuracy: LocationAccuracy.high,
  //       ).timeout(
  //         const Duration(seconds: 10),
  //         onTimeout: () {
  //           // debugPrint("Location fetch timed out");
  //           // return Future.value(null);
  //           debugPrint("Location fetch timed out");
  //           throw Exception("Location fetch timed out");
  //         },
  //       );
  //     } catch (e) {
  //       debugPrint("Location fetch error: $e");
  //     }
  //   } else if (status.isPermanentlyDenied) {
  //     await openAppSettings();
  //     return const LoginScreen();
  //   } else {
  //     debugPrint("Permission denied temporarily.");
  //     return const LoginScreen();
  //   }
  //   // bool permission = await Geolocator.isLocationServiceEnabled();
  //   // if (!permission) {
  //   //   hideLoading();
  //   //   _showLocationServiceRequiredDialog();
  //   //   return const LoginScreen();
  //   // }
  //   // Step 3: Check user session and route
  //   await loginProvider.checkUserDataIsValid();

  //   if (loginProvider.userDetails != null && loginProvider.failure == null) {
  //     switch (loginProvider.userDetails!.sessionStage) {
  //       case SessionStage.login:
  //         return const LoginScreen();
  //       case SessionStage.loginDetails:
  //         return const LoginDetailsScreen();
  //       case SessionStage.vehicleChecks:
  //         return const VehicleChecksScreen();
  //       case SessionStage.dispenserChecks:
  //         return const DispenserChecksScreen();
  //       case SessionStage.dashboard:
  //         return const HomeScreen();
  //       case SessionStage.logout:
  //         return const LoginScreen();
  //     }
  //   }

  //   return const LoginScreen(); // fallback
  // }

    Future<Widget> navigateUser(
      LoginProvider loginProvider,
      VehicleChecksProvider vehicleChecksProvider,
      RoutinesProvider routinesProvider,
      BuildContext context) async {
    await loginProvider.checkUserDataIsValid();
    if (loginProvider.userDetails != null && loginProvider.failure == null) {
      switch (loginProvider.userDetails!.sessionStage) {
        case SessionStage.login:
          return const LoginScreen();
        case SessionStage.loginDetails:
          return const LoginDetailsScreen();
        case SessionStage.vehicleChecks:
          return const VehicleChecksScreen();
        case SessionStage.dispenserChecks:
          return const DispenserChecksScreen();
        case SessionStage.dashboard:
          return const HomeScreen();
        case SessionStage.logout:
          return const LoginScreen();
      }
    } else {
      return const LoginScreen();
    }
  }

}

