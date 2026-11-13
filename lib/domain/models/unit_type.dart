import 'package:hive/hive.dart';

part 'unit_type.g.dart';

@HiveType(typeId: 0)
enum UnitType {
  @HiveField(0)
  gramos,
  @HiveField(1)
  mililitros,
  @HiveField(2)
  unidades,
}

@HiveType(typeId: 1)
enum CurrencyType {
  @HiveField(0)
  usd,
  @HiveField(1)
  ves,
}