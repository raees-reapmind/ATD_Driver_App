import 'package:atd/features/routine_feature/display/pages/routine_view_screen.dart';
import 'package:atd/features/routine_feature/display/providers/routines_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/routine.dart';
import '../widgets/routine_card.dart';

class RoutinePage extends StatelessWidget {
  const RoutinePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final routineProvider = Provider.of<RoutinesProvider>(context);
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 10),
              const Center(
                child: Text(
                  "Routine",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: routineProvider.routines.length,
                  itemBuilder: (context, index) {
                    return RoutineCardOld(
                      routine: routineProvider.routines[index],
                      onTap: () => routineClickEvent(
                          context, routineProvider.routines[index], index),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void routineClickEvent(BuildContext context, Routine routine, int index) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => RoutineViewScreen(routine: routine, index: index),
    ));
  }
}
