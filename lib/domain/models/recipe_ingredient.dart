import 'ingredient.dart';

class RecipeIngredient {
  final Ingredient ingredient;
  final double amountUsed; // Cantidad usada en la receta (ej: 250 gramos/ml/unidades)

  RecipeIngredient({
    required this.ingredient,
    required this.amountUsed,
  });

  // Calcula el costo de la cantidad utilizada de este ingrediente en USD
  double getCostUsd(double bcvRate) {
    return ingredient.getCostPerUnitUsd(bcvRate) * amountUsed;
  }

  // Calcula el costo de la cantidad utilizada de este ingrediente en VES
  double getCostVes(double bcvRate) {
    return ingredient.getCostPerUnitVes(bcvRate) * amountUsed;
  }

  Map<String, dynamic> toJson() => {
        'ingredient': ingredient.toJson(),
        'amountUsed': amountUsed,
      };

  factory RecipeIngredient.fromJson(Map<String, dynamic> json) =>
      RecipeIngredient(
        ingredient: Ingredient.fromJson(json['ingredient']),
        amountUsed: (json['amountUsed'] as num).toDouble(),
      );
}