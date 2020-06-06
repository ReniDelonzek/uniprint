// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'menu.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MenuAdapter extends TypeAdapter<Menu> {
  @override
  final typeId = 4;

  @override
  Menu read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Menu(
      nome: fields[1] as String,
      id: fields[2] as int,
      menuPaiId: fields[3] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Menu obj) {
    writer
      ..writeByte(3)
      ..writeByte(1)
      ..write(obj.nome)
      ..writeByte(2)
      ..write(obj.id)
      ..writeByte(3)
      ..write(obj.menuPaiId);
  }
}
