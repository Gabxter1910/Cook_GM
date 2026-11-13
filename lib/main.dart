import 'package:flutter/material.dart';
import 'data/services/local_database_service.dart';
import 'presentation/ingredients_screen.dart';
import 'domain/models/recipes_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalDatabaseService.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculadora de Galletas',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late double _bcvRate;
  final TextEditingController _bcvController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _bcvRate = LocalDatabaseService.getBcvRate();
    _bcvController.text = _bcvRate.toStringAsFixed(2);
  }

  void _updateBcvRate() async {
    final double? newRate = double.tryParse(_bcvController.text);
    if (newRate != null && newRate > 0) {
      await LocalDatabaseService.setBcvRate(newRate);
      setState(() {
        _bcvRate = newRate;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tasa BCV actualizada con éxito')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculadora de Galletas'),
        backgroundColor: Colors.amber.shade200,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // CARD TASA BCV
            Card(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Tasa BCV (Bs/\$):',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      width: 100,
                      child: TextField(
                        controller: _bcvController,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          isDense: true,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.save, color: Colors.amber),
                      onPressed: _updateBcvRate,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            // BOTÓN A INSUMOS
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber.shade100,
                  foregroundColor: Colors.black87,
                ),
                icon: const Icon(Icons.kitchen, size: 28),
                label: const Text(
                  'Mis Insumos e Ingredientes',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => IngredientsScreen(bcvRate: _bcvRate),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),

            // BOTÓN A RECETAS Y CÁLCULO
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  foregroundColor: Colors.black87,
                ),
                icon: const Icon(Icons.cookie, size: 28),
                label: const Text(
                  'Recetas y Precios de Galletas',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RecipesScreen(bcvRate: _bcvRate),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}