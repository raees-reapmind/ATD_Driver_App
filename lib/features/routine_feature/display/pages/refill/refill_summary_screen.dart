import 'package:atd/features/login_feature/display/provider/login_provider.dart';
import 'package:atd/features/routine_feature/display/widgets/title_content.dart';
import 'package:atd/utils/utils_export.dart';
import 'package:atd/utils/widgets/failure_dialog.dart';
import 'package:atd/utils/widgets/signature_button.dart';
import 'package:atd/utils/widgets/signature_pad_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_signature_pad/flutter_signature_pad.dart';
import '../../providers/routines_provider.dart';

class RefillSummaryScreen extends StatelessWidget {
  final int index;
  const RefillSummaryScreen({Key? key, required this.index}) : super(key: key);

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
                            "Refill Summary",
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                        const SizedBox(height: 20),
                        TitleContent(
                          title: "Retail Outlet",
                          content: routineProvider.routines[index].name,
                        ),
                        TitleContent(
                          title: "Vehicle",
                          content:
                              loginProvider.userDetails?.vehicleRegNo ?? '',
                        ),
                        TitleContent(
                          title: "Address",
                          content: routineProvider.routines[index].address,
                        ),
                        TitleContent(
                          title: "Quantity",
                          content:
                              "${routineProvider.routines[index].quantity} L",
                          isBold: true,
                        ),
                        TitleContent(
                          title: "Actual Quantity",
                          content:
                              "${routineProvider.routines[index].endQuantity} L",
                          isBold: true,
                        ),
                        TitleContent(
                          title: "Total Bills",
                          content: routineProvider.routines[index].bills.length
                              .toString(),
                          isBold: true,
                        ),
                        routineProvider.routines[index].recieverName != null
                            ? TitleContent(
                                title: "Bunk Manager Name",
                                content: routineProvider
                                    .routines[index].recieverName
                                    .toString(),
                                isBold: true,
                              )
                            : const SizedBox.shrink(),
                        const SizedBox(height: 20),
                        !routineProvider.isLoading
                            ? Row(
                                children: [
                                  Expanded(
                                      child: CustomButton(
                                          onTap: () => finishClickEvent(
                                              context,
                                              loginProvider,
                                              routineProvider,
                                              index),
                                          title: 'Finish')),
                                  const SizedBox(width: 10),
                                  SignatureButton(
                                      onTap: () => signatureClickEvent(
                                          context, routineProvider, index)),
                                ],
                              )
                            : const Center(child: CircularProgressIndicator()),
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

  void signatureClickEvent(
      BuildContext context, RoutinesProvider routineProvider, int index) {
    final signState = GlobalKey<SignatureState>();
    final managerNameController = TextEditingController();

    showDialog(
        useSafeArea: true,
        context: context,
        builder: ((context) {
          return SignaturePadDialog(
              controller: managerNameController,
              hintText: 'Enter Name',
              signState: signState,
              onTapSave: () async {
                await signState.currentState?.getData().then((image) {
                  if (managerNameController.text.toString().isNotEmpty) {
                    debugPrint(managerNameController.text);
                    routineProvider.routines[index].receiverSignatureImage =
                        image;
                    routineProvider.routines[index].recieverName =
                        managerNameController.text.toString();
                    routineProvider.notifyDataChange();
                    showSnackBar(context: context, message: 'Signature Saved');
                    Navigator.of(context).pop();
                  } else {
                    showSnackBar(
                        context: context, message: 'Kindly Enter Manager Name');
                  }
                });
              },
              title: 'Bunk Manager Details');
        }));
  }

  void finishClickEvent(BuildContext context, LoginProvider loginProvider,
      RoutinesProvider routineProvider, int index) async {
    routineProvider.routines[index].endDateTime = DateTime.now();
    await routineProvider
        .eitherFailureOrPostRefillReport(
            apiToken: loginProvider.userDetails!.apiToken!,
            routine: routineProvider.routines[index])
        .then((isSuccess) {
      if (!isSuccess) {
        showDialog(
          context: context,
          builder: (context) => FailureDialog(
            content: routineProvider.failure!.errorMessage.toString(),
          ),
        );
      } else {
        routineProvider
            .eitherFailureOrGetRoutines(
                apiToken: loginProvider.userDetails!.apiToken!)
            .then((value) => Navigator.of(context).pushNamed('/dashboard'));
      }
    });
  }
}
