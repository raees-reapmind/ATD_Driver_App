import '../../data/models/asset.dart';
import '../../data/models/bill.dart';

class RoutineTest {
  int id;
  int type;
  int status;
  String name;
  String address;
  int distance;
  int estimatedTime;
  double lat;
  double lng;
  String? poc;
  int? serviceTime;
  String? contactNo;
  DateTime? orderDate;
  double? quantity;
  double? price;
  double? additionalCharges;
  double? pricePerLitre;
  int? paymentMode;
  double? paymentCollected;
  double? endLat;
  double? endLng;
  double? startOdometer;
  double? endOdometer;
  int? actualTime;
  DateTime? arrivedDateTime;
  DateTime? endDateTime;
  double endQuantity;
  String? receiptImage;
  double? invoicePrice;
  String? bunkManagerName;
  String? bunkManagerSignImage;
  double? startTotalizerDuLeft;
  double? startTotalizerDuRight;
  double? endTotalizerDuLeft;
  double? endTotalizerDuRight;

  List<Asset>? assets;

  List<Asset> assetsReport = [];

  List<Bill> bills = [];

  RoutineTest({
    required this.id,
    required this.type,
    required this.status,
    required this.name,
    required this.address,
    required this.lat,
    required this.lng,
    required this.distance,
    required this.estimatedTime,
    this.poc,
    this.serviceTime,
    this.contactNo,
    this.orderDate,
    this.quantity,
    this.price,
    this.additionalCharges,
    this.pricePerLitre,
    this.paymentCollected,
    this.paymentMode,
    this.endLat,
    this.endLng,
    this.startOdometer,
    this.endOdometer,
    this.actualTime,
    this.arrivedDateTime,
    this.endDateTime,
    this.endQuantity = 0,
    this.receiptImage,
    this.invoicePrice,
    this.bunkManagerName,
    this.bunkManagerSignImage,
    this.startTotalizerDuLeft,
    this.endTotalizerDuLeft,
    this.startTotalizerDuRight,
    this.endTotalizerDuRight,
    this.assets,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'status': status,
      'name': name,
      'address': address,
      'distance': distance,
      'estimatedTime': estimatedTime,
      'lat': lat,
      'lng': lng,
      'poc': poc,
      'serviceTime': serviceTime,
      'contactNo': contactNo,
      'orderDate': orderDate,
      'quantity': quantity,
      'price': price,
      'additionalCharges': additionalCharges,
      'pricePerLitre': pricePerLitre,
      'paymentMode': paymentMode,
      'paymentCollected': paymentCollected,
      'endLat': endLat,
      'endLng': endLng,
      'startOdometer': startOdometer,
      'endOdometer': endOdometer,
      'actualTime': actualTime,
      'arrivedDateTime': arrivedDateTime,
      'endDateTime': endDateTime,
      'endQuantity': endQuantity,
      'receiptImage': receiptImage,
      'invoicePrice': invoicePrice,
      'bunkManagerName': bunkManagerName,
      'bunkManagerSignImage': bunkManagerSignImage,
      'startTotalizerDuLeft': startTotalizerDuLeft,
      'endTotalizerDuLeft': endTotalizerDuLeft,
      'endTotalizerDuRight': endTotalizerDuRight,
      'assets': assets?.map((e) => e.toMap()).toList(),
      'bills': bills.map((e) => e.toMap()).toList(),
    };
  }

  factory RoutineTest.fromMap(Map<String, dynamic> map) {
    return RoutineTest(
      id: map['id'],
      type: map['type'],
      status: map['status'],
      name: map['name'],
      address: map['address'],
      lat: map['lat'],
      lng: map['lng'],
      distance: map['distance'],
      estimatedTime: map['estimatedTime'],
      poc: map['poc'],
      serviceTime: map['serviceTime'],
      contactNo: map['contactNo'],
      orderDate: map['orderDate'],
      quantity: map['quantity'],
      price: map['price'],
      additionalCharges: map['additionalCharges'],
      pricePerLitre: map['pricePerLitre'],
      paymentMode: map['paymentMode'],
      paymentCollected: map['paymentCollected'],
      endLat: map['endLat'],
      endLng: map['endLng'],
      startOdometer: map['startOdometer'],
      endOdometer: map['endOdometer'],
      actualTime: map['actualTime'],
      arrivedDateTime: map['arrivedDateTime'],
      endDateTime: map['endDateTime'],
      endQuantity: map['endQuantity'],
      receiptImage: map['receiptImage'],
      invoicePrice: map['invoicePrice'],
      bunkManagerName: map['bunkManagerName'],
      bunkManagerSignImage: map['bunkManagerSignImage'],
      startTotalizerDuLeft: map['startTotalizerDuLeft'],
      endTotalizerDuLeft: map['endTotalizerDuLeft'],
      startTotalizerDuRight: map['startTotalizerDuRight'],
      endTotalizerDuRight: map['endTotalizerDuRight'],
      assets: List.from(['assets']).map((e) => Asset.fromMap(e)).toList(),
    );
  }
}
