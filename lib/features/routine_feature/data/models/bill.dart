import 'package:hive/hive.dart';

import '../../../vehicle_readings_feature/data/models/image_details.dart';

part 'bill.g.dart';

@HiveType(typeId: 5)
class Bill {
  @HiveField(1)
  int id;
  @HiveField(2)
  double quantity;
  @HiveField(3)
  ImageDetails? image;
  @HiveField(4)
  int productId;

  Bill({
    required this.id,
    required this.quantity,
    required this.image,
    this.productId = 1,
  });

  @override
  String toString() {
    return 'Bill{id: $id, quantity: $quantity, image: $image, productId: $productId}';
  }

  factory Bill.fromMap(Map<String, dynamic> map) {
    return Bill(
      id: map['id'],
      quantity: map['quantity'],
      image: map['image'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'quantity': quantity,
      'product_id': productId,
      'imageId': image?.imageId,
    };
  }
}
