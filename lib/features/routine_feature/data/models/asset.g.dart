// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'asset.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AssetAdapter extends TypeAdapter<Asset> {
  @override
  final int typeId = 6;

  @override
  Asset read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Asset(
      id: fields[1] as int?,
      name: fields[2] as String,
      type: fields[4] as String,
      qrCode: fields[3] as String,
      quantity: fields[5] as double?,
      endQuantity: fields[7] as double?,
      odometer: fields[8] as double?,
      receiptImage: fields[9] as int?,
      capacity: fields[6] as double?,
      subjectType: fields[11] as String?,
    )..images = (fields[10] as List).cast<ImageDetails>();
  }

  @override
  void write(BinaryWriter writer, Asset obj) {
    writer
      ..writeByte(11)
      ..writeByte(1)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.qrCode)
      ..writeByte(4)
      ..write(obj.type)
      ..writeByte(5)
      ..write(obj.quantity)
      ..writeByte(6)
      ..write(obj.capacity)
      ..writeByte(7)
      ..write(obj.endQuantity)
      ..writeByte(8)
      ..write(obj.odometer)
      ..writeByte(9)
      ..write(obj.receiptImage)
      ..writeByte(10)
      ..write(obj.images)
      ..writeByte(11)
      ..write(obj.subjectType);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AssetAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
