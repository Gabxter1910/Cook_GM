import 'package:flutter/material.dart';
import 'package:calculate_gmdev/data/services/local_database_service.dart';
import 'package:calculate_gmdev/domain/models/ingredient.dart';
import 'package:calculate_gmdev/domain/models/recipe.dart';
import 'package:calculate_gmdev/domain/models/recipe_ingredient.dart';
import 'package:calculate_gmdev/domain/models/unit_type.dart';

class RecipesScreen extends StatefulWidget {
  final double bcvRate;

  const RecipesScreen({super.key, required this.bcvRate});

  @override
  State<RecipesScreen> createState() => _RecipesScreenState();
}

class _RecipesScreenState extends State<RecipesScreen> {
  List<Recipe> _recipes = [];

  @override
  void initState() {
    super.initState();
    _loadRecipes();
  }

  void _loadRecipes() {
    setState(() {
      _recipes = LocalDatabaseService.getAllRecipes();
    });
  }

  void _openRecipeBuilder({Recipe? existingRecipe}) {
    final availableIngredients = LocalDatabaseService.getAllIngredients();

    if (availableIngredients.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Primero debes registrar insumos en la sección "Mis Insumos".'),
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RecipeDetailForm(
          bcvRate: widget.bcvRate,
          availableIngredients: availableIngredients,
          existingRecipe: existingRecipe,
        ),
      ),
    ).then((_) => _loadRecipes());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recetas y Cálculos'),
        backgroundColor: Colors.amber.shade200,
      ),
      body: _recipes.isEmpty
          ? const Center(
              child: Text(
                'No hay recetas guardadas.\nPresiona + para calcular una nueva receta.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _recipes.length,
              itemBuilder: (context, index) {
                final recipe = _recipes[index];
                final unitCostUsd = recipe.getUnitCostUsd(widget.bcvRate);
                final unitPriceUsd = recipe.getUnitPriceUsd(widget.bcvRate);
                final unitPriceVes = recipe.getUnitPriceVes(widget.bcvRate);

                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ExpansionTile(
                    title: Text(
                      recipe.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    subtitle: Text(
                      'Rendimiento: ${recipe.yieldQuantity} unidades | Ganancia: ${recipe.profitPercentage.toStringAsFixed(0)}%',
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Divider(),
                            const Text(
                              'Ingredientes:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            ...recipe.ingredients.map((item) {
                              final unitAbbr = item.ingredient.unit == UnitType.gramos
                                  ? 'g'
                                  : item.ingredient.unit == UnitType.mililitros
                                      ? 'ml'
                                      : 'ud';
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 2.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('• ${item.ingredient.name}'),
                                    Text(
                                        '${item.amountUsed.toStringAsFixed(0)} $unitAbbr (\$${item.getCostUsd(widget.bcvRate).toStringAsFixed(2)})'),
                                  ],
                                ),
                              );
                            }),
                            const Divider(),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.amber.shade50,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text('Costo total receta:'),
                                      Text(
                                        '\$${recipe.getTotalCostUsd(widget.bcvRate).toStringAsFixed(2)} / Bs. ${recipe.getTotalCostVes(widget.bcvRate).toStringAsFixed(2)}',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text('Costo por galleta:'),
                                      Text(
                                        '\$${unitCostUsd.toStringAsFixed(2)}',
                                        style: const TextStyle(
                                            color: Colors.redAccent,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'PRECIO VENTA / UNIDAD:',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        '\$${unitPriceUsd.toStringAsFixed(2)} / Bs. ${unitPriceVes.toStringAsFixed(2)}',
                                        style: TextStyle(
                                          color: Colors.green.shade800,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton.icon(
                                  icon: const Icon(Icons.edit, size: 18),
                                  label: const Text('Editar'),
                                  onPressed: () => _openRecipeBuilder(
                                      existingRecipe: recipe),
                                ),
                                TextButton.icon(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red, size: 18),
                                  label: const Text('Eliminar',
                                      style: TextStyle(color: Colors.red)),
                                  onPressed: () async {
                                    await LocalDatabaseService.deleteRecipe(
                                        recipe.id);
                                    _loadRecipes();
                                  },
                                ),
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.amber,
        onPressed: () => _openRecipeBuilder(),
        icon: const Icon(Icons.add, color: Colors.black87),
        label: const Text('Nueva Receta', style: TextStyle(color: Colors.black87)),
      ),
    );
  }
}

// FORMULARIO DE RECETA (CREAR / EDITAR)
class RecipeDetailForm extends StatefulWidget {
  final double bcvRate;
  final List<Ingredient> availableIngredients;
  final Recipe? existingRecipe;

  const RecipeDetailForm({
    super.key,
    required this.bcvRate,
    required this.availableIngredients,
    this.existingRecipe,
  });

  @override
  State<RecipeDetailForm> createState() => _RecipeDetailFormState();
}

class _RecipeDetailFormState extends State<RecipeDetailForm> {
  final _nameController = TextEditingController();
  final _yieldController = TextEditingController();
  final _profitController = TextEditingController(text: '100');

  final List<RecipeIngredient> _recipeIngredients = [];

  Ingredient? _selectedIngredient;
  final _amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.existingRecipe != null) {
      final r = widget.existingRecipe!;
      _nameController.text = r.name;
      _yieldController.text = r.yieldQuantity.toString();
      _profitController.text = r.profitPercentage.toStringAsFixed(0);
      _recipeIngredients.addAll(r.ingredients);
    }
  }

  void _addIngredientToRecipe() {
    final amount = double.tryParse(_amountController.text) ?? 0;
    if (_selectedIngredient == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona un ingrediente y cantidad válida')),
      );
      return;
    }

    setState(() {
      _recipeIngredients.add(
        RecipeIngredient(
          ingredient: _selectedIngredient!,
          amountUsed: amount,
        ),
      );
      _selectedIngredient = null;
      _amountController.clear();
    });
  }

  double get _totalCostUsd {
    return _recipeIngredients.fold(
        0.0, (sum, item) => sum + item.getCostUsd(widget.bcvRate));
  }

  @override
  Widget build(BuildContext context) {
    final yieldQty = int.tryParse(_yieldController.text) ?? 1;
    final profitPct = double.tryParse(_profitController.text) ?? 0;

    final totalCost = _totalCostUsd;
    final unitCostUsd = yieldQty > 0 ? totalCost / yieldQty : 0.0;
    final unitPriceUsd = unitCostUsd * (1 + (profitPct / 100.0));
    final unitPriceVes = unitPriceUsd * widget.bcvRate;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.existingRecipe == null
            ? 'Nueva Receta'
            : 'Editar Receta'),
        backgroundColor: Colors.amber.shade200,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nombre de la Receta (ej. Galletas Choco-Chips)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _yieldController,
                    keyboardType: TextInputType.number,
                    onChanged: (_) => setState(() {}),
                    decoration: const InputDecoration(
                      labelText: 'Rendimiento (Galletas/Unidades)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _profitController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    onChanged: (_) => setState(() {}),
                    decoration: const InputDecoration(
                      labelText: '% Margen Ganancia',
                      border: OutlineInputBorder(),
                      suffixText: '%',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Agregar Ingredientes a la Mezcla:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: DropdownButtonFormField<Ingredient>(
                    value: _selectedIngredient,
                    isExpanded: true,
                    decoration: const InputDecoration(
                      labelText: 'Insumo',
                      border: OutlineInputBorder(),
                    ),
                    items: widget.availableIngredients.map((item) {
                      return DropdownMenuItem(
                        value: item,
                        child: Text(item.name, overflow: TextOverflow.ellipsis),
                      );
                    }).toList(),
                    onChanged: (val) {
                      setState(() => _selectedIngredient = val);
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 1,
                  child: TextField(
                    controller: _amountController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      labelText: _selectedIngredient == null
                          ? 'Cant.'
                          : _selectedIngredient!.unit == UnitType.gramos
                              ? 'Gramos'
                              : _selectedIngredient!.unit == UnitType.mililitros
                                  ? 'Ml'
                                  : 'Unid.',
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle, color: Colors.amber, size: 36),
                  onPressed: _addIngredientToRecipe,
                )
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Ingredientes Añadidos:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _recipeIngredients.isEmpty
                ? const Text(
                    'No has añadido ningún ingrediente a esta mezcla.',
                    style: TextStyle(color: Colors.grey),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _recipeIngredients.length,
                    itemBuilder: (context, index) {
                      final item = _recipeIngredients[index];
                      final unitAbbr = item.ingredient.unit == UnitType.gramos
                          ? 'g'
                          : item.ingredient.unit == UnitType.mililitros
                              ? 'ml'
                              : 'ud';
                      return ListTile(
                        dense: true,
                        title: Text(item.ingredient.name),
                        subtitle: Text(
                            '${item.amountUsed.toStringAsFixed(0)} $unitAbbr = \$${item.getCostUsd(widget.bcvRate).toStringAsFixed(2)}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.remove_circle,
                              color: Colors.red),
                          onPressed: () {
                            setState(() {
                              _recipeIngredients.removeAt(index);
                            });
                          },
                        ),
                      );
                    },
                  ),
            const SizedBox(height: 20),

            // TARJETA RESUMEN EN TIEMPO REAL
            Card(
              color: Colors.amber.shade100,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Costo Total Mezcla:'),
                        Text(
                          '\$${totalCost.toStringAsFixed(2)} / Bs. ${(totalCost * widget.bcvRate).toStringAsFixed(2)}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Costo por Galleta:'),
                        Text('\$${unitCostUsd.toStringAsFixed(2)}',
                            style: const TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'PRECIO SUGERIDO VENTA:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '\$${unitPriceUsd.toStringAsFixed(2)} / Bs. ${unitPriceVes.toStringAsFixed(2)}',
                          style: TextStyle(
                            color: Colors.green.shade900,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  foregroundColor: Colors.black,
                ),
                icon: const Icon(Icons.save),
                label: const Text('Guardar Receta',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                onPressed: () async {
                  final name = _nameController.text.trim();
                  final yieldQ = int.tryParse(_yieldController.text) ?? 0;
                  final profit = double.tryParse(_profitController.text) ?? 0;

                  if (name.isEmpty || yieldQ <= 0 || _recipeIngredients.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Ingresa un nombre, rendimiento válido y al menos 1 ingrediente.'),
                      ),
                    );
                    return;
                  }

                  final recipe = Recipe(
                    id: widget.existingRecipe?.id ??
                        DateTime.now().millisecondsSinceEpoch.toString(),
                    name: name,
                    yieldQuantity: yieldQ,
                    ingredients: _recipeIngredients,
                    profitPercentage: profit,
                  );

                  await LocalDatabaseService.saveRecipe(recipe);
                  if (mounted) Navigator.pop(context);
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}