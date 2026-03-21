// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'offline_request_hive.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OfflineRequestHiveAdapter extends TypeAdapter<OfflineRequestHive> {
  @override
  final typeId = 4;

  @override
  OfflineRequestHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OfflineRequestHive(
      method: fields[0] as String,
      endPoint: fields[1] as String,
      body: (fields[2] as Map?)?.cast<String, dynamic>(),
      queryParameters: (fields[3] as Map?)?.cast<String, dynamic>(),
      createdAt: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, OfflineRequestHive obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.method)
      ..writeByte(1)
      ..write(obj.endPoint)
      ..writeByte(2)
      ..write(obj.body)
      ..writeByte(3)
      ..write(obj.queryParameters)
      ..writeByte(5)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OfflineRequestHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
