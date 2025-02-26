import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerService {
  static Future<XFile?> pickImage() async {
    try {
      XFile? image = await ImagePicker()
          .pickImage(source: ImageSource.camera, imageQuality: 30);
      return image;
    } catch (e) {
      debugPrint("error : ${e.toString()}");
    }
    return null;
  }
}
