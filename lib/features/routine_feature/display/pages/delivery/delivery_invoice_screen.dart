import 'dart:typed_data';
import 'dart:ui';

import 'package:atd/core/services/image_picker_service.dart';
import 'package:atd/features/image_upload_feature/display/providers/image_upload_provider.dart';
import 'package:atd/features/vehicle_readings_feature/data/models/image_details.dart';
import 'package:atd/utils/signature_helper.dart';
import 'package:atd/utils/utils_export.dart';
import 'package:atd/utils/widgets/camera_button.dart';
import 'package:atd/utils/widgets/failure_dialog.dart';
import 'package:atd/utils/widgets/routine_info_alert_dialog.dart';
import 'package:atd/utils/widgets/signature_button.dart';
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

class DeliveryInvoiceScreen extends StatefulWidget {
  final int index;
  const DeliveryInvoiceScreen({Key? key, required this.index})
      : super(key: key);

  @override
  State<DeliveryInvoiceScreen> createState() => _DeliveryInvoiceScreenState();
}

class _DeliveryInvoiceScreenState extends State<DeliveryInvoiceScreen> {
  final TextEditingController receiverNameController = TextEditingController();
  bool _isFinishing = false;

  final router = GoRouter(routes: [

  ]);



  @override
  Widget build(BuildContext context) {
    print('DeliveryInvoiceScreen....');
    final routineProvider = Provider.of<RoutinesProvider>(context);
    final loginProvider = Provider.of<LoginProvider>(context);
    final imageUploadProvider = Provider.of<ImageUploadProvider>(context);
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
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Delivery Invoice",
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(width: 10),
                              GestureDetector(
                                onTap: () {
                                  routineProvider.notifyDataChange();
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return RoutineInfoAlertDialog(
                                            routine: routineProvider
                                                .routines[widget.index],
                                            onTapCancel: () =>
                                                Navigator.of(context).pop());
                                      });
                                },
                                child: const Icon(
                                  Icons.info,
                                  color: primary500,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          TitleContent(
                            title: "Name",
                            content:
                                routineProvider.routines[widget.index].name,
                          ),
                          TitleContent(
                            title: "Vehicle",
                            content:
                                loginProvider.userDetails?.vehicleRegNo ?? '',
                          ),
                          TitleContent(
                            title: "Address",
                            content:
                                routineProvider.routines[widget.index].address,
                          ),
                          TitleContent(
                            title: "Payment Mode",
                            content: routineProvider
                                .routines[widget.index].paymentMode
                                .toString(),
                          ),
                          TitleContent(
                            title: "Quantity",
                            content:
                                "${routineProvider.routines[widget.index].quantity} L",
                          ),
                          TitleContent(
                            title: "Actual Quantity",
                            content:
                                "${routineProvider.routines[widget.index].endQuantity} L",
                            isBold: true,
                          ),
                          TitleContent(
                            title: "Total Assets Delivered",
                            content: routineProvider
                                .routines[widget.index].assetsReport.length
                                .toString(),
                            isBold: true,
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
                          TitleContent(
                            title: "Total Price",
                            content: routineProvider
                                .routines[widget.index].endPrice
                                .toString(),
                            isBold: true,
                          ),
                          routineProvider.routines[widget.index].recieverName !=
                                      null &&
                                  routineProvider
                                          .routines[widget.index].imageList !=
                                      null
                              ? Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TitleContent(
                                        isBold: true,
                                        title: 'Receiver Name',
                                        content: routineProvider
                                            .routines[widget.index].recieverName
                                            .toString()),
                                    const TitleContent(
                                        isBold: true,
                                        title: 'Receiver Signature',
                                        content: 'Attached'),
                                  ],
                                )
                              : const TitleContent(
                                  title: 'Receiver Details', content: 'NA'),
                          routineProvider.routines[widget.index].imageList !=
                                  null
                              ? const TitleContent(
                                  isBold: true,
                                  title: 'Receipt Image',
                                  content: 'Attached')
                              : const TitleContent(
                                  title: 'Receipt Image',
                                  content: 'NA',
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
                              const SizedBox(width: 10),
                              SignatureButton(
                                onTap: () => signatureClickEvent(
                                    context,
                                    routineProvider,
                                    widget.index,
                                    loginProvider,
                                    imageUploadProvider),
                              ),
                              const SizedBox(width: 10),
                              CameraButton(
                                onTap: () => receiptClickEvent(
                                    context,
                                    loginProvider,
                                    routineProvider,
                                    widget.index,
                                    imageUploadProvider),
                              ),
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
    if (_isFinishing) return;
    setState(() {
      _isFinishing = true;
    });

    routineProvider.routines[index].endDateTime = DateTime.now();

    try {
      final value = await routineProvider.eitherFailureOrPostDeliveryReport(
          apiToken: loginProvider.userDetails!.apiToken!,
          routine: routineProvider.routines[index]);
      if (value) {
        final isSuccess = await routineProvider.eitherFailureOrGetRoutines(
            apiToken: loginProvider.userDetails!.apiToken!);
        if (isSuccess) {
          // stopLocationUpdates();
          startLocationUpdates(loginProvider, routineProvider);
          Navigator.of(context).pushNamed('/dashboard');
        } else {
          // ignore: use_build_context_synchronously
          showDialog(
            context: context,
            builder: (context) => FailureDialog(
              content: routineProvider.failure != null
                  ? routineProvider.failure!.errorMessage.toString()
                  : '',
            ),
          );
        }
      } else {
        // ignore: use_build_context_synchronously
        showDialog(
          context: context,
          builder: (context) => FailureDialog(
            content: routineProvider.failure != null
                ? routineProvider.failure!.errorMessage.toString()
                : '',
          ),
        );
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => FailureDialog(
          content: e.toString(),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isFinishing = false;
        });
      }
    }
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




