import 'package:flutter/material.dart';
import '../../../../utils/utils_export.dart';
import '../../data/models/routine.dart';

class RoutineCardOld extends StatelessWidget {
  final VoidCallback onTap;
  final Routine routine;

  const RoutineCardOld({Key? key, required this.routine, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => onTap(),
      style: ListTileStyle.list,
      horizontalTitleGap: 10,
      contentPadding: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
      title: Text(routine.status.toString()),
      subtitle: Text(routine.name),
      trailing: Text("${routine.quantity.toString()} L"),
      leading: routine.type == "delivery"
          ? const ImageIcon(AssetImage("$imagesPath/icons/orders.png"))
          : const ImageIcon(
              AssetImage("$imagesPath/icons/dispenser_checks.png")),
    );
  }
}
