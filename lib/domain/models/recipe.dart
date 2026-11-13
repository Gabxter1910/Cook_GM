import 'recipe_ingredient.dart';

class Recipe {
  final String id;
  final String name;
  final int yieldQuantity; // Cantidad de galletas/piezas que rinde la mezcla
  final List<RecipeIngredient> ingredients;
  final double profitPercentage; // % de ganancia deseado (ej: 50, 100, 150)

  Recipe({
    required this.id,
    required this.name,
    required this.yieldQuantity,
    required this.ingredients,
    this.profitPercentage = 100.0,
  });

  // Costo total de producción de la receta completa en USD
  double getTotalCostUsd(double bcvRate) {
    return ingredients.fold(
        0.0, (sum, item) => sum + item.getCostUsd(bcvRate));
  }

  // Costo total de producción en VES
  double getTotalCostVes(double bcvRate) {
    return getTotalCostUsd(bcvRate) * bcvRate;
  }

  // Costo de producción por galleta/unidad en USD
  double getUnitCostUsd(double bcvRate) {
    if (yieldQuantity <= 0) return 0.0;
    return getTotalCostUsd(bcvRate) / yieldQuantity;
  }

  // Costo de producción por galleta/unidad en VES
  double getUnitCostVes(double bcvRate) {
    return getUnitCostUsd(bcvRate) * bcvRate;
  }

  // Precio sugerido de venta por unidad en USD según el % de ganancia
  double getUnitPriceUsd(double bcvRate) {
    final unitCost = getUnitCostUsd(bcvRate);
    return unitCost * (1 + (profitPercentage / 100.0));
  }

  // Precio sugerido de venta por unidad en VES
  double getUnitPriceVes(double bcvRate) {
    return getUnitPriceUsd(bcvRate) * bcvRate;
  }

  // Ganancia neta total por la bandeja/lote completo en USD
  double getTotalProfitUsd(double bcvRate) {
    final totalCost = getTotalCostUsd(bcvRate);
    return totalCost * (profitPercentage / 100.0);
  }

  // Ganancia neta total en VES
  double getTotalProfitVes(double bcvRate) {
    return getTotalProfitUsd(bcvRate) * bcvRate;
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'yieldQuantity': yieldQuantity,
        'ingredients': ingredients.map((x) => x.toJson()).toList(),
        'profitPercentage': profitPercentage,
      };

  factory Recipe.fromJson(Map<String, dynamic> json) => Recipe(
        id: json['id'],
        name: json['name'],
        yieldQuantity: json['yieldQuantity'],
        ingredients: (json['ingredients'] as List)
            .map((x) => RecipeIngredient.fromJson(x))
            .toList(),
        profitPercentage: (json['profitPercentage'] as num).toDouble(),
      );
}