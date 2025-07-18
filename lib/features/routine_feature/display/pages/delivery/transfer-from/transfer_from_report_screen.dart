 import 'package:atd/features/routine_feature/display/pages/delivery/transfer-from/transfer_from_create_asset_report.dart';
import 'package:atd/features/routine_feature/display/pages/delivery/transfer-from/transfer_from_invoice_screen.dart'; 
import 'package:atd/utils/helper.dart';
import 'package:atd/utils/palette.dart';
import 'package:atd/utils/widgets/custom_background.dart';
import 'package:atd/utils/widgets/custom_button.dart';
import 'package:atd/utils/widgets/provider_export.dart';
import 'package:provider/provider.dart';

import 'package:atd/features/routine_feature/display/widgets/title_content.dart';
import 'package:flutter/material.dart';

class TransferFromScreen extends StatefulWidget {
  final int index;

  const TransferFromScreen({Key? key, required this.index}) : super(key: key);

  @override
  State<TransferFromScreen> createState() => _TransferFromScreenState();
}

class _TransferFromScreenState extends State<TransferFromScreen> {

  final totalizerDuLeftController = TextEditingController();
  final totalizerDuRightController = TextEditingController();

  @override 
  Widget build(BuildContext context) {
    final routineProvider = Provider.of<RoutinesProvider>(context);
    final loginProvider = Provider.of<LoginProvider>(context);
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
                                "Transfer Details",
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ),
                            const SizedBox(height: 20),
                            TitleContent(
                              title: "From",
                              content: routineProvider.routines[widget.index].vehicleNo ?? '',
                            ),
                            TitleContent(
                              title: "To",
                              content: routineProvider.routines[widget.index].action.toString() ?? '',
                            ),
                            TitleContent(
                              title: "Quantity",
                              content: '${routineProvider.routines[widget.index].quantity.toString()} L',
                            ),
                            TitleContent(
                              title: "Supervisor",
                              content:"${routineProvider.routines[widget.index].price ?? '-'}",
                            ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Expanded(
                                child: Text(
                                  'Location',
                                ),
                              ),
                              const SizedBox(height: 10,),
                              Expanded(
                                child: Text(
                                  textAlign: TextAlign.end,
                                  "${routineProvider.routines[widget.index].address} L",
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 3,
                                  style:const TextStyle(fontWeight: FontWeight.bold)
                                ),
                              )
                              ]
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
                                    routineProvider.routines[widget.index]
                                                .endQuantity !=
                                            routineProvider
                                                .routines[widget.index].quantity
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
                                  FloatingActionButton(
                                    onPressed: () => Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: ((context) =>
                                              TransferFromCreateAssetReportScreen(
                                                routine: routineProvider
                                                    .routines[widget.index],  
                                                index: widget.index,
                                              ) )),

                                              
                                    ),
                                    child: const Icon(Icons.add,color: Colors.white,),
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
    // showDialog(
    //   context: context,
    //   builder: (context) => CustomAlertDialog(
    //     isTotalizer: true,
    //     totalizerDuLeftController: totalizerDuLeftController,
    //     totalizerDuRightController: totalizerDuRightController,
    //     onTapSave: () async {
    //       final totalizerDuLeftReading = double.tryParse(totalizerDuLeftController.text.toString());
    //       final totalizerDuRightReading =  double.tryParse(totalizerDuRightController.text.toString());
    //       if (totalizerDuLeftReading != null && totalizerDuRightReading != null) {
    //         routineProvider.routines[index].endTotalizerDuLeft = totalizerDuLeftReading;
    //         routineProvider.routines[index].endTotalizerDuRight = totalizerDuRightReading;
    //         routineProvider.notifyDataChange();
            
    //             Navigator.of(context).push(MaterialPageRoute(builder: ((context) => TransferInvoiceScreen(index: index, transferTime: getCurrentTime()))));
         
    //       }
    //     },
    //     onTapCancel: () => Navigator.of(context).pop(),
    //   ),
    // );
    Navigator.of(context).push(MaterialPageRoute(builder: ((context) => TransferFromInvoiceScreen(index: index, transferTime: getCurrentTime()))));
  }

  // Future<bool> calculateBill(RoutinesProvider routineProvider,
  //     BuildContext context, LoginProvider loginProvider, int index) async {
  //   return await routineProvider.eitherFailureOrGetBill(
  //       apiToken: loginProvider.userDetails!.apiToken!, index: index);
  // }
}
