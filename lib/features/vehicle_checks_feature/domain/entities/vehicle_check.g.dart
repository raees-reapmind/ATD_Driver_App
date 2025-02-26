// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vehicle_check.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class VehicleCheckAdapter extends TypeAdapter<VehicleCheck> {
  @override
  final int typeId = 2;

  @override
  VehicleCheck read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return VehicleCheck(
      id: fields[0] as int,
      name: fields[1] as String,
      status: fields[2] as int,
    );
  }

  @override
  void write(BinaryWriter writer, VehicleCheck obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.status);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VehicleCheckAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
