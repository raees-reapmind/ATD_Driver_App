import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:atd/features/image_upload_feature/display/providers/image_upload_provider.dart';
import 'package:atd/features/login_feature/display/provider/login_provider.dart';
import 'package:atd/features/routine_feature/display/widgets/title_content.dart';
import 'package:atd/utils/signature_helper.dart';
import 'package:atd/utils/utils_export.dart';
import 'package:atd/utils/widgets/failure_dialog.dart';
import 'package:atd/utils/widgets/signature_button.dart';
import 'package:atd/utils/widgets/signature_pad_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_signature_pad/flutter_signature_pad.dart';
import '../../providers/routines_provider.dart';
import 'package:path_provider/path_provider.dart';

class RefillSummaryScreen extends StatelessWidget {
  final int index;
  const RefillSummaryScreen({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                                          context, routineProvider, index,imageUploadProvider,loginProvider)),
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
      BuildContext context, RoutinesProvider routineProvider,int index,ImageUploadProvider? imageUploadProvider,LoginProvider loginProvider) {
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
                // await signState.currentState?.getData().then((image) {
                //   if (managerNameController.text.toString().isNotEmpty) {
                //     debugPrint(managerNameController.text);
                    
                //     routineProvider.routines[index].receiverSignatureImage = image;
                //     routineProvider.routines[index].recieverName = managerNameController.text.toString();
                //     routineProvider.notifyDataChange();
                //     debugPrint('[sign-test] routineProvider.routines[index].receiverSignatureImage: ${routineProvider.routines[index].receiverSignatureImage}');

                //     showSnackBar(context: context, message: 'Signature Saved');
                //     Navigator.of(context).pop();
                //   } else {
                //     showSnackBar(
                //         context: context, message: 'Kindly Enter Manager Name');
                //   }
                // });
                final image = await signState.currentState?.getData();
                 int? imageId;

                if (image != null && managerNameController.text.isNotEmpty) {
                  debugPrint("Manager Name: ${managerNameController.text}");

                  try {
                    // Get temporary directory
                    // final tempDir = await getTemporaryDirectory();
                    // final filePath = '${tempDir.path}/signature.png';

                    // // Convert Image to bytes and save as a file
                    // final file = File(filePath);
                    // final byteData = await image.toByteData(format: ImageByteFormat.png);
                    // final buffer = byteData!.buffer.asUint8List();
                    // await file.writeAsBytes(buffer);

                    // // Upload signature image to API
                    // int? imageId = await imageUploadProvider!.eitherFailureOrUploadImage(
                    //   imagePath: file.path,
                    //   apiToken: loginProvider.userDetails!.apiToken!,
                    // );

                          if (image != null) {
                            final ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);
                            final Uint8List? imageBytes = byteData?.buffer.asUint8List();

                            if (imageBytes != null) {
                              imageId = await SignatureManager.processAndUploadSignature(
                                imageBytes: imageBytes,  // Correct type: Uint8List
                                apiToken: loginProvider.userDetails!.apiToken!,
                                uploadFunction: (String imagePath, String apiToken) =>
                                    imageUploadProvider!.eitherFailureOrUploadImage(imagePath: imagePath, apiToken: apiToken),
                              );
                            } else {
                              showSnackBar(context: context, message: 'Failed to process signature');
                            }
                          } else {
                            showSnackBar(context: context, message: 'No signature found');
                          }

                    if (imageId != null) {
                      debugPrint("Image uploaded successfully. Image ID: $imageId");

                      // Update routine with uploaded image ID
                      routineProvider.routines[index].managerSignImage = imageId.toString();
                      routineProvider.routines[index].recieverName = managerNameController.text;
                      routineProvider.notifyDataChange();

                      showSnackBar(context: context, message: 'Signature Saved');
                      Navigator.of(context).pop();
                    } else {
                      showSnackBar(context: context, message: 'Image upload failed');
                    }
                  } catch (e) {
                    debugPrint("Error saving image: $e");
                    showSnackBar(context: context, message: 'Error processing signature');
                  }
                } else {
                  showSnackBar(context: context, message: 'Kindly Enter Manager Name and Sign');
                }
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
        startLocationUpdates(loginProvider, routineProvider);
        routineProvider
            .eitherFailureOrGetRoutines(
                apiToken: loginProvider.userDetails!.apiToken!)
            .then((value) => Navigator.of(context).pushNamed('/dashboard'));
      }
    });
  }
}
