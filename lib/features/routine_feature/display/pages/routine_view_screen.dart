import 'package:atd/features/dispenser_feature/display/pages/auto_dispenser/dispenser_screen.dart';
import 'package:atd/features/routine_feature/display/providers/routines_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../utils/utils_export.dart';
import '../../data/models/routine.dart';

class RoutineViewScreen extends StatelessWidget {
  final Routine routine;
  final int index;

  const RoutineViewScreen(
      {Key? key, required this.routine, required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final routineProvider = Provider.of<RoutinesProvider>(context);
    return Scaffold(
      body: Stack(
        children: [
          const CustomBackground(),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Card(
                  color: white500,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  child: Padding(
                    padding: const EdgeInsets.all(30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 10),
                        Center(
                          child: Text(
                            "${routine.status} Details",
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text("Name",
                                  style:
                                      Theme.of(context).textTheme.titleMedium),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(routine.name,
                                  textAlign: TextAlign.right,
                                  style: Theme.of(context).textTheme.subtitle2),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text("Quantity",
                                  style:
                                      Theme.of(context).textTheme.titleMedium),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text("${routine.quantity}L",
                                  textAlign: TextAlign.right,
                                  style: Theme.of(context).textTheme.subtitle2),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text("Address",
                                  style:
                                      Theme.of(context).textTheme.titleMedium),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(routine.address,
                                  textAlign: TextAlign.right,
                                  style: Theme.of(context).textTheme.subtitle2),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text("Price",
                                  style:
                                      Theme.of(context).textTheme.titleMedium),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text("₹ ${routine.price.toString()}",
                                  textAlign: TextAlign.right,
                                  style: Theme.of(context).textTheme.subtitle2),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Row(
                          children: [
                            Expanded(
                                child: CustomButton(
                                    onTap: () => deliverClickEvent(
                                        routine: routine, context: context),
                                    title: "Deliver")),
                            const SizedBox(width: 10),
                            IconButton(
                                onPressed: () => openMapEvent(
                                    lat: routine.latitude,
                                    lng: routine.longitude),
                                icon: const Icon(Icons.location_on_rounded))
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void openMapEvent({required double lat, required double lng}) async {
    //final Uri uri = Uri.parse('https://maps.google.com/maps?q=$lat,$lng');
    // BackgroundService().startService();
    final Uri uri = Uri.parse("google.navigation:q=$lat,$lng&mode=d");
    // locationService();
    try {
      await launchUrl(uri);
    } catch (e) {
      debugPrint('Could not open the map : ${e.toString()}');
    }
  }

  void locationService() async {
    // await LocationService().determinePosition().then((position) async {
    //   // debugPrint("${DateFormat("yyyy-MM-dd hh:mm:ss").format(DateTime.now())} $position");
    //   BackgroundService().sendLocation(position);
    //   await Future.delayed(
    //       const Duration(seconds: 10), () => locationService());
    // });
  }

  void deliverClickEvent(
      {required Routine routine, required BuildContext context}) async {
    // await BackgroundService().stopService().whenComplete(() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => DispenserScreen(routine: routine),
    ));
    // });
  }
}
