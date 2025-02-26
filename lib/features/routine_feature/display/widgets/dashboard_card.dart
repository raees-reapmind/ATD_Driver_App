import 'package:atd/utils/utils_export.dart';
import 'package:atd/utils/widgets/custom_dashboard_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/routines_provider.dart';

class DashboardCard extends StatelessWidget {
  const DashboardCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final routineProvider = Provider.of<RoutinesProvider>(context);
    return Card(
      color: white300,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            Center(
              child: Text(
                "Dashboard",
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: CustomDashboardCard(
                    title: "Quantity\nAvailable",
                    content: routineProvider.vehicleDetails != null
                        ? '${routineProvider.vehicleDetails!.availableQuantity.toStringAsFixed(2)} L'
                        : '1000.0 L',
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: CustomDashboardCard(
                    title: "Delivered\nQuantity",
                    content:
                        '${routineProvider.totalDeliverdQuantity.toStringAsFixed(2)} L',
                  ),
                ),
                const SizedBox(width: 8),
                routineProvider.planDetails != null
                    ? Expanded(
                        child: CustomDashboardCard(
                          title: "Duration",
                          content:
                              '${DateTime.now().difference(routineProvider.planDetails!.startDateTime).inHours.toString()} hrs',
                        ),
                      )
                    : const Expanded(
                        child: CustomDashboardCard(
                          title: "Duration",
                          content: '0 mins',
                        ),
                      ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: CustomDashboardCard(
                    title: "Orders\nDelivered",
                    content: routineProvider.ordersDelivered.toString(),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: CustomDashboardCard(
                    title: "Orders\nPending",
                    content: routineProvider.ordersPending.toString(),
                  ),
                ),
                const SizedBox(width: 8),
                const Expanded(
                  child: CustomDashboardCard(
                    title: "Distance Travelled",
                    content: "120 KM",
                  ),
                ),
              ],
            ),
            /* const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                  color: red500, borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.only(top: 5, bottom: 5),
              child: const Center(
                  child: Text(
                'Running late by 25 mins',
                style: TextStyle(color: Colors.white),
              )),
            ), */
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
