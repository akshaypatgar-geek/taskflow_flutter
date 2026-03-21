// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_hive.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CategoryHiveAdapter extends TypeAdapter<CategoryHive> {
  @override
  final typeId = 3;

  @override
  CategoryHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CategoryHive(
      categoryId: fields[0] as String,
      categoryName: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, CategoryHive obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.categoryId)
      ..writeByte(1)
      ..write(obj.categoryName);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CategoryHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
