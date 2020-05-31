// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'usuario.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UsuarioHasuraAdapter extends TypeAdapter<UsuarioHasura> {
  @override
  final typeId = 1;

  @override
  UsuarioHasura read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UsuarioHasura(
      id: fields[0] as int,
      nome: fields[1] as String,
      codHasura: fields[2] as int,
      codProfessor: fields[3] as int,
    );
  }

  @override
  void write(BinaryWriter writer, UsuarioHasura obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.nome)
      ..writeByte(2)
      ..write(obj.codHasura)
      ..writeByte(3)
      ..write(obj.codProfessor);
  }
}
