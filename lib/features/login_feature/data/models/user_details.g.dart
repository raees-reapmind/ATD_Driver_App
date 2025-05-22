// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_details.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserDetailsAdapter extends TypeAdapter<UserDetails> {
  @override
  final int typeId = 1;

  @override
  UserDetails read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserDetails(
      phoneNo: fields[0] as String,
      vehicleRegNo: fields[1] as String,
      dateTime: fields[3] as DateTime,
      apiToken: fields[4] as String?,
      otp: fields[2] as String?,
      deviceName: fields[5] as String?,
      step: fields[7] as int?,
    )..sessionStage = fields[6] as SessionStage;
  }

  @override
  void write(BinaryWriter writer, UserDetails obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.phoneNo)
      ..writeByte(1)
      ..write(obj.vehicleRegNo)
      ..writeByte(2)
      ..write(obj.otp)
      ..writeByte(3)
      ..write(obj.dateTime)
      ..writeByte(4)
      ..write(obj.apiToken)
      ..writeByte(5)
      ..write(obj.deviceName)
      ..writeByte(6)
      ..write(obj.sessionStage)
      ..writeByte(7)
      ..write(obj.step);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserDetailsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
