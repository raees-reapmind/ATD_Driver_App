import 'package:atd/features/routine_feature/data/models/additonal_charge.dart';
import 'package:atd/features/routine_feature/display/pages/delivery/delivery_invoice_screen.dart';
import 'package:atd/utils/widgets/custom_alert_dialog.dart';
import 'package:atd/utils/widgets/provider_export.dart';
import 'package:provider/provider.dart';
import 'create_asset_report_screen.dart';
import 'package:atd/features/routine_feature/display/widgets/title_content.dart';
import 'package:flutter/material.dart';

import '../../../../../utils/utils_export.dart';

class DeliveryScreen extends StatefulWidget {
  final int index;

  const DeliveryScreen({Key? key, required this.index}) : super(key: key);

  @override
  State<DeliveryScreen> createState() => _DeliveryScreenState();
}

class _DeliveryScreenState extends State<DeliveryScreen> {
  final totalizerDuLeftController = TextEditingController();
  final totalizerDuRightController = TextEditingController();
  final  odometerController = TextEditingController();
  bool _isSavingBill = false;


  @override
  Widget build(BuildContext context) {
    final routineProvider = Provider.of<RoutinesProvider>(context);
    final loginProvider = Provider.of<LoginProvider>(context);
    print('DeliveryScreen.....');
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
                                "Order Details",
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ),
                            const SizedBox(height: 20),
                            TitleContent(
                              title: "Name",
                              content: routineProvider
                                  .routines[widget.index].name
                                  .toString(),
                            ),
                            TitleContent(
                              title: "POC",
                              content: routineProvider
                                  .routines[widget.index].pocName
                                  .toString(),
                            ),
                            TitleContent(
                              title: "Contact No",
                              content: routineProvider
                                  .routines[widget.index].pocMobile
                                  .toString(),
                            ),
                            TitleContent(
                              title: "Total Price",
                              content:
                                  "₹ ${routineProvider.routines[widget.index].price}",
                            ),
                            TitleContent(
                              title: "Quantity",
                              content:
                                  "${routineProvider.routines[widget.index].quantity} L",
                              isBold: true,
                            ),
                            TitleContent(
                              title: "Price Per Litre",
                              content:
                                  "₹ ${routineProvider.routines[widget.index].pricePerLitre}",
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
                                  "Asset Report Summary",
                                  style: Theme.of(context).textTheme.titleMedium,
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
                                    routineProvider.routines[widget.index].endQuantity != routineProvider.routines[widget.index].quantity
                                        ? Text(
                                            "${routineProvider.routines[widget.index].endQuantity} / ${routineProvider.routines[widget.index].quantity} L",
                                            style: const TextStyle(
                                                color: red500,
                                                fontWeight: FontWeight.bold),
                                          )
                                        : Text(
                                            "${routineProvider.routines[widget.index].endQuantity} / ${routineProvider.routines[widget.index].quantity} L",
                                            style: const TextStyle(
                                                color: green500,
                                                fontWeight: FontWeight.bold),
                                          ),
                                  ],
                                ),
                              ),
                              const Divider(),
                              Expanded(
                                child: ListView.builder(
                                    itemCount: routineProvider
                                        .routines[widget.index]
                                        .assetsReport
                                        .length,
                                    itemBuilder: ((context, index) {
                                      return Column(
                                        children: [
                                          InkWell(
                                            onLongPress: () => routineProvider
                                                .removeAssetReport(
                                                    routineIndex: widget.index,
                                                    index: index),
                                            child: Ink(
                                              child: Column(
                                                children: [
                                                  TitleContent(
                                                    title: 'Asset',
                                                    content: routineProvider
                                                        .routines[widget.index]
                                                        .assetsReport[index]
                                                        .name,
                                                  ),
                                                  TitleContent(
                                                    title: 'Type',
                                                    content: routineProvider
                                                        .routines[widget.index]
                                                        .assetsReport[index]
                                                        .type
                                                        .toString(),
                                                  ),
                                                  TitleContent(
                                                    title: 'Quantity',
                                                    content:
                                                        '${routineProvider.routines[this.widget.index].assetsReport[index].endQuantity} L',
                                                    isBold: true,
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
                                          onTap: () => finishClickEvent(
                                              context,
                                              widget.index,
                                              routineProvider,
                                              loginProvider),
                                          title: 'Finish')),
                                  const SizedBox(width: 10),
                                  FloatingActionButton(onPressed: () => Navigator.of(context).push( MaterialPageRoute( builder: ((context) => CreateAssetReportScreen( routine: routineProvider.routines[widget.index], index: widget.index,))),),
                                  child: const Icon(Icons.add,color: Colors.white  ),
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

  void finishClickEvent(BuildContext context, int index,
      RoutinesProvider routineProvider, LoginProvider loginProvider) {
    showDialog(
      context: context,
      builder: (context) => CustomAlertDialog(
        isTotalizer: true,
        isOdometer: true,
        odometerController: odometerController,
        totalizerDuLeftController: totalizerDuLeftController,
        totalizerDuRightController: totalizerDuRightController,

        onTapSave: () async {
          final odometerReading = double.tryParse(odometerController.text.toString());
          final totalizerDuLeftReading = double.tryParse(totalizerDuLeftController.text.toString());
          final totalizerDuRightReading = double.tryParse(totalizerDuRightController.text.toString());

          if (totalizerDuLeftReading != null && totalizerDuRightReading != null) {
            if (_isSavingBill) return;
            setState(() {
              _isSavingBill = true;
            });

            routineProvider.routines[index].end_odometer = odometerReading;
            routineProvider.routines[index].endTotalizerDuLeft = totalizerDuLeftReading;
            routineProvider.routines[index].endTotalizerDuRight = totalizerDuRightReading;
            routineProvider.notifyDataChange();

            debugPrint('routineProvider.routines[index].quantity: ${routineProvider.routines[index].quantity}');
            debugPrint('routineProvider.routines[index].endQuantity: ${routineProvider.routines[index].endQuantity}');
            debugPrint('routineProvider.routines[index].quantity != routineProvider.routines[index].endQuantity: ${routineProvider.routines[index].quantity != routineProvider.routines[index].endQuantity}');
            
            try {
              final isSuccess = await calculateBill(routineProvider, context, loginProvider, index);
              for (AdditionCharge additionCharge in routineProvider.routines[index].additionalChargesList ?? []) {
                if (additionCharge.breakUpType == 'total_payable_bill') {
                  routineProvider.routines[index].endPrice = additionCharge.value;
                  break;
                }
              }
              Navigator.of(context).pop();
              Navigator.of(context).push(MaterialPageRoute(
                  builder: ((context) =>
                      DeliveryInvoiceScreen(index: index))));
            } catch (e) {
              showSnackBar(context: context, message: e.toString());
            } finally {
              if (mounted) {
                setState(() {
                  _isSavingBill = false;
                });
              }
            }
          }
        },
        onTapCancel: () => Navigator.of(context).pop(),
      ),
    );
  }

  Future<bool> calculateBill(RoutinesProvider routineProvider,
      BuildContext context, LoginProvider loginProvider, int index) async {
    return await routineProvider.eitherFailureOrGetBill(
        apiToken: loginProvider.userDetails!.apiToken!, index: index);
  }
}
