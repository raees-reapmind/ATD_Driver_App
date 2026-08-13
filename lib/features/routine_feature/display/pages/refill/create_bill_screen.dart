import 'dart:io';
import 'package:atd/core/services/image_picker_service.dart';
import 'package:atd/features/image_upload_feature/display/providers/image_upload_provider.dart';
import 'package:atd/features/login_feature/display/provider/login_provider.dart';
import 'package:atd/features/vehicle_readings_feature/data/models/image_details.dart';
import 'package:atd/utils/widgets/image_list_view.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../../../../utils/utils_export.dart';
import '../../../../../utils/widgets/image_full_screen_view.dart';
import '../../providers/routines_provider.dart';

class CreateBillScreen extends StatefulWidget {
  final int index;

  const CreateBillScreen({Key? key, required this.index}) : super(key: key);

  @override
  State<CreateBillScreen> createState() => _CreateBillScreenState();
}

class _CreateBillScreenState extends State<CreateBillScreen> {
  final ImagePicker picker = ImagePicker();
  final quantityController = TextEditingController();
  final assetOdometerController = TextEditingController();
  ImageDetails? image;
  bool _isSavingBill = false;

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
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Card(
                    color: white500,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(height: 10),
                          Center(
                            child: Text("Add Bill",
                                style: Theme.of(context).textTheme.titleMedium),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: Text(
                                  "Quantity",
                                  style: Theme.of(context).textTheme.titleMedium,
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: CustomTextField(
                                  controller: quantityController,
                                  hintText: 'Enter Quantity',
                                  isNumber: true,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          ListTile(
                            contentPadding: const EdgeInsets.all(0),
                            title: Text(
                              "Upload image",
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            subtitle: const Text(
                                "Kindly upload the images of DU receipt"),
                            trailing: IconButton(
                                onPressed: () async {
                                  await ImagePickerService.pickImage()
                                      .then((value) {
                                    if (value != null) {
                                      setState(() {
                                        image = ImageDetails(
                                            image: value,
                                            imagePath: value.path);
                                      });
                                    }
                                  });
                                },
                                icon: const Icon(Icons.camera_alt)),
                          ),
                          const SizedBox(height: 10),
                          image != null
                              ? ImageListView(
                                  imageList: [image!], heroTag: 'bill')
                              : const SizedBox.shrink(),
                          const SizedBox(height: 10),
                          CustomButton(
                              onTap: () => saveClickEvent(
                                    context: context,
                                    image: image,
                                    quantity: double.tryParse(
                                        quantityController.text),
                                    loginProvider: loginProvider,
                                    routinesProvider: routineProvider,
                                    imageUploadProvider: imageUploadProvider,
                                    index: widget.index,
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

  void saveClickEvent(
      {required int index,
      required double? quantity,
      required BuildContext context,
      required LoginProvider loginProvider,
      required RoutinesProvider routinesProvider,
      required ImageUploadProvider imageUploadProvider,
      ImageDetails? image}) async {
    if (_isSavingBill) return;
    setState(() {
      _isSavingBill = true;
    });

    try {
      final result = await routinesProvider.createBill(
          loginProvider: loginProvider,
          image: image,
          imageUploadProvider: imageUploadProvider,
          index: index,
          quantity: quantity);

      switch (result) {
        case Result.quantityFormat:
          showSnackBar(
              context: context, message: "Please enter right quantity format");
          break;
        case Result.quantityGreater:
          showSnackBar(
              context: context,
              message:
                  "Quantity cannot be greater than the total refuel quantity");
          break;
        case Result.image:
          showSnackBar(
              context: context, message: "Please upload the image of the bill");
          break;
        case Result.imageUpload:
          showSnackBar(context: context, message: "Failed to upload image");
          break;
        case Result.success:
          showSnackBar(context: context, message: "Bill Added");
          Navigator.of(context).pop();
          break;
      }
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

  Widget imageView() {
    if (image != null) {
      return Align(
        alignment: AlignmentDirectional.centerEnd,
        child: InkWell(
          onTap: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ImageView(
              imagePath: image!.imagePath!,
              hero: '',
              index: 1,
            ),
          )),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Hero(
              tag: "image",
              child: Image.file(
                File(image!.imagePath!),
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
