// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cookie_recipe.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CookieRecipeAdapter extends TypeAdapter<CookieRecipe> {
  @override
  final int typeId = 4;

  @override
  CookieRecipe read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CookieRecipe(
      id: fields[0] as String,
      name: fields[1] as String,
      items: (fields[2] as List).cast<RecipeItem>(),
      totalUnitsProduced: fields[3] as int,
      defaultProfitMargin: fields[4] as double,
    );
  }

  @override
  void write(BinaryWriter writer, CookieRecipe obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.items)
      ..writeByte(3)
      ..write(obj.totalUnitsProduced)
      ..writeByte(4)
      ..write(obj.defaultProfitMargin);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CookieRecipeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
