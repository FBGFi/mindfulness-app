// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mind_set_object.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MindSetObjectAdapter extends TypeAdapter<MindSetObject> {
  @override
  final int typeId = 0;

  @override
  MindSetObject read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MindSetObject(
      date: fields[0] as int?,
      notes: fields[3] as String,
      category: fields[1] as String,
      feeling: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, MindSetObject obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.category)
      ..writeByte(2)
      ..write(obj.feeling)
      ..writeByte(3)
      ..write(obj.notes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MindSetObjectAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
