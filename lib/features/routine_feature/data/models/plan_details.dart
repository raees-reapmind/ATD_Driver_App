import 'package:intl/intl.dart';

class PlanDetails {
  final int id;
  final int shift;
  final int totalOrders;
  final double totalQuantity;
  final DateTime startDateTime;

  PlanDetails({
    required this.id,
    required this.shift,
    required this.totalOrders,
    required this.totalQuantity,
    required this.startDateTime,
  });

  @override
  String toString() {
    return 'PlanDetails{id: $id, shift: $shift, totalOrders: $totalOrders, totalQuantity: $totalQuantity, startDateTime: $startDateTime}';
  }

  factory PlanDetails.fromMap(Map<String, dynamic> data) {
    return PlanDetails(
      id: data['id'],
      shift: int.parse(data['shift']),
      totalOrders: data['total_order'],
      totalQuantity: data['total_quantity'] != null
          ? double.parse(data['total_quantity'].toString())
          : 0,
      startDateTime: DateFormat('yyyy-MM-dd hh:mm:ss')
          .parse(data['report_time'].toString()),
    );
  }
}
