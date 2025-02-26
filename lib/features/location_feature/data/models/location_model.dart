import 'package:atd/features/location_feature/domain/entities/location.dart';

class LocationModel extends Location {
  const LocationModel({
    required super.vehicleRegNo,
    required super.latitude,
    required super.longitude,
    required super.accuracy,
    required super.altitude,
    required super.speed,
    required super.speedAccuracy,
    required super.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'vehicleRegNo': vehicleRegNo,
      'latitude': latitude,
      'longitude': longitude,
      'accuracy': accuracy,
      'altitude': altitude,
      'speed': speed,
      'speedAccuracy': speedAccuracy,
      'timestamp': timestamp,
    };
  }

  factory LocationModel.fromMap(Map<String, dynamic> json) {
    return LocationModel(
      vehicleRegNo: json['vehicleRegNo'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      accuracy: json['accuracy'],
      altitude: json['altitude'],
      speed: json['speed'],
      speedAccuracy: json['speedAccuracy'],
      timestamp: json['timestamp'],
    );
  }
}
