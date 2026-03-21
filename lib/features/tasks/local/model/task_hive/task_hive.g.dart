// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_hive.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TaskHiveAdapter extends TypeAdapter<TaskHive> {
  @override
  final typeId = 2;

  @override
  TaskHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TaskHive(
      taskId: fields[0] as String,
      title: fields[1] as String,
      createdAt: fields[2] as DateTime,
      updatedAt: fields[3] as DateTime,
      authorId: fields[4] as String,
      categoryId: fields[5] as String?,
      priority: fields[6] as String?,
      status: fields[7] as String?,
      syncStatus: fields[8] as String,
    );
  }

  @override
  void write(BinaryWriter writer, TaskHive obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.taskId)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.createdAt)
      ..writeByte(3)
      ..write(obj.updatedAt)
      ..writeByte(4)
      ..write(obj.authorId)
      ..writeByte(5)
      ..write(obj.categoryId)
      ..writeByte(6)
      ..write(obj.priority)
      ..writeByte(7)
      ..write(obj.status)
      ..writeByte(8)
      ..write(obj.syncStatus);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
