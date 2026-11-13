// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RecipeItemAdapter extends TypeAdapter<RecipeItem> {
  @override
  final int typeId = 3;

  @override
  RecipeItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RecipeItem(
      ingredient: fields[0] as Ingredient,
      quantityUsed: fields[1] as double,
    );
  }

  @override
  void write(BinaryWriter writer, RecipeItem obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.ingredient)
      ..writeByte(1)
      ..write(obj.quantityUsed);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecipeItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
