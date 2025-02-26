import 'package:atd/features/routine_feature/display/pages/refill/refill_summary_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../utils/utils_export.dart';
import '../../providers/routines_provider.dart';
import '../../widgets/title_content.dart';
import '../refill/create_bill_screen.dart';

class RefillScreen extends StatelessWidget {
  final int index;

  const RefillScreen({Key? key, required this.index}) : super(key: key);

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
                child: Column(
                  children: [
                    Card(
                      color: white500,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 20, right: 20, top: 10, bottom: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(height: 10),
                            Center(
                              child: Text(
                                "Refill Details",
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ),
                            const SizedBox(height: 20),
                            TitleContent(
                              title: "Retail Outlet",
                              content: routineProvider.routines[index].name,
                            ),
                            TitleContent(
                              title: "Quantity",
                              content:
                                  "${routineProvider.routines[index].quantity} L",
                              isBold: true,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Card(
                        color: white500,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 20, right: 20, top: 10, bottom: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(height: 10),
                              Center(
                                child: Text(
                                  "Bills Breakup",
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 2),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text("Total"),
                                    routineProvider
                                                .routines[index].endQuantity ==
                                            routineProvider
                                                .routines[index].quantity
                                        ? Text(
                                            "${routineProvider.routines[index].endQuantity} / ${routineProvider.routines[index].quantity} L",
                                            style: const TextStyle(
                                                color: green500,
                                                fontWeight: FontWeight.bold),
                                          )
                                        : Text(
                                            "${routineProvider.routines[index].endQuantity} / ${routineProvider.routines[index].quantity} L",
                                            style: const TextStyle(
                                                color: red500,
                                                fontWeight: FontWeight.bold),
                                          ),
                                  ],
                                ),
                              ),
                              const Divider(),
                              Expanded(
                                child: ListView.builder(
                                    itemCount: routineProvider
                                        .routines[index].bills.length,
                                    itemBuilder: ((context, index) {
                                      return Column(
                                        children: [
                                          InkWell(
                                            onLongPress: () =>
                                                routineProvider.removeBill(
                                                    routineIndex: this.index,
                                                    index: index),
                                            child: Ink(
                                              child: Column(
                                                children: [
                                                  TitleContent(
                                                    title: 'Bill ID',
                                                    content: routineProvider
                                                        .routines[this.index]
                                                        .bills[index]
                                                        .id
                                                        .toString(),
                                                  ),
                                                  TitleContent(
                                                    isBold: true,
                                                    title: "Quantity",
                                                    content:
                                                        "${routineProvider.routines[this.index].bills[index].quantity} L",
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          const Divider(),
                                        ],
                                      );
                                    })),
                              ),
                              Row(
                                children: [
                                  Expanded(
                                      child: CustomButton(
                                          onTap: () =>
                                              finishClickEvent(context, index),
                                          title: 'Finish')),
                                  const SizedBox(width: 10),
                                  FloatingActionButton(
                                    onPressed: () =>
                                        createBillClickEvent(context, index),
                                    child: const Icon(Icons.add),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
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

  void createBillClickEvent(BuildContext context, int index) {
    Navigator.of(context).push(
      MaterialPageRoute(
          builder: ((context) => CreateBillScreen(
                index: index,
              ))),
    );
  }

  void finishClickEvent(BuildContext context, int index) {
    Navigator.of(context).push(
      MaterialPageRoute(
          builder: ((context) => RefillSummaryScreen(
                index: index,
              ))),
    );
  }
}
