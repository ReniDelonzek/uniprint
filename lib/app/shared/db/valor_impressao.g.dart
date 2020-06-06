// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'valor_impressao.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ValorImpressaoAdapter extends TypeAdapter<ValorImpressao> {
  @override
  final typeId = 2;

  @override
  ValorImpressao read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ValorImpressao(
      fields[0] as int,
      fields[1] as double,
      fields[3] as int,
      fields[4] as DateTime,
      fields[5] as DateTime,
      fields[6] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, ValorImpressao obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.valor)
      ..writeByte(3)
      ..write(obj.tipo_folha_id)
      ..writeByte(4)
      ..write(obj.data_inicio)
      ..writeByte(5)
      ..write(obj.data_fim)
      ..writeByte(6)
      ..write(obj.colorido);
  }
}
