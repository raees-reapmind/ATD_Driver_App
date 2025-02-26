import 'package:equatable/equatable.dart';

class Location extends Equatable {
  final String vehicleRegNo;
  final double latitude;
  final double longitude;
  final double accuracy;
  final double altitude;
  final double speed;
  final double speedAccuracy;
  final DateTime timestamp;

  const Location({
    required this.vehicleRegNo,
    required this.latitude,
    required this.longitude,
    required this.accuracy,
    required this.altitude,
    required this.speed,
    required this.speedAccuracy,
    required this.timestamp,
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

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
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

  @override
  List<Object?> get props => [
        vehicleRegNo,
        latitude,
        longitude,
        accuracy,
        altitude,
        speed,
        speedAccuracy,
        timestamp,
      ];
}
