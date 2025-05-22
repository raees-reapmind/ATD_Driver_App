// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dispenser_check.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DispenserCheckAdapter extends TypeAdapter<DispenserCheck> {
  @override
  final int typeId = 3;

  @override
  DispenserCheck read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DispenserCheck(
      dispensedFrom: fields[0] as String,
      dispensedTo: fields[1] as String,
      quantitySelected: fields[2] as double,
      quantityDispensed: fields[3] as double,
      imageList: (fields[4] as List?)?.cast<ImageDetails>(),
      duReadings: fields[6] as double?,
    );
  }

  @override
  void write(BinaryWriter writer, DispenserCheck obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.dispensedFrom)
      ..writeByte(1)
      ..write(obj.dispensedTo)
      ..writeByte(2)
      ..write(obj.quantitySelected)
      ..writeByte(3)
      ..write(obj.quantityDispensed)
      ..writeByte(4)
      ..write(obj.imageList)
      ..writeByte(6)
      ..write(obj.duReadings);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DispenserCheckAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
