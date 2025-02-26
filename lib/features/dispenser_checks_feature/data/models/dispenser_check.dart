import 'package:atd/features/vehicle_readings_feature/data/models/image_details.dart';
import 'package:hive/hive.dart';
part 'dispenser_check.g.dart';

@HiveType(typeId: 3)
class DispenserCheck {
  @HiveField(0)
  final String dispensedFrom;
  @HiveField(1)
  final String dispensedTo;
  @HiveField(2)
  final double quantitySelected;
  @HiveField(3)
  final double quantityDispensed;
  @HiveField(4)
  List<ImageDetails>? imageList;
  @HiveField(6)
  final double? duReadings;

  DispenserCheck({
    required this.dispensedFrom,
    required this.dispensedTo,
    required this.quantitySelected,
    required this.quantityDispensed,
    this.imageList,
    this.duReadings
  });

  @override
  String toString() {
    return 'DispenserCheck{dispensedFrom: $dispensedFrom, dispensedTo: $dispensedTo, quantitySelected: $quantitySelected, quantityDispensed: $quantityDispensed, imageList: $imageList, duReadings: $duReadings}';
  }

  Map<String, dynamic> toMap() {
    return {
      'from_type': dispensedFrom,
      'to_type': dispensedTo,
      'quantity_requested': quantitySelected,
      'quantity_dispensed': quantityDispensed,
      'image': imageList?.map((e) => e.imageId).toList(),
      'du_readings': duReadings
    };
  }

  factory DispenserCheck.fromMap(Map<String, dynamic> json) {
    return DispenserCheck(
      dispensedFrom: json['dispenserFrom'],
      dispensedTo: json['dispensedTo'],
      quantitySelected: json['quantitySelected'],
      quantityDispensed: json['quantityDispensed'],
      duReadings: json['duReadings'],
    );
  }
}
