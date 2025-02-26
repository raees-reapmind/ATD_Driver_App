import 'package:atd/features/dispenser_checks_feature/display/pages/dispenser_checks_screen.dart';
import 'package:atd/features/home_navigation_feature/display/pages/home_screen.dart';
import 'package:atd/features/login_feature/display/pages/login_details_screen.dart';
import 'package:atd/features/login_feature/display/pages/login_screen.dart';
import 'package:atd/features/login_feature/display/provider/login_provider.dart';
import 'package:atd/features/routine_feature/display/pages/dashboard_screen.dart';
import 'package:atd/features/routine_feature/display/providers/routines_provider.dart';
import 'package:atd/features/vehicle_checks_feature/display/pages/vehicle_checks_screen.dart';
import 'package:atd/features/vehicle_checks_feature/display/provider/vehicle_checks_provider.dart';
import 'package:atd/utils/utils_export.dart';
import 'package:flutter/material.dart';
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
              loginProvider, vehicleChecksProvider, routinesProvider, context),
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
                                color: Colors.white),
                          ),
                          const Text(
                            "WE DELIVER",
                            style: TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 30,
                                color: Colors.white),
                          ),
                          const Spacer(),
                          const Align(
                            alignment: AlignmentDirectional.centerEnd,
                            child: Text(
                              "Driver Application",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  color: secondary500),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }
          }),
    );
  }

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
