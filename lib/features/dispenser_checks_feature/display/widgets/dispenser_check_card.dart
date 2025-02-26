import 'package:atd/features/routine_feature/display/widgets/title_content.dart';
import 'package:flutter/material.dart';

import '../../data/models/dispenser_check.dart';

class DispenserCheckCard extends StatelessWidget {
  final DispenserCheck dispenserCheck;
  const DispenserCheckCard({Key? key, required this.dispenserCheck})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TitleContent(title: 'From', content: dispenserCheck.dispensedFrom),
          TitleContent(title: 'To', content: dispenserCheck.dispensedTo),
          TitleContent(
              title: 'Selected',
              content: dispenserCheck.quantitySelected.toString()),
          TitleContent(
            title: 'Dispensed',
            content: dispenserCheck.quantityDispensed.toString(),
            isBold: true,
          ),
          TitleContent(
            title: 'Images Attached',
            content: dispenserCheck.imageList!.length.toString(),
            isBold: true,
          ),
          const Divider(),
        ],
      ),
    );
  }
}
