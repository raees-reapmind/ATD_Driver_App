import 'dart:typed_data';
import 'dart:ui';

import 'package:atd/core/services/image_picker_service.dart';
import 'package:atd/features/image_upload_feature/display/providers/image_upload_provider.dart';
import 'package:atd/features/vehicle_readings_feature/data/models/image_details.dart';
import 'package:atd/utils/signature_helper.dart';
import 'package:atd/utils/utils_export.dart';
import 'package:atd/utils/widgets/failure_dialog.dart';
import 'package:atd/utils/widgets/signature_pad_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signature_pad/flutter_signature_pad.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../login_feature/display/provider/login_provider.dart';
import '../../providers/routines_provider.dart';
import '../../widgets/title_content.dart';

class TransferInvoiceScreen extends StatefulWidget {
  final int index;
  final String? transferTime;
  const TransferInvoiceScreen({Key? key, required this.index, this.transferTime})
      : super(key: key);

  @override
  State<TransferInvoiceScreen> createState() => _TransferInvoiceScreenState();
}

class _TransferInvoiceScreenState extends State<TransferInvoiceScreen> {
  final TextEditingController receiverNameController = TextEditingController();

  final router = GoRouter(routes: [

  ]);



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
                child: SingleChildScrollView(
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
                          Center(
                              child: Text(
                                "Transfer Report",
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ),
                            const SizedBox(height: 20),
                            TitleContent(
                              title: "To",
                               isBold: true,
                              content: routineProvider.routines[widget.index].action.toString() ?? '',
                            ),
                            TitleContent(
                              title: "ID",
                               isBold: true,
                              content: routineProvider.routines[widget.index].vehicleNo ?? '',
                            ),
                            TitleContent(
                              title: "Quantity",
                               isBold: true,
                              content: '${routineProvider.routines[widget.index].quantity.toString()} L',
                            ),
                            TitleContent(
                              title: "Supervisor",
                              isBold: true,
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
                          routineProvider.routines[widget.index]
                                      .additionalChargesList !=
                                  null
                              ? ListView.builder(
                                  itemCount: routineProvider
                                      .routines[widget.index]
                                      .additionalChargesList!
                                      .length,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    return TitleContent(
                                        title: routineProvider
                                            .routines[this.widget.index]
                                            .additionalChargesList![index]
                                            .label
                                            .toString(),
                                        content: routineProvider
                                            .routines[this.widget.index]
                                            .additionalChargesList![index]
                                            .value
                                            .toString());
                                  },
                                )
                              : const SizedBox.shrink(),

                            const SizedBox(height: 30,),
                            TitleContent(
                              title: "Quantity",
                              content: '${routineProvider.routines[widget.index].quantity.toString()} L',
                            ),

                            TitleContent(
                              title: "Actual Quantity",
                              isBold: true,
                              content: '${routineProvider.routines[widget.index].endQuantity.toString()} L',
                            ),

                          TitleContent(
                            title: "Time of Transfer",
                            isBold: true,
                            content: '${widget.transferTime}',
                          ),

                          const SizedBox(height: 20),

                          Row(
                            children: [
                              Expanded(
                                  child: CustomButton(
                                      onTap: () => finishClickEvent(
                                          context,
                                          loginProvider,
                                          routineProvider,
                                          widget.index),
                                      title: 'Finish')),
                             
                            ],
                          )
                        ],
                      ),
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
      BuildContext context,
      RoutinesProvider routineProvider,
      int index,
      LoginProvider loginProvider,
      ImageUploadProvider imageUploadProvider) {
    final signState = GlobalKey<SignatureState>();
    showDialog(
      context: context,
      builder: (context) => SignaturePadDialog(
        controller: receiverNameController,
        hintText: 'Receiver name',
        signState: signState,
        onTapSave: () async {
          // await signState.currentState?.getData().then((image) {
          //   routineProvider.routines[index].recieverName = receiverNameController.text.toString();
          //   routineProvider.routines[index].receiverSignatureImage = image;
          //   routineProvider.notifyDataChange();
          //   Navigator.of(context).pop();
          // });
          final image = await signState.currentState?.getData(); // Returns Image?
           int? imageId;

            if (image != null) {
              final ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);
              final Uint8List? imageBytes = byteData?.buffer.asUint8List();

              if (imageBytes != null) {
                imageId = await SignatureManager.processAndUploadSignature(
                  imageBytes: imageBytes,  // Correct type: Uint8List
                  apiToken: loginProvider.userDetails!.apiToken!,
                  uploadFunction: (String imagePath, String apiToken) =>
                      imageUploadProvider.eitherFailureOrUploadImage(imagePath: imagePath, apiToken: apiToken),
                );
              } else {
                // ignore: use_build_context_synchronously
                showSnackBar(context: context, message: 'Failed to process signature');
              }
            } else {
              // ignore: use_build_context_synchronously
              showSnackBar(context: context, message: 'No signature found');
            }


            if (imageId != null) {
              routineProvider.routines[index].managerSignImage = imageId.toString();
              routineProvider.routines[index].recieverName = receiverNameController.text.toString();
              routineProvider.notifyDataChange();

              // ignore: use_build_context_synchronously
              showSnackBar(context: context, message: 'Signature Saved');
              // ignore: use_build_context_synchronously
              Navigator.of(context).pop();
            } else {
              // ignore: use_build_context_synchronously
              showSnackBar(context: context, message: 'Image upload failed');
            }
         
          
        },
        title: 'Receiver Details',
      ),
    );
  }

  void finishClickEvent(BuildContext context, LoginProvider loginProvider,
      RoutinesProvider routineProvider, int index) async {
    routineProvider.routines[index].endDateTime = DateTime.now();

    debugPrint('[id-test] ${routineProvider.routines[index].toDeliveryMap()}');
  
    await routineProvider.eitherFailureOrPostTransferReport(
            apiToken: loginProvider.userDetails!.apiToken!,
            routine: routineProvider.routines[index])
        .then((value) async {
      if (value) {
        await routineProvider
            .eitherFailureOrGetRoutines(
                apiToken: loginProvider.userDetails!.apiToken!)
            .then((isSuccess) {
          if (isSuccess) {
            // stopLocationUpdates();
             startLocationUpdates(loginProvider,routineProvider);
            Navigator.of(context).pushNamed('/dashboard');
          } else {
            showDialog(
              context: context,
              builder: (context) => FailureDialog(
                content: routineProvider.failure != null
                    ? routineProvider.failure!.errorMessage.toString()
                    : '',
              ),
            );
          }
        });
      } else {
        showDialog(
          context: context,
          builder: (context) => FailureDialog(
            content: routineProvider.failure != null
                ? routineProvider.failure!.errorMessage.toString()
                : '',
          ),
        );
      }
    });
  }

  void receiptClickEvent(
      BuildContext context,
      LoginProvider loginProvider,
      RoutinesProvider routineProvider,
      int index,
      ImageUploadProvider imageUploadProvider) async {
    XFile? image = await ImagePickerService.pickImage();
    if (image != null) {
      int? imageId = await imageUploadProvider.eitherFailureOrUploadImage(
          imagePath: image.path,
          apiToken: loginProvider.userDetails!.apiToken!);
      if (imageId != null) {
        routineProvider.routines[index].imageList = [
          ImageDetails(image: image, imageId: imageId, imagePath: image.path)
        ];
        // ignore: use_build_context_synchronously
        showSnackBar(context: context, message: 'Image Attached');
      } else {
        // ignore: use_build_context_synchronously
        showSnackBar(context: context, message: 'Failed to upload image');
      }
    } else {
      // ignore: use_build_context_synchronously
      showSnackBar(context: context, message: 'Failed to capture image');
    }
  }
}

Future<void> openAnotherApp() async {
  // Replace "exampleapp://" with the actual deep link or scheme of the app you want to open
  const String deepLink = "csi://app/EastmanDecantActivity?order_no=1224&order_qty=10&otp=1234&rfid_tag=";

  // Check if the app is installed
  // ignore: deprecated_member_use
  if (await canLaunch(deepLink)) {
    // Use the deep link to open the app
    await launchUrl(Uri.parse(deepLink));
  } else {
    // If the app is not installed, provide a fallback (e.g., redirect to app store)
    // For simplicity, this example redirects to the Play Store on Android
    await launchUrl(Uri.parse(""));

  }


}




