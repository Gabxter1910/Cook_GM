import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/models/ingredient.dart';
import '../../domain/models/recipe.dart';

class LocalDatabaseService {
  static late SharedPreferences _prefs;

  static const String _bcvKey = 'bcv_rate';
  static const String _ingredientsKey = 'ingredients_list';
  static const String _recipesKey = 'recipes_list';

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static double getBcvRate() => _prefs.getDouble(_bcvKey) ?? 36.50;

  static Future<void> setBcvRate(double rate) async {
    await _prefs.setDouble(_bcvKey, rate);
  }

  static List<Ingredient> getAllIngredients() {
    final jsonList = _prefs.getStringList(_ingredientsKey) ?? const [];
    return jsonList
        .map((item) => Ingredient.fromJson(
              jsonDecode(item) as Map<String, dynamic>,
            ))
        .toList();
  }

  static Future<void> saveIngredient(Ingredient ingredient) async {
    final ingredients = getAllIngredients();
    final index = ingredients.indexWhere((item) => item.id == ingredient.id);
    if (index == -1) {
      ingredients.add(ingredient);
    } else {
      ingredients[index] = ingredient;
    }
    final jsonList = ingredients.map((item) => jsonEncode(item.toJson())).toList();
    await _prefs.setStringList(_ingredientsKey, jsonList);
  }

  static Future<void> deleteIngredient(String id) async {
    final ingredients = getAllIngredients()
      ..removeWhere((ingredient) => ingredient.id == id);
    final jsonList = ingredients.map((item) => jsonEncode(item.toJson())).toList();
    await _prefs.setStringList(_ingredientsKey, jsonList);
  }

  static List<Recipe> getAllRecipes() {
    final jsonList = _prefs.getStringList(_recipesKey) ?? const [];
    return jsonList
        .map((item) => Recipe.fromJson(
              jsonDecode(item) as Map<String, dynamic>,
            ))
        .toList();
  }

  static Future<void> saveRecipe(Recipe recipe) async {
    final recipes = getAllRecipes();
    final index = recipes.indexWhere((item) => item.id == recipe.id);
    if (index == -1) {
      recipes.add(recipe);
    } else {
      recipes[index] = recipe;
    }
    final jsonList = recipes.map((item) => jsonEncode(item.toJson())).toList();
    await _prefs.setStringList(_recipesKey, jsonList);
  }

  static Future<void> deleteRecipe(String id) async {
    final recipes = getAllRecipes()..removeWhere((recipe) => recipe.id == id);
    final jsonList = recipes.map((item) => jsonEncode(item.toJson())).toList();
    await _prefs.setStringList(_recipesKey, jsonList);
  }
}