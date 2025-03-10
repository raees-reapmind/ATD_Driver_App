import 'package:atd/features/dispenser_checks_feature/display/pages/dispenser_checks_screen.dart';
import 'package:atd/features/home_navigation_feature/display/pages/home_screen.dart';
import 'package:atd/features/login_feature/data/models/session_stage.dart';
import 'package:atd/features/login_feature/display/provider/login_provider.dart';
import 'package:atd/features/vehicle_checks_feature/display/provider/vehicle_checks_provider.dart';
import 'package:atd/features/vehicle_checks_feature/domain/entities/vehicle_check.dart';
import 'package:atd/utils/utils_export.dart';
import 'package:atd/utils/widgets/failure_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VehicleChecksScreen extends StatelessWidget {
  const VehicleChecksScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final vehicleChecksProvider = Provider.of<VehicleChecksProvider>(context);
    final loginProvider = Provider.of<LoginProvider>(context);
    
    return Scaffold(
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
          SafeArea(
            child: Center(
              child: Card(
                margin: const EdgeInsets.all(20),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      const Center(
                        child: Text(
                          "Vehicle Checks",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      vehicleChecksProvider.vehicleCheckList != null
                          ? Expanded(
                              child: ListView.builder(
                                physics: const BouncingScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: vehicleChecksProvider.vehicleCheckList!.length,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    title: Text(vehicleChecksProvider.vehicleCheckList![index].name),
                                    trailing: FittedBox(
                                      child: Row(
                                        children: [
                                          Radio(
                                            fillColor:
                                                MaterialStateColor.resolveWith(
                                                    (states) => green500),
                                            activeColor: green500,
                                            value: true,
                                            groupValue: vehicleChecksProvider.vehicleCheckList![index].status == 1
                                                ? true
                                                : false,
                                            onChanged: (value) {
                                              if (value != null) {
                                                value
                                                    ? vehicleChecksProvider.setStatus(index: index,status: 1)
                                                    : vehicleChecksProvider.setStatus(index: index,status: 0);
                                              }
                                            },
                                          ),
                                          Radio(
                                            fillColor:
                                                MaterialStateColor.resolveWith(
                                                    (states) => yellow500),
                                            activeColor: yellow500,
                                            value: true,
                                            groupValue: vehicleChecksProvider.vehicleCheckList![index].status == 2,
                                            onChanged: (value) {
                                              if (value != null) {
                                                value
                                                    ? vehicleChecksProvider.setStatus(index: index, status: 2)
                                                    : vehicleChecksProvider.setStatus(index: index, status: 0);
                                              }
                                            },
                                          ),
                                          Radio(
                                            fillColor:
                                                MaterialStateColor.resolveWith(
                                                    (states) => red500),
                                            activeColor: red500,
                                            value: true,
                                            groupValue: vehicleChecksProvider.vehicleCheckList![index].status == 3,
                                            onChanged: (value) {
                                              if (value != null) {
                                                value
                                                    ? vehicleChecksProvider.setStatus(index: index, status: 3)
                                                    : vehicleChecksProvider.setStatus(index: index, status: 0);
                                              }
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            )
                          : Column(
                              children: [
                                const Center(
                                  child: Text('No Vehicle Checks Found'),
                                ),
                                CustomButton(
                                    onTap: () => getVehicleChecksClickEvent(
                                        context,
                                        loginProvider,
                                        vehicleChecksProvider),
                                    title: 'Get Vehicle Checks')
                              ],
                            ),
                      const SizedBox(height: 5),
                      vehicleChecksProvider.message != null
                          ? Text(vehicleChecksProvider.message!)
                          : const SizedBox.shrink(),
                      const SizedBox(height: 5),
                      vehicleChecksProvider.vehicleCheckList != null
                          ? CustomButton(
                              splashColor: primary500,
                              backgroundColor: secondary500,
                              textColor: white500,
                              onTap: () => saveClickEvent(vehicleChecksProvider,
                                  loginProvider, context),
                              title: "Save")
                          : const SizedBox.shrink(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void saveClickEvent(VehicleChecksProvider vehicleChecksProvider,
      LoginProvider loginProvider, BuildContext context) async {

    bool isChecked = true;
    for (VehicleCheck vehicleCheck
        in vehicleChecksProvider.vehicleCheckList ?? []) {
      if (vehicleCheck.status == 0) {
        isChecked = false;
        showSnackBar(context: context, message: 'All checks are mandatory');
        break;
      }
    }
    if (isChecked) {
      await vehicleChecksProvider
          .eitherFailureOrSetVehicleChecks(
              apiToken: loginProvider.userDetails!.apiToken!)
          .then((isSuccess) {
        if (isSuccess) {
          loginProvider.changeSessionStage(
              sessionStage: SessionStage.dispenserChecks);
          // vehicleChecksProvider.clearVehicleChecks();
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const DispenserChecksScreen(),
          ));
        } else {
          showDialog(
            context: context,
            builder: (context) => FailureDialog(
                content:
                    vehicleChecksProvider.failure!.errorMessage.toString()),
          );
        }
      });
    } else {
      vehicleChecksProvider.message = 'All Checks are mandatory';
    }
  }

  void getVehicleChecksClickEvent(
      BuildContext context,
      LoginProvider loginProvider,
      VehicleChecksProvider vehicleChecksProvider) async {
    await vehicleChecksProvider.eitherFailureOrGetVehicleChecks(
        apiToken: loginProvider.userDetails!.apiToken!);
  }
}
