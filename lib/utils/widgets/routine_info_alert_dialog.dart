import 'package:atd/features/routine_feature/data/models/routine.dart';
import 'package:atd/features/routine_feature/display/widgets/title_content.dart';
import 'package:atd/utils/utils_export.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RoutineInfoAlertDialog extends StatelessWidget {
  final VoidCallback onTapCancel;
  final Routine routine;
  const RoutineInfoAlertDialog(
      {Key? key, required this.routine, required this.onTapCancel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actions: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: CustomButton(
            onTap: () => onTapCancel(),
            title: "Cancel",
          ),
        ),
      ],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          // ignore: prefer_const_literals_to_create_immutables
          children: [
            const SizedBox(height: 10),
            const Center(
              child: Text(
                'Summary',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            const SizedBox(height: 20),
            TitleContent(title: 'Name', content: routine.name.toString()),
            TitleContent(title: 'Address', content: routine.address.toString()),
            TitleContent(
                title: 'Latitude', content: routine.latitude.toString()),
            TitleContent(
                title: 'Longitude', content: routine.latitude.toString()),
            TitleContent(
                title: 'End Latitude', content: routine.endLatitude.toString()),
            TitleContent(
                title: 'End Longitude',
                content: routine.endLongitude.toString()),
            TitleContent(
                title: 'Odometer', content: routine.odometerReading.toString()),
            TitleContent(
                title: 'DU Left Start',
                content: routine.startTotalizerDuLeft.toString()),
            TitleContent(
                title: 'DU Left End',
                content: routine.endTotalizerDuLeft.toString()),
            TitleContent(
                title: 'DU Right Start',
                content: routine.startTotalizerDuRight.toString()),
            TitleContent(
                title: 'DU Right End',
                content: routine.endTotalizerDuRight.toString()),
            TitleContent(
                title: 'Quantity', content: routine.quantity.toString()),
            TitleContent(
                title: 'End Quanity', content: routine.endQuantity.toString()),
            TitleContent(
                title: 'Arrived Date Time',
                content: DateFormat('dd-MM hh:mm a')
                    .format(routine.arrivedDatetime!)
                    .toString()),
            ListView.builder(
              itemCount: routine.assetsReport.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return TitleContent(
                    title: routine.assetsReport[index].name,
                    content:
                        routine.assetsReport[index].endQuantity.toString());
              },
            )
          ],
        ),
      ),
    );
  }
}
