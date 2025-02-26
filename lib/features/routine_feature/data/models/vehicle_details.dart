class VehicleDetails {
  final int id;
  final String vehicleRegNo;
  final String make;
  final String model;
  final double tankCapacity;
  final double availableQuantity;

  VehicleDetails({
    required this.id,
    required this.vehicleRegNo,
    required this.make,
    required this.model,
    required this.tankCapacity,
    required this.availableQuantity,
  });

  @override
  String toString() {
    return 'VehicleDetails{id: $id, vehicleRegNo: $vehicleRegNo, make: $make, model: $model, tankCapacity: $tankCapacity, availableQuantity: $availableQuantity}';
  }

  factory VehicleDetails.fromMap(Map<String, dynamic> data) {
    return VehicleDetails(
      id: data['id'],
      vehicleRegNo: data['reg_number'],
      make: data['make'],
      model: data['model'],
      tankCapacity: double.parse(data['tank_capacity'].toString()),
      availableQuantity: double.parse(data['available_quantity'].toString()),
    );
  }
}
