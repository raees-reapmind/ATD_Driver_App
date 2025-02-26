import 'package:atd/features/dispenser_feature/domain/entities/dispenser_report.dart';

class DispenserReportModel extends DispenserReport {
  DispenserReportModel({
    required super.dispenserName,
    required super.assetId,
    required super.quantitySelected,
    required super.quantityDispensed,
    required super.image,
    required super.dateTime,
  });

  Map<String, dynamic> toJson() {
    return {
      'dispenserName': dispenserName,
      'assetId': assetId,
      'quantitySelected': quantitySelected,
      'quantityDispensed': quantityDispensed,
      'image': image,
      'dateTime': dateTime,
    };
  }

  factory DispenserReportModel.fromJson(Map<String, dynamic> json) {
    return DispenserReportModel(
      dispenserName: json['dispenserName'],
      assetId: json['assetId'],
      quantitySelected: json['quantitySelected'],
      quantityDispensed: json['quantityDispensed'],
      image: json['image'],
      dateTime: json['dateTime'],
    );
  }
}
