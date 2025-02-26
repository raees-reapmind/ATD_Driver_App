// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'routine.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RoutineAdapter extends TypeAdapter<Routine> {
  @override
  final int typeId = 4;

  @override
  Routine read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Routine(
      id: fields[1] as int,
      type: fields[2] as String,
      name: fields[3] as String,
      pocName: fields[4] as String,
      address: fields[6] as String,
      latitude: fields[8] as double,
      longitude: fields[9] as double,
      status: fields[10] as String,
      statusCode: fields[11] as int,
      pocMobile: fields[5] as String?,
      distance: fields[7] as double?,
      serviceTime: fields[12] as int?,
      quantity: fields[13] as double?,
      date: fields[15] as String?,
      pricePerLitre: fields[16] as double?,
      price: fields[17] as double?,
      assetList: (fields[20] as List?)?.cast<Asset>(),
      paymentMode: fields[14] as String?,
      odometerReading: fields[19] as double?,
      arrivedDatetime: fields[23] as DateTime?,
      endDateTime: fields[24] as DateTime?,
      recieverName: fields[26] as String?,
      paymentCollected: fields[37] as bool?,
    )
      ..endQuantity = fields[18] as double
      ..assetsReport = (fields[21] as List).cast<Asset>()
      ..bills = (fields[22] as List).cast<Bill>()
      ..refillReportList = (fields[25] as List).cast<Bill>()
      ..endLatitude = fields[27] as double?
      ..endLongitude = fields[28] as double?
      ..receiverSignatureImage = fields[29] as Image?
      ..startTotalizerDuLeft = fields[30] as double?
      ..startTotalizerDuRight = fields[31] as double?
      ..endTotalizerDuLeft = fields[32] as double?
      ..endTotalizerDuRight = fields[33] as double?
      ..additionalChargesList = (fields[35] as List?)?.cast<AdditionCharge>()
      ..endPrice = fields[36] as double?;
  }

  @override
  void write(BinaryWriter writer, Routine obj) {
    writer
      ..writeByte(36)
      ..writeByte(1)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.name)
      ..writeByte(4)
      ..write(obj.pocName)
      ..writeByte(5)
      ..write(obj.pocMobile)
      ..writeByte(6)
      ..write(obj.address)
      ..writeByte(7)
      ..write(obj.distance)
      ..writeByte(8)
      ..write(obj.latitude)
      ..writeByte(9)
      ..write(obj.longitude)
      ..writeByte(10)
      ..write(obj.status)
      ..writeByte(11)
      ..write(obj.statusCode)
      ..writeByte(12)
      ..write(obj.serviceTime)
      ..writeByte(13)
      ..write(obj.quantity)
      ..writeByte(14)
      ..write(obj.paymentMode)
      ..writeByte(15)
      ..write(obj.date)
      ..writeByte(16)
      ..write(obj.pricePerLitre)
      ..writeByte(17)
      ..write(obj.price)
      ..writeByte(18)
      ..write(obj.endQuantity)
      ..writeByte(19)
      ..write(obj.odometerReading)
      ..writeByte(20)
      ..write(obj.assetList)
      ..writeByte(21)
      ..write(obj.assetsReport)
      ..writeByte(22)
      ..write(obj.bills)
      ..writeByte(23)
      ..write(obj.arrivedDatetime)
      ..writeByte(24)
      ..write(obj.endDateTime)
      ..writeByte(25)
      ..write(obj.refillReportList)
      ..writeByte(26)
      ..write(obj.recieverName)
      ..writeByte(27)
      ..write(obj.endLatitude)
      ..writeByte(28)
      ..write(obj.endLongitude)
      ..writeByte(29)
      ..write(obj.receiverSignatureImage)
      ..writeByte(30)
      ..write(obj.startTotalizerDuLeft)
      ..writeByte(31)
      ..write(obj.startTotalizerDuRight)
      ..writeByte(32)
      ..write(obj.endTotalizerDuLeft)
      ..writeByte(33)
      ..write(obj.endTotalizerDuRight)
      ..writeByte(35)
      ..write(obj.additionalChargesList)
      ..writeByte(36)
      ..write(obj.endPrice)
      ..writeByte(37)
      ..write(obj.paymentCollected);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RoutineAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
