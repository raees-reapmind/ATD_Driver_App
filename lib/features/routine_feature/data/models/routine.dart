import 'dart:ui';
import 'package:atd/features/routine_feature/data/models/additonal_charge.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import '../../../vehicle_readings_feature/data/models/image_details.dart';
import 'asset.dart';
import 'bill.dart';

part 'routine.g.dart';

@HiveType(typeId: 4)
class Routine {
  @HiveField(1)
  int id;
  @HiveField(2)
  String type;
  @HiveField(3)
  String name;
  @HiveField(4)
  String pocName;
  @HiveField(5)
  String? pocMobile;
  @HiveField(6)
  String address;
  @HiveField(7)
  double? distance;
  @HiveField(8)
  double latitude;
  @HiveField(9)
  double longitude;
  @HiveField(10)
  String status;
  @HiveField(11)
  int statusCode;
  @HiveField(12)
  int? serviceTime;
  @HiveField(13)
  double? quantity;
  @HiveField(14)
  String? paymentMode;
  @HiveField(15)
  String? date;
  @HiveField(16)
  num? pricePerLitre;
  @HiveField(17)
  double? price;
  @HiveField(18)
  double endQuantity = 0;
  @HiveField(19)
  double? odometerReading;
  @HiveField(20)
  List<Asset>? assetList;
  @HiveField(21)
  List<Asset> assetsReport = [];
  @HiveField(22)
  List<Bill> bills = [];
  @HiveField(23)
  DateTime? arrivedDatetime;
  @HiveField(24)
  DateTime? endDateTime;
  @HiveField(25)
  List<Bill> refillReportList = [];
  @HiveField(26)
  String? recieverName;
  @HiveField(27)
  double? endLatitude;
  @HiveField(28)
  double? endLongitude;
  @HiveField(29)
  Image? receiverSignatureImage;
  @HiveField(30)
  double? startTotalizerDuLeft;
  @HiveField(31)
  double? startTotalizerDuRight;
  @HiveField(32)
  double? endTotalizerDuLeft;
  @HiveField(33)
  double? endTotalizerDuRight;
  List<ImageDetails> imageList = [];
  @HiveField(35)
  List<AdditionCharge>? additionalChargesList;
  @HiveField(36)
  double? endPrice;
  @HiveField(37)
  bool? paymentCollected;
  @HiveField(38)
  bool? otp;


  Routine({
    required this.id,
    required this.type,
    required this.name,
    required this.pocName,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.status,
    required this.statusCode,
    this.pocMobile,
    this.distance,
    this.serviceTime,
    this.quantity,
    this.date,
    this.pricePerLitre,
    this.price,
    this.assetList,
    this.paymentMode,
    this.odometerReading,
    this.arrivedDatetime,
    this.endDateTime,
    this.recieverName,
    this.paymentCollected,
    this.otp,
  });

  @override
  String toString() {
    return 'Routine{id: $id, type: $type, name: $name, pocName: $pocName, pocMobile: $pocMobile, address: $address, distance: $distance, latitude: $latitude, longitude: $longitude, status: $status, statusCode: $statusCode, serviceTime: $serviceTime, quantity: $quantity, paymentMode: $paymentMode, date: $date, pricePerLitre: $pricePerLitre, price: $price, endQuantity: $endQuantity, odometerReading: $odometerReading, assetList: $assetList, assetsReport: $assetsReport, bills: $bills, arrivedDatetime: $arrivedDatetime, endDateTime: $endDateTime, refillReportList: $refillReportList, recieverName: $recieverName, endLatitude: $endLatitude, endLongitude: $endLongitude, receiverSignatureImage: $receiverSignatureImage, startTotalizerDuLeft: $startTotalizerDuLeft, startTotalizerDuRight: $startTotalizerDuRight, endTotalizerDuLeft: $endTotalizerDuLeft, endTotalizerDuRight: $endTotalizerDuRight, receiptImage: $imageList, additionalChargesList: $additionalChargesList, endPrice: $endPrice, otp: $otp}';
  }

  factory Routine.fromMap(Map<String, dynamic> value) {
    return Routine(
        id: value['routine_id'],
        type: value['type'],
        name: value['name'],
        pocName: value['poc_name'],
        address: value['address'],
        latitude: value['latitude'],
        longitude: value['longitude'],
        status: value['status'],
        statusCode: value['status_code'],
        pocMobile: value['poc_mobile'],
        otp: value['otp'],
        distance:
            value['distance'] != null ? double.parse(value['distance']) : null,
        serviceTime: value['service_time'],
        quantity:
            value['quantity'] != null ? double.parse(value['quantity']) : null,
        paymentMode: value['payment_mode'],
        date: value['order_date'],
        pricePerLitre: value['product_rate'],
        price: value['total_bill'] != null
            ? double.parse(value['total_bill'].toString())
            : null,
        assetList: List<Map<String, dynamic>>.from(value['assets'] ?? [])
            .map((e) => Asset.fromMap(e))
            .toList());
  }

  Map<String, dynamic> toStartTripMap() {
    return {'routine_id': id, 'odometer': odometerReading, 'du_left': startTotalizerDuLeft,'du_right' : startTotalizerDuRight };
  }

  Map<String, dynamic> toEndTripMap() {
    return {
      'routine_id': id,
      'odometer': odometerReading,
      'du_left': endTotalizerDuLeft,
      'du_right': endTotalizerDuRight,
      'latitude': endLatitude,
      'longitude': endLongitude,
      'end_date_time': endDateTime != null
          ? DateFormat('yyyy-MM-dd hh:mm:ss').format(endDateTime!)
          : '',
      'image': imageList.map((e) => e.imageId).toList(),
    };
  }

  Map<String, dynamic> toRefillMap() {
    return {
      'routine_id': id,
      'odometer': odometerReading,
      'refill_list': bills.map((e) => e.toMap()).toList(),
      'latitude': endLatitude,
      'longitude': endLongitude,
      'arrived_date_time': arrivedDatetime != null
          ? DateFormat('yyyy-MM-dd hh:mm:ss').format(arrivedDatetime!)
          : '',
      'end_date_time': endDateTime != null
          ? DateFormat('yyyy-MM-dd hh:mm:ss').format(endDateTime!)
          : '',
      'service_time': serviceTime,
    };
  }

  Map<String, dynamic> toDeliveryMap() {
    return {
      'routine_id': id,
      'odometer': odometerReading,
      'start_du_left': startTotalizerDuLeft,
      'start_du_right': startTotalizerDuRight,
      'end_du_left': endTotalizerDuLeft,
      'end_du_right': endTotalizerDuRight,
      'dispensed_list': assetsReport.map((e) => e.toMap()).toList(),
      'latitude': endLatitude,
      'longitude': endLongitude,
      'arrived_date_time': arrivedDatetime != null
          ? DateFormat('yyyy-MM-dd hh:mm:ss').format(arrivedDatetime!)
          : '',
      'end_date_time': endDateTime != null
          ? DateFormat('yyyy-MM-dd hh:mm:ss').format(endDateTime!)
          : '',
      'service_time': serviceTime,
      'receipt_image': imageList.map((e) => e.imageId).toList(),
      'payment_collected': true,
    };
  }

  Map<String, dynamic> toBillMap() {
    return {
      'routine_id': id,
      'quantity': endQuantity,
    };
  }
}
