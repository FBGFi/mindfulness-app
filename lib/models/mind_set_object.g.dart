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
      category: fields[0] as String,
      feeling: fields[1] as String,
      notes: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, MindSetObject obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.category)
      ..writeByte(1)
      ..write(obj.feeling)
      ..writeByte(2)
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

class MindSetObjectModelAdapter extends TypeAdapter<MindSetObjectModel> {
  @override
  final int typeId = 1;

  @override
  MindSetObjectModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MindSetObjectModel(
      mindSets: (fields[0] as Map).cast<String, MindSetObject>(),
    );
  }

  @override
  void write(BinaryWriter writer, MindSetObjectModel obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.mindSets);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MindSetObjectModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
