import 'package:equatable/equatable.dart';

class DispenserReport extends Equatable {
  String dispenserName;
  int assetId;
  double quantitySelected;
  double quantityDispensed;
  String image;
  DateTime dateTime;

  DispenserReport({
    required this.dispenserName,
    required this.assetId,
    required this.quantitySelected,
    required this.quantityDispensed,
    required this.image,
    required this.dateTime,
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

  factory DispenserReport.fromJson(Map<String, dynamic> json) {
    return DispenserReport(
      dispenserName: json['dispenserName'],
      assetId: json['assetId'],
      quantitySelected: json['quantitySelected'],
      quantityDispensed: json['quantityDispensed'],
      image: json['image'],
      dateTime: json['dateTime'],
    );
  }

  @override
  List<Object?> get props => [
        dispenserName,
        assetId,
        quantitySelected,
        quantityDispensed,
        image,
        dateTime,
      ];
}
