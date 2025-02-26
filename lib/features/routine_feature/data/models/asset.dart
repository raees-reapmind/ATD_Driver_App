import 'package:atd/features/vehicle_readings_feature/data/models/image_details.dart';
import 'package:hive/hive.dart';

part 'asset.g.dart';

@HiveType(typeId: 6)
class Asset {
  @HiveField(1)
  int? id;
  @HiveField(2)
  String name;
  @HiveField(3)
  String qrCode;
  @HiveField(4)
  String type;
  @HiveField(5)
  double? quantity;
  @HiveField(6)
  double? capacity;
  @HiveField(7)
  double? endQuantity;
  @HiveField(8)
  double? odometer;
  @HiveField(9)
  int? receiptImage;
  @HiveField(10)
  List<ImageDetails> images = [];

  Asset({
    required this.id,
    required this.name,
    required this.type,
    required this.qrCode,
    this.quantity,
    this.endQuantity,
    this.odometer,
    this.receiptImage,
    this.capacity,
  });

  @override
  String toString() {
    return 'Asset{id: $id, name: $name, qrCode: $qrCode, type: $type, quantity: $quantity, capacity: $capacity, endQuantity: $endQuantity, odometer: $odometer, images : $images}';
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'product_id': 1,
      'quantity': endQuantity,
      'odometer': odometer,
      'image': images.map((e) => e.imageId).toList(),
    };
  }

  factory Asset.fromMap(Map<String, dynamic> value) {
    return Asset(
      id: value['id'],
      name: value['name'],
      type: value['type'],
      quantity: value['ordered_quantity'] != null
          ? double.parse(value['ordered_quantity'].toString())
          : null,
      qrCode: value['qr'],
      capacity: double.parse(value['capacity'].toString()),
    );
  }
}
