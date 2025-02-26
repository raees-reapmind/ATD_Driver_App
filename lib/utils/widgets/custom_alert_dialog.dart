import 'dart:io';
import 'package:atd/core/services/image_picker_service.dart';
import 'package:atd/features/vehicle_readings_feature/data/models/image_details.dart';
import 'package:atd/utils/widgets/image_list_view.dart';
import 'package:atd/utils/widgets/provider_export.dart';
import 'package:flutter/material.dart';
import 'package:atd/utils/utils_export.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'image_full_screen_view.dart';

class CustomAlertDialog extends StatefulWidget {
  final String title;
  final bool isOdometer;
  final TextEditingController? odometerController;
  final bool isTotalizer;
  final TextEditingController? totalizerDuLeftController;
  final TextEditingController? totalizerDuRightController;
  final bool isImage;
  final VoidCallback onTapSave;
  final Function(List<ImageDetails> imageList)? onTapImage;
  final VoidCallback onTapCancel;
  final String imageContent;

  const CustomAlertDialog({
    Key? key,
    required this.onTapSave,
    required this.onTapCancel,
    this.title = 'Enter Details',
    this.isOdometer = false,
    this.isTotalizer = false,
    this.isImage = false,
    this.odometerController,
    this.onTapImage,
    this.totalizerDuLeftController,
    this.totalizerDuRightController,
    this.imageContent = 'content',
  }) : super(key: key);

  @override
  State<CustomAlertDialog> createState() => _CustomAlertDialogState();
}

class _CustomAlertDialogState extends State<CustomAlertDialog> {
  final List<ImageDetails> imageList = [];

  final ImagePicker picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    final routineProvider = Provider.of<RoutinesProvider>(context);
    return AlertDialog(
      scrollable: true,
      actions: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              Expanded(
                  child: CustomButton(
                onTap: () => widget.onTapCancel(),
                title: "Cancel",
              )),
              const SizedBox(width: 10),
              Expanded(
                  child: CustomButton(
                onTap: () => widget.onTapSave(),
                title: "Save",
                backgroundColor: secondary500,
                textColor: Colors.white,
                splashColor: primary500,
              ))
            ],
          ),
        ),
      ],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Center(
            child: Text(
              widget.title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(height: 20),
          widget.isOdometer
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Odometer"),
                    const SizedBox(height: 5),
                    CustomTextField(
                      isNumber: true,
                      controller: widget.odometerController!,
                      hintText: "Enter Odometer Reading",
                    ),
                  ],
                )
              : const SizedBox.shrink(),
          const SizedBox(height: 10),
          widget.isTotalizer
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("DU Left"),
                    const SizedBox(height: 5),
                    CustomTextField(
                      isNumber: true,
                      controller: widget.totalizerDuLeftController!,
                      hintText: "Enter Totalizer Reading",
                    ),
                    const SizedBox(height: 10),
                    const Text("DU Right"),
                    const SizedBox(height: 5),
                    CustomTextField(
                      isNumber: true,
                      controller: widget.totalizerDuRightController!,
                      hintText: "Enter Totalizer Reading",
                    ),
                    const SizedBox(height: 10),
                  ],
                )
              : const SizedBox.shrink(),
          widget.isImage
              ? Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Upload image"),
                              Text(widget.imageContent,
                                  style: Theme.of(context).textTheme.subtitle2),
                            ],
                          ),
                        ),
                        Expanded(
                            child: IconButton(
                                onPressed: () => pickImage(),
                                icon: const Icon(Icons.camera_alt))),
                      ],
                    ),
                    ImageListView(imageList: imageList, heroTag: widget.title),
                  ],
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }

  void pickImage() async {
    XFile? image = await ImagePickerService.pickImage();
    if (image != null) {
      imageList.add(ImageDetails(imagePath: image.path, image: image));
      widget.onTapImage!(imageList);
      setState(() {});
    }
  }
}
