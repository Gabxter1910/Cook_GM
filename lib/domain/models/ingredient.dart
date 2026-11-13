import 'package:hive/hive.dart';
import 'unit_type.dart';

part 'ingredient.g.dart';

@HiveType(typeId: 2)
class Ingredient extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final double packageQuantity; // Cantidad comprada (ej: 1000g)

  @HiveField(3)
  final UnitType unit; // gramos, ml, unidades

  @HiveField(4)
  final double packageCost; // Monto pagado

  @HiveField(5)
  final CurrencyType costCurrency; // Moneda de compra: usd o ves

  Ingredient({
    required this.id,
    required this.name,
    required this.packageQuantity,
    required this.unit,
    required this.packageCost,
    required this.costCurrency,
  });

  /// Retorna el costo base unitario en USD
  double getCostPerUnitUsd(double bcvRate) {
    final costInUsd = costCurrency == CurrencyType.usd
        ? packageCost
        : packageCost / bcvRate;
    return costInUsd / packageQuantity;
  }

  /// Retorna el costo base unitario en VES
  double getCostPerUnitVes(double bcvRate) {
    return getCostPerUnitUsd(bcvRate) * bcvRate;
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'packageQuantity': packageQuantity,
        'unit': unit.name,
        'packageCost': packageCost,
        'costCurrency': costCurrency.name,
      };

  factory Ingredient.fromJson(Map<String, dynamic> json) => Ingredient(
        id: json['id'] as String,
        name: json['name'] as String,
        packageQuantity: (json['packageQuantity'] as num).toDouble(),
        unit: UnitType.values.byName(json['unit'] as String),
        packageCost: (json['packageCost'] as num).toDouble(),
        costCurrency: CurrencyType.values.byName(json['costCurrency'] as String),
      );
}