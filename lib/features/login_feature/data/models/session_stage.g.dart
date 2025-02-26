// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_stage.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SessionStageAdapter extends TypeAdapter<SessionStage> {
  @override
  final int typeId = 7;

  @override
  SessionStage read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return SessionStage.login;
      case 1:
        return SessionStage.loginDetails;
      case 2:
        return SessionStage.vehicleChecks;
      case 3:
        return SessionStage.dispenserChecks;
      case 4:
        return SessionStage.dashboard;
      case 5:
        return SessionStage.logout;
      default:
        return SessionStage.login;
    }
  }

  @override
  void write(BinaryWriter writer, SessionStage obj) {
    switch (obj) {
      case SessionStage.login:
        writer.writeByte(0);
        break;
      case SessionStage.loginDetails:
        writer.writeByte(1);
        break;
      case SessionStage.vehicleChecks:
        writer.writeByte(2);
        break;
      case SessionStage.dispenserChecks:
        writer.writeByte(3);
        break;
      case SessionStage.dashboard:
        writer.writeByte(4);
        break;
      case SessionStage.logout:
        writer.writeByte(5);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SessionStageAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
