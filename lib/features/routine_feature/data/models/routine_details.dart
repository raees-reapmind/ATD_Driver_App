import 'package:atd/features/routine_feature/data/models/plan_details.dart';
import 'package:atd/features/routine_feature/data/models/product_details.dart';
import 'package:atd/features/routine_feature/data/models/routine.dart';
import 'package:atd/features/routine_feature/data/models/vehicle_details.dart';
import '../../../vehicle_readings_feature/data/models/vehicle_details.dart';

class RoutineDetails {
  VehicleDetails vehicleDetails;
  ProductDetails productDetails;
  PlanDetails planDetails;
  List<Routine> routineList;

  RoutineDetails({
    required this.vehicleDetails,
    required this.productDetails,
    required this.planDetails,
    required this.routineList,
  });

  @override
  String toString() {
    return 'RoutineDetails{vehicleDetails: $vehicleDetails, productDetails: $productDetails, planDetails: $planDetails, routineList: $routineList}';
  }

  factory RoutineDetails.fromMap(Map<String, dynamic> data) {
    return RoutineDetails(
      vehicleDetails: VehicleDetails.fromMap(data['vehicle']),
      productDetails: ProductDetails.fromMap(data['product']),
      planDetails: PlanDetails.fromMap(data['plan']),
      routineList: List<Map<String, dynamic>>.from(data['routines'])
          .map((e) => Routine.fromMap(e))
          .toList(),
    );
  }
}
