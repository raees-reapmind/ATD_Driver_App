import 'package:hive/hive.dart';
part 'vehicle_check.g.dart';

@HiveType(typeId: 2)
class VehicleCheck {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  int status; // 1 -> GREEN  | 2 -> YELLOW  | 3 -> RED

  VehicleCheck({required this.id, required this.name, this.status = 0});


  @override
  String toString() {
    return 'VehicleCheck{id: $id, name: $name, status: $status}';
  }

  factory VehicleCheck.fromMap(Map<String, dynamic> map) {
    return VehicleCheck(
      id: map['id'],
      name: map['name'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'status': status,
    };
  }


  factory VehicleCheck.fromJson(Map<String, dynamic> json) {
    return VehicleCheck(
      id: json['id'],
      name: json['name'],
      status: json['status'],
    );
  }

  // Add this:
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'status': status,
    };
  }

  
}
