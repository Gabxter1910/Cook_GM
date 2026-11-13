import 'package:hive/hive.dart';
import 'ingredient.dart';

part 'recipe_item.g.dart';

@HiveType(typeId: 3)
class RecipeItem extends HiveObject {
  @HiveField(0)
  final Ingredient ingredient;

  @HiveField(1)
  final double quantityUsed; // Cantidad usada (ej: 250g)

  RecipeItem({
    required this.ingredient,
    required this.quantityUsed,
  });

  double getItemCostUsd(double bcvRate) {
    return ingredient.getCostPerUnitUsd(bcvRate) * quantityUsed;
  }
}