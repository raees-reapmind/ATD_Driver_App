import 'package:atd/features/dispenser_checks_feature/display/providers/dispenser_checks_provider.dart';
import 'package:atd/features/image_upload_feature/display/providers/image_upload_provider.dart';
import 'package:atd/features/login_feature/display/provider/login_provider.dart';
import 'package:atd/features/vehicle_readings_feature/data/models/image_details.dart';
import 'package:atd/utils/utils_export.dart';
import 'package:atd/utils/widgets/image_list_view.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../../../core/services/image_picker_service.dart';
import '../../data/models/dispenser_check.dart';

class CreateDispenserCheck extends StatefulWidget {
  const CreateDispenserCheck({Key? key}) : super(key: key);

  @override
  State<CreateDispenserCheck> createState() => _CreateDispenserCheckState();
}

class _CreateDispenserCheckState extends State<CreateDispenserCheck> {
  final ImagePicker picker = ImagePicker();
  final quantitySelectedController = TextEditingController();
  final quantityDispensedController = TextEditingController();
  final duReadingsController = TextEditingController();

  XFile? image;
  String dropDownFrom = "SELECT";
  String dropDownTo = "SELECT";
  final List<ImageDetails> imageList = [];

  @override
  Widget build(BuildContext context) {
    
    final dispenserChecksProvider = Provider.of<DispenserChecksProvider>(context);
    final imageUploadProvider = Provider.of<ImageUploadProvider>(context);
    final loginProvider = Provider.of<LoginProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Dispenser Check"),
      ),
      body: Stack(
        children: [
          const CustomBackground(),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Card(
                    color: white500,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    child: Padding(
                      padding: const EdgeInsets.all(30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(height: 10),
                          Center(
                            child: Text("Dispenser Check",
                                style: Theme.of(context).textTheme.titleLarge),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            "From",
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                          DropdownButton<String>(
                            alignment: AlignmentDirectional.centerEnd,
                            value: dropDownFrom,
                            elevation: 16,
                            isExpanded: true,
                            onChanged: (String? value) {
                              if (value != null) {
                                setState(() {
                                  dropDownFrom = value;
                                });
                              }
                            },
                            items: dispenserChecksProvider.fromList
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "To",
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                          DropdownButton<String>(
                            isExpanded: true,
                            alignment: AlignmentDirectional.centerEnd,
                            value: dropDownTo,
                            elevation: 16,
                            onChanged: (String? value) {
                              if (value != null) {
                                setState(() {
                                  dropDownTo = value;
                                });
                              }
                            },
                            items: dispenserChecksProvider.toList
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 10),
                          const Text("Quantity"),
                          const SizedBox(height: 5),
                          CustomTextField(
                            isNumber: true,
                            controller: quantitySelectedController,
                            hintText: "Enter Quantity Selected",
                          ),
                          const SizedBox(height: 10),
                          const Text("Quantity Dispensed"),
                          const SizedBox(height: 5),
                          CustomTextField(
                            isNumber: true,
                            controller: quantityDispensedController,
                            hintText: "Enter Quantity Dispensed",
                          ),

                          const Text("Readings"),
                          const SizedBox(height: 5),
                          CustomTextField(
                            isNumber: true,
                            controller: duReadingsController,
                            hintText: "Enter DU-Right/Left Readings",
                          ),


                          const SizedBox(height: 10),
                          ListTile(
                            contentPadding: const EdgeInsets.all(0),
                            title: Text(
                              "Upload image",
                              style: Theme.of(context).textTheme.subtitle1,
                            ),
                            subtitle: const Text(
                                "Kindly upload the images of checks performed"),
                            trailing: IconButton(
                                onPressed: () async {
                                  final image =
                                      await ImagePickerService.pickImage();
                                  if (image != null) {
                                    imageList.add(ImageDetails(
                                        image: image, imagePath: image.path));
                                    setState(() {});
                                  }
                                },
                                icon: const Icon(Icons.camera_alt)),
                          ),
                          const SizedBox(height: 10),
                          ImageListView(
                            imageList: imageList,
                            heroTag: 'dispenser_checks',
                          ),
                          const SizedBox(height: 20),
                          CustomButton(
                              onTap: () => saveClickEvent(
                                  dispensedFrom: dropDownFrom,
                                  dispensedTo: dropDownTo,
                                  quantitySelected: double.tryParse(
                                      quantitySelectedController.text),
                                  quantityDispensed: double.tryParse(
                                      quantityDispensedController.text),
                                      duReadings: double.tryParse(
                                        duReadingsController.text),
                                  context: context,
                                  imageUploadProvider: imageUploadProvider,
                                  dispenserChecksProvider:
                                      dispenserChecksProvider,
                                  loginProvider: loginProvider),
                              title: "Save"),
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

  Future<bool> uploadImageList(
    ImageUploadProvider imageUploadProvider,
    LoginProvider loginProvider,
    DispenserChecksProvider dispenserChecksProvider,
    DispenserCheck dispenserCheck,
  ) async {
    bool isUploaded = true;
    for (ImageDetails imageDetails in imageList) {
      final imageId = await imageUploadProvider.eitherFailureOrUploadImage(
          apiToken: loginProvider.userDetails!.apiToken!,
          imagePath: imageDetails.imagePath!);
      if (imageId != null) {
        imageDetails.imageId = imageId;
      } else {
        isUploaded = false;
        break;
      }
    }
    if (isUploaded) {
      dispenserCheck.imageList = imageList;
      dispenserChecksProvider.add(dispenserCheck: dispenserCheck);
    }
    return isUploaded;
  }


  void saveClickEvent({
    required String dispensedFrom,
    required String dispensedTo,
    required double? quantitySelected,
    required double? quantityDispensed,
    double? duReadings,
    required BuildContext context,
    required LoginProvider loginProvider,
    required ImageUploadProvider imageUploadProvider,
    required DispenserChecksProvider dispenserChecksProvider,
  }) async {
    if (dispensedFrom != "SELECT" && dispensedTo != "SELECT") {
      if (quantitySelected != null && quantityDispensed != null) {
        debugPrint(imageList.length.toString());
        if (imageList.isNotEmpty) {
          await uploadImageList(
                  imageUploadProvider,
                  loginProvider,
                  dispenserChecksProvider,
                  DispenserCheck(
                      dispensedFrom: dispensedFrom,
                      dispensedTo: dispensedTo,
                      quantitySelected: quantitySelected,
                      quantityDispensed: quantityDispensed,
                      duReadings: duReadings
                      ))
              .then((isUploaded) {
            if (isUploaded) {
              showSnackBar(context: context, message: 'Dispenser Check Added');
              Navigator.of(context).pop();
            } else {
              showSnackBar(
                  context: context, message: 'Failed to upload images');
            }
          });
        } else {
          showSnackBar(
              context: context,
              message: "Please upload the image of the checks performed");
        }
      } else {
        showSnackBar(
            context: context, message: "Please enter right quantity format");
      }
    } else {
      showSnackBar(context: context, message: "Please select the dispenser");
    }
  }
}
