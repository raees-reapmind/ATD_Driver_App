// import 'package:atd/features/vehicle_checks_feature/data/models/vehicle_check_model.dart';
// import 'package:atd/features/vehicle_checks_feature/domain/entities/vehicle_check.dart';
// import 'package:atd/features/vehicle_checks_feature/domain/entities/vehicle_check_list.dart';
//
// class VehicleCheckListModel extends VehicleCheckList {
//   const VehicleCheckListModel(
//       {required List<VehicleCheck> vehicleCheckList})
//       : super(vehicleChecks: vehicleCheckList);
//
//   factory VehicleCheckListModel.fromJson(List<Map<String, dynamic>> jsonList) {
//     return VehicleCheckListModel(
//         vehicleCheckList:
//             jsonList.map((e) => VehicleModel.fromMap(e)).toList());
//   }
//
//   List<Map<String, dynamic>> toJson() {
//     return List.generate(
//         vehicleChecks.length,
//         (index) => {
//               'name': vehicleChecks[index].name,
//               'status': vehicleChecks[index].status,
//             });
//   }
// }
