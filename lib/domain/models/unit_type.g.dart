// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'unit_type.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UnitTypeAdapter extends TypeAdapter<UnitType> {
  @override
  final int typeId = 0;

  @override
  UnitType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return UnitType.gramos;
      case 1:
        return UnitType.mililitros;
      case 2:
        return UnitType.unidades;
      default:
        return UnitType.gramos;
    }
  }

  @override
  void write(BinaryWriter writer, UnitType obj) {
    switch (obj) {
      case UnitType.gramos:
        writer.writeByte(0);
        break;
      case UnitType.mililitros:
        writer.writeByte(1);
        break;
      case UnitType.unidades:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UnitTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CurrencyTypeAdapter extends TypeAdapter<CurrencyType> {
  @override
  final int typeId = 1;

  @override
  CurrencyType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return CurrencyType.usd;
      case 1:
        return CurrencyType.ves;
      default:
        return CurrencyType.usd;
    }
  }

  @override
  void write(BinaryWriter writer, CurrencyType obj) {
    switch (obj) {
      case CurrencyType.usd:
        writer.writeByte(0);
        break;
      case CurrencyType.ves:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CurrencyTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
