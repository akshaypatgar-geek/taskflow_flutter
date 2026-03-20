// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_details_hive.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserDetailsHiveAdapter extends TypeAdapter<UserDetailsHive> {
  @override
  final typeId = 1;

  @override
  UserDetailsHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserDetailsHive(
      userId: fields[0] as String,
      userName: fields[1] as String?,
      userEmail: fields[2] as String,
      userStatus: fields[3] as String?,
      profilePicture: fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, UserDetailsHive obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.userId)
      ..writeByte(1)
      ..write(obj.userName)
      ..writeByte(2)
      ..write(obj.userEmail)
      ..writeByte(3)
      ..write(obj.userStatus)
      ..writeByte(4)
      ..write(obj.profilePicture);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserDetailsHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
