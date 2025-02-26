import 'package:atd/features/login_feature/data/models/session_stage.dart';
import 'package:hive/hive.dart';
part 'user_details.g.dart';

@HiveType(typeId: 1)
class UserDetails {
  @HiveField(0)
  final String phoneNo;
  @HiveField(1)
  final String vehicleRegNo;
  @HiveField(2)
  final String? otp;
  @HiveField(3)
  final DateTime dateTime;
  @HiveField(4)
  final String? apiToken;
  @HiveField(5)
  final String? deviceName;
  @HiveField(6)
  SessionStage sessionStage = SessionStage.login;

  UserDetails({
    required this.phoneNo,
    required this.vehicleRegNo,
    required this.dateTime,
    this.apiToken,
    this.otp,
    this.deviceName,
  });


  @override
  String toString() {
    return 'UserDetails{phoneNo: $phoneNo, vehicleRegNo: $vehicleRegNo, otp: $otp, dateTime: $dateTime, apiToken: $apiToken, deviceName: $deviceName, sessionStage: $sessionStage}';
  }

  Map<String, dynamic> toMap() {
    return {
      'mobile': phoneNo,
      'vehicle_no': vehicleRegNo,
      'otp': otp,
      'device_name': deviceName,
    };
  }

  factory UserDetails.fromMap(Map<String, dynamic> json) {
    return UserDetails(
      phoneNo: json['phoneNo'],
      vehicleRegNo: json['vehicleRegNo'],
      dateTime: json['dateTime'],
      apiToken: json['apiToken'],
    );
  }
}
