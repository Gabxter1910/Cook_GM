import 'package:flutter/material.dart';
import '../data/services/local_database_service.dart';
import '../domain/models/ingredient.dart';
import '../domain/models/unit_type.dart';

class IngredientsScreen extends StatefulWidget {
  final double bcvRate;

  const IngredientsScreen({super.key, required this.bcvRate});

  @override
  State<IngredientsScreen> createState() => _IngredientsScreenState();
}

class _IngredientsScreenState extends State<IngredientsScreen> {
  List<Ingredient> _ingredients = [];

  // Controladores de texto para el formulario
  final _nameController = TextEditingController();
  final _quantityController = TextEditingController();
  final _costController = TextEditingController();

  UnitType _selectedUnit = UnitType.gramos;
  CurrencyType _selectedCurrency = CurrencyType.usd;

  @override
  void initState() {
    super.initState();
    _loadIngredients();
  }

  void _loadIngredients() {
    setState(() {
      _ingredients = LocalDatabaseService.getAllIngredients();
    });
  }

  void _showAddIngredientDialog() {
    _nameController.clear();
    _quantityController.clear();
    _costController.clear();
    _selectedUnit = UnitType.gramos;
    _selectedCurrency = CurrencyType.usd;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + 16,
                top: 20,
                left: 16,
                right: 16,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Nuevo Insumo / Material',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Nombre del Insumo (ej. Harina, Mantequilla)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: TextField(
                            controller: _quantityController,
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            decoration: const InputDecoration(
                              labelText: 'Cantidad comprada',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          flex: 1,
                          child: DropdownButtonFormField<UnitType>(
                            value: _selectedUnit,
                            decoration: const InputDecoration(
                              labelText: 'Unidad',
                              border: OutlineInputBorder(),
                            ),
                            items: const [
                              DropdownMenuItem(
                                value: UnitType.gramos,
                                child: Text('Gramos (g)'),
                              ),
                              DropdownMenuItem(
                                value: UnitType.mililitros,
                                child: Text('Ml (ml)'),
                              ),
                              DropdownMenuItem(
                                value: UnitType.unidades,
                                child: Text('Unidades'),
                              ),
                            ],
                            onChanged: (val) {
                              if (val != null) {
                                setModalState(() => _selectedUnit = val);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: TextField(
                            controller: _costController,
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            decoration: const InputDecoration(
                              labelText: 'Costo Total Pagado',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          flex: 1,
                          child: DropdownButtonFormField<CurrencyType>(
                            value: _selectedCurrency,
                            decoration: const InputDecoration(
                              labelText: 'Moneda',
                              border: OutlineInputBorder(),
                            ),
                            items: const [
                              DropdownMenuItem(
                                value: CurrencyType.usd,
                                child: Text('\$ (USD)'),
                              ),
                              DropdownMenuItem(
                                value: CurrencyType.ves,
                                child: Text('Bs (VES)'),
                              ),
                            ],
                            onChanged: (val) {
                              if (val != null) {
                                setModalState(() => _selectedCurrency = val);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber,
                          foregroundColor: Colors.black87,
                        ),
                        icon: const Icon(Icons.save),
                        label: const Text('Guardar Insumo',
                            style: TextStyle(fontSize: 16)),
                        onPressed: () async {
                          final name = _nameController.text.trim();
                          final qty = double.tryParse(_quantityController.text) ?? 0;
                          final cost = double.tryParse(_costController.text) ?? 0;

                          if (name.isEmpty || qty <= 0 || cost <= 0) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Por favor llena todos los campos correctamente'),
                              ),
                            );
                            return;
                          }

                          final newIngredient = Ingredient(
                            id: DateTime.now().millisecondsSinceEpoch.toString(),
                            name: name,
                            packageQuantity: qty,
                            unit: _selectedUnit,
                            packageCost: cost,
                            costCurrency: _selectedCurrency,
                          );

                          await LocalDatabaseService.saveIngredient(newIngredient);
                          _loadIngredients();
                          if (mounted) Navigator.pop(context);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  String _getUnitAbbr(UnitType unit) {
    switch (unit) {
      case UnitType.gramos:
        return 'g';
      case UnitType.mililitros:
        return 'ml';
      case UnitType.unidades:
        return 'ud';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Insumos'),
        backgroundColor: Colors.amber.shade200,
      ),
      body: _ingredients.isEmpty
          ? const Center(
              child: Text(
                'No hay insumos registrados.\nPresiona el botón + para agregar.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _ingredients.length,
              itemBuilder: (context, index) {
                final item = _ingredients[index];
                final unitAbbr = _getUnitAbbr(item.unit);
                final unitCostUsd = item.getCostPerUnitUsd(widget.bcvRate);
                final unitCostVes = item.getCostPerUnitVes(widget.bcvRate);

                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: ListTile(
                    title: Text(
                      item.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Paquete: ${item.packageQuantity.toStringAsFixed(0)}$unitAbbr por '
                          '${item.costCurrency == CurrencyType.usd ? "\$" : "Bs."}${item.packageCost.toStringAsFixed(2)}',
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Costo unitario: \$${unitCostUsd.toStringAsFixed(4)} / Bs. ${unitCostVes.toStringAsFixed(2)} por $unitAbbr',
                          style: TextStyle(
                            color: Colors.green.shade800,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.redAccent),
                      onPressed: () async {
                        await LocalDatabaseService.deleteIngredient(item.id);
                        _loadIngredients();
                      },
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.amber,
        onPressed: _showAddIngredientDialog,
        child: const Icon(Icons.add, color: Colors.black87),
      ),
    );
  }
}