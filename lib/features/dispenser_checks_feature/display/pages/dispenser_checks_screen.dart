import 'package:atd/features/home_navigation_feature/display/pages/home_screen.dart';
import 'package:atd/features/login_feature/data/models/session_stage.dart';
import 'package:atd/features/login_feature/display/provider/login_provider.dart';
import 'package:atd/features/routine_feature/display/providers/routines_provider.dart';
import 'package:atd/features/vehicle_readings_feature/display/providers/vehicle_details_provider.dart';
import 'package:atd/utils/utils_export.dart';
import 'package:atd/utils/widgets/failure_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/dispenser_checks_provider.dart';
import 'create_dispenser_check_screen.dart';

class DispenserChecksScreen extends StatefulWidget {
  const DispenserChecksScreen({Key? key}) : super(key: key);

  @override
  State<DispenserChecksScreen> createState() => _DispenserChecksScreenState();
}

class _DispenserChecksScreenState extends State<DispenserChecksScreen> {


  @override
  void initState() {
    super.initState();
       WidgetsBinding.instance.addPostFrameCallback((_) {
      final routineProvider = Provider.of<RoutinesProvider>(context, listen: false);
      final loginProvider = Provider.of<LoginProvider>(context, listen: false);
      final vehicleDetailsProvider = Provider.of<VehicleReadingsProvider>(context, listen: false);

      getRoutineClickEvent(context, routineProvider, loginProvider, vehicleDetailsProvider);
    });
  }



  @override
  Widget build(BuildContext context) {
    final dispenserChecksProvider = Provider.of<DispenserChecksProvider>(context);
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
            child: Card(
              margin: const EdgeInsets.all(20),
              color: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 10),
                    const Center(
                      child: Text(
                        "Dispenser Checks",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Divider(),
                    Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        padding: const EdgeInsets.only(bottom: 10),
                        physics: const BouncingScrollPhysics(),
                        itemCount: dispenserChecksProvider.dispenserChecksList.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: DispenserCheckCard(
                                dispenserCheck: dispenserChecksProvider.dispenserChecksList[index]),
                          );
                        },
                      ),
                    ),
                    dispenserChecksProvider.message != null
                        ? Center(
                            child: Padding(
                            padding: const EdgeInsets.all(5),
                            child: Text(dispenserChecksProvider.message!),
                          ))
                        : const SizedBox.shrink(),
                    Row(
                      children: [
                        Expanded(
                            child: CustomButton(
                                onTap: () => saveClickEvent(loginProvider,
                                    dispenserChecksProvider, context),
                                title: 'Save')),
                        const SizedBox(width: 10),
                        FloatingActionButton(
                          onPressed: () =>
                              navigateToCreateDispenserCheck(context),
                          child: const Icon(Icons.add,color: Colors.white  ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
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
    debugPrint('login data $isSuccess');
    if (!isSuccess) {
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (context) => FailureDialog(
            content: routineProvider.failure!.errorMessage!.toString()),
      );
    }

  }


  void navigateToCreateDispenserCheck(BuildContext context) {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const CreateDispenserCheck()));
  }

  void saveClickEvent(
      LoginProvider loginProvider,
      DispenserChecksProvider dispenserChecksProvider,
      BuildContext context) async {
    await dispenserChecksProvider
        .eitherFailureOrSetDispenserChecks(
            apiToken: loginProvider.userDetails!.apiToken!)
        .then((isSuccess) {
      if (isSuccess) {
        loginProvider.changeSessionStage(sessionStage: SessionStage.dashboard);
        // updateUserStep(4);
       debugPrint('updateUserStep: $updateUserStep');
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => const HomeScreen()));
        dispenserChecksProvider.clearDispenserChecksList();
      } else {
        showDialog( context: context, builder: (context) => FailureDialog(content:dispenserChecksProvider.failure!.errorMessage.toString()));
      }
    });
  }
}
