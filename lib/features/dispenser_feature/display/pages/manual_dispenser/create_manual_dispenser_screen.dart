import 'dart:io';
import 'package:atd/utils/widgets/image_full_screen_view.dart';

import '../../../domain/entities/dispenser_report.dart';
import '../../providers/dispenser_report_provider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../../../../../../utils/utils_export.dart';

class CreateManualDispenser extends StatefulWidget {
  const CreateManualDispenser({Key? key}) : super(key: key);

  @override
  State<CreateManualDispenser> createState() => _CreateManualDispenserState();
}

class _CreateManualDispenserState extends State<CreateManualDispenser> {
  final ImagePicker picker = ImagePicker();
  final quantitySelectedController = TextEditingController();
  final quantityDispensedController = TextEditingController();

  XFile? image;
  String dropDownDispenser = "SELECT";
  String dropDownAsset = "SELECT";

  void pickImage() async {
    try {
      final pickedImage = await picker.pickImage(source: ImageSource.camera);
      image = pickedImage;
      debugPrint(
          "path : ${pickedImage == null ? pickedImage.toString() : pickedImage.path.toString()}");
      setState(() {});
    } catch (e) {
      debugPrint("error : ${e.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    final dispenserReportProvider =
        Provider.of<DispenserReportsProvider>(context);

    void saveClickEvent({
      required String dispenserName,
      required String asset,
      required double? quantitySelected,
      required double? quantityDispensed,
      required XFile? image,
      required BuildContext context,
    }) {
      if (dispenserName != "SELECT" && asset != "SELECT") {
        if (quantitySelected != null && quantityDispensed != null) {
          if (image != null) {
            dispenserReportProvider.dispenserReports.add(
              DispenserReport(
                dispenserName: dispenserName,
                assetId: 1,
                quantitySelected: quantitySelected,
                quantityDispensed: quantityDispensed,
                image: image.path,
                dateTime: DateTime.now(),
              ),
            );
            showSnackBar(context: context, message: "Dispenser Entry Added");
            Navigator.of(context).pop();
          } else {
            showSnackBar(
                context: context,
                message: "Please upload the image of the totalizer or receipt");
          }
        } else {
          showSnackBar(
              context: context, message: "Please enter right quantity format");
        }
      } else {
        showSnackBar(
            context: context, message: "Please select the dispenser & asset");
      }
    }

    return Scaffold(
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
                            child: Text("Dispenser Report",
                                style: Theme.of(context).textTheme.titleLarge),
                          ),
                          const SizedBox(height: 20),
                          ListTile(
                            title: Text(
                              "Dispenser",
                              style: Theme.of(context).textTheme.subtitle1,
                            ),
                            trailing: DropdownButton<String>(
                              alignment: AlignmentDirectional.centerEnd,
                              value: dropDownDispenser,
                              elevation: 16,
                              onChanged: (String? value) {
                                if (value != null) {
                                  setState(() {
                                    dropDownDispenser = value;
                                  });
                                }
                              },
                              items: [
                                'SELECT',
                                'DU 1',
                                'DU 2',
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                          ListTile(
                            title: Text(
                              "Asset",
                              style: Theme.of(context).textTheme.subtitle1,
                            ),
                            trailing: DropdownButton<String>(
                              alignment: AlignmentDirectional.centerEnd,
                              value: dropDownAsset,
                              items: [
                                'SELECT',
                                'Asset 1',
                                'Asset 2',
                                'Asset 3',
                                'Other Asset',
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              elevation: 16,
                              onChanged: (String? value) {
                                if (value != null) {
                                  setState(() {
                                    dropDownAsset = value;
                                  });
                                }
                              },
                            ),
                          ),
                          ListTile(
                            title: Text(
                              "Quantity Selected",
                              style: Theme.of(context).textTheme.subtitle1,
                            ),
                            trailing: SizedBox(
                                width: 50,
                                child: TextField(
                                  controller: quantitySelectedController,
                                  keyboardType: TextInputType.number,
                                )),
                          ),
                          ListTile(
                            title: Text(
                              "Quantity Dispensed",
                              style: Theme.of(context).textTheme.subtitle1,
                            ),
                            trailing: SizedBox(
                                width: 50,
                                child: TextField(
                                  controller: quantityDispensedController,
                                  keyboardType: TextInputType.number,
                                )),
                          ),
                          ListTile(
                            title: Text(
                              "Upload image",
                              style: Theme.of(context).textTheme.subtitle1,
                            ),
                            subtitle: const Text(
                                "Kindly upload the images of totalizer or receipt"),
                            trailing: IconButton(
                                onPressed: () => pickImage(),
                                icon: const Icon(Icons.camera_alt)),
                          ),
                          const SizedBox(height: 10),
                          imageView(),
                          const SizedBox(height: 20),
                          CustomButton(
                              onTap: () => saveClickEvent(
                                    dispenserName: dropDownDispenser,
                                    asset: dropDownAsset,
                                    quantitySelected: double.tryParse(quantitySelectedController.text),
                                    quantityDispensed: double.tryParse(quantityDispensedController.text),
                                    image: image,
                                    context: context,
                                  ),
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

  Widget imageView() {
    if (image != null) {
      return Align(
        alignment: AlignmentDirectional.centerEnd,
        child: InkWell(
          onTap: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ImageView(
              imagePath: image!.path,
              hero: '',
              index: 1,
            ),
          )),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Hero(
              tag: "image",
              child: Image.file(
                File(image!.path),
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      );
    } else {
      return const SizedBox(height: 10);
    }
  }
}
