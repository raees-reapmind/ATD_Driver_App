import 'package:atd/features/dispenser_feature/display/pages/manual_dispenser/create_manual_dispenser_screen.dart';
import 'package:atd/utils/utils_export.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/dispenser_report_provider.dart';

class ManualDispenserScreen extends StatelessWidget {
  const ManualDispenserScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dispenserReportProvider =
        Provider.of<DispenserReportsProvider>(context);

    return Scaffold(
      body: Stack(
        children: [
          const CustomBackground(),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Card(
                  color: Colors.white,
                  shape:
                      RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  child: Padding(
                    padding: const EdgeInsets.all(30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 10),
                        const Center(
                          child: Text(
                            "Dispenser Report",
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
                            itemCount:
                                dispenserReportProvider.dispenserReports.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: DispenserReportCard(
                                  dispenserReport: dispenserReportProvider
                                      .dispenserReports[index],
                                ),
                              );
                            },
                          ),
                        ),
                        Align(
                          alignment: AlignmentDirectional.centerEnd,
                          child: FloatingActionButton(
                            onPressed: () => navigateToCreateManualEntry(context),
                            child: const Icon(Icons.add),
                          ),
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

  void navigateToCreateManualEntry(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const CreateManualDispenser(),));
  }
}
