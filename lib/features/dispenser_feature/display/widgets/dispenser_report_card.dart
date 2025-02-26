import 'package:flutter/material.dart';
import '../../domain/entities/dispenser_report.dart';

class DispenserReportCard extends StatelessWidget {
  final DispenserReport dispenserReport;
  const DispenserReportCard({Key? key, required this.dispenserReport}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 5, bottom: 5),
            child: Text(
              "Dispenser Report",
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Dispenser",
                  style: Theme.of(context).textTheme.titleMedium),
              Text(
                dispenserReport.dispenserName,
                style: Theme.of(context).textTheme.subtitle2,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Asset",
                  style: Theme.of(context).textTheme.titleMedium),
              Text(
                dispenserReport.assetId.toString(),
                style: Theme.of(context).textTheme.subtitle2,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Quantity Selected",
                  style: Theme.of(context).textTheme.titleMedium),
              Text(
                "${dispenserReport.quantitySelected.toString()} L",
                style: Theme.of(context).textTheme.subtitle2,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Quantity Dispensed",
                  style: Theme.of(context).textTheme.titleMedium),
              Text(
                "${dispenserReport.quantityDispensed.toString()} L",
                style: Theme.of(context).textTheme.subtitle2,
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Divider(),
        ],
      ),
    );
  }
}
