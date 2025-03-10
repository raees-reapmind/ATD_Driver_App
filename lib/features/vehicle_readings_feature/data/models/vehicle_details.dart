import 'package:atd/features/vehicle_readings_feature/data/models/image_details.dart';

class VehicleReadings {
  double? remoteOdometer;
  double? odometer;
  double? remoteTotalizeDuLeft;
  double? totalizeDuLeft;
  double? remoteTotalizeDuRight;
  double? totalizeDuRight;
  DateTime? remoteDateTime;
  DateTime? dateTime;
  double? remoteFuelLevel;
  double? fuelLevel;
  List<ImageDetails> imageDetailsList = [];

  String? referenceType;
  String? referenceId;

  VehicleReadings({
    this.remoteOdometer,
    this.odometer,
    this.remoteTotalizeDuLeft,
    this.totalizeDuLeft,
    this.remoteTotalizeDuRight,
    this.totalizeDuRight,
    this.remoteDateTime,
    this.dateTime,
    this.remoteFuelLevel,
    this.fuelLevel,
    this.referenceType,
    this.referenceId
  });

  @override
  toString() {
    return 'VehicleReadings{ remoteOdometer : $remoteOdometer, remoteTotalizeDuLeft : $remoteTotalizeDuLeft, remoteTotalizeDuRight : $remoteTotalizeDuRight, remoteFuelLevel : $remoteFuelLevel , referenceType : $referenceType, referenceId : $referenceId }';
  }

  Map<String, dynamic> toMap() {
    return {
      'odometer': odometer,
      'totalizer_du1': totalizeDuLeft,
      'totalizer_du2': totalizeDuRight,
      'image': imageDetailsList.map((e) => e.imageId).toList(),
      'reference_type': referenceType, // New key
      'reference_id': referenceId ?? '', // Default empty string if null    
    };
  }

  factory VehicleReadings.fromMap(Map<String, dynamic> value) {
    return VehicleReadings(
      remoteOdometer: double.tryParse(value['odometer'].toString()),
      remoteTotalizeDuLeft: double.tryParse(value['totalizer_du1'].toString()),
      remoteTotalizeDuRight: double.tryParse(value['totalizer_du2'].toString()),
      remoteFuelLevel: double.tryParse(value['fuel_level'].toString()),
      referenceType: value['reference_type'],
      // referenceId: value['reference_id'], // Extract new key
      referenceId: value['reference_id'], // Extract new key
    );
  }
}
