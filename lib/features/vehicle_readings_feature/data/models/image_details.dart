import 'package:image_picker/image_picker.dart';

class ImageDetails {
  String? imagePath;
  int? imageId;
  XFile? image;


  @override
  String toString() {
    return 'ImageDetails{imagePath: $imagePath, imageId: $imageId, image: $image}';
  }

  ImageDetails({this.imageId, this.imagePath, this.image});
}