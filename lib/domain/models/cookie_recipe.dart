import 'package:hive/hive.dart';
import 'recipe_item.dart';

part 'cookie_recipe.g.dart';

@HiveType(typeId: 4)
class CookieRecipe extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final List<RecipeItem> items;

  @HiveField(3)
  final int totalUnitsProduced; // Rendimiento (ej: 24 galletas)

  @HiveField(4)
  final double defaultProfitMargin; // Margen deseado (ej: 50%)

  CookieRecipe({
    required this.id,
    required this.name,
    required this.items,
    required this.totalUnitsProduced,
    this.defaultProfitMargin = 50.0,
  });

  /// Costo total de la tanda en USD
  double getTotalBatchCostUsd(double bcvRate) {
    return items.fold(0.0, (sum, item) => sum + item.getItemCostUsd(bcvRate));
  }

  /// Costo exacto de producción por galleta en USD
  double getUnitCostUsd(double bcvRate) {
    if (totalUnitsProduced <= 0) return 0.0;
    return getTotalBatchCostUsd(bcvRate) / totalUnitsProduced;
  }

  /// Precio de Venta Sugerido (PVP) por unidad en USD
  double getSellingPricePerUnitUsd(double bcvRate, double profitMargin) {
    return getUnitCostUsd(bcvRate) * (1 + (profitMargin / 100));
  }

  /// Precio de Venta Sugerido (PVP) por unidad en VES
  double getSellingPricePerUnitVes(double bcvRate, double profitMargin) {
    return getSellingPricePerUnitUsd(bcvRate, profitMargin) * bcvRate;
  }
}