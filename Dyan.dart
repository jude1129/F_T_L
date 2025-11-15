import 'package:flutter/material.dart';
import 'dart:math' as math;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recipe Builder',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        brightness: Brightness.light,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.purple,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          filled: true,
          fillColor: Colors.grey[100],
        ),
      ),
      home: HomeScreen(),
      routes: {
        '/details': (context) => DetailsScreen(),
      },
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _ingredientController = TextEditingController();
  final _quantityController = TextEditingController();
  List<Map<String, dynamic>> _ingredients = [
    {'name': 'Flour', 'quantity': '2 cups', 'unit': 'cups', 'calories': 455.0},
    {'name': 'Sugar', 'quantity': '1', 'unit': 'cup', 'calories': 774.0},
  ];

  void _addIngredient() {
    if (_ingredientController.text.isNotEmpty && _quantityController.text.isNotEmpty) {
      setState(() {
        _ingredients.add({
          'name': _ingredientController.text,
          'quantity': _quantityController.text,
          'unit': _quantityController.text.contains('cup') ? 'cups' : 'g',
          'calories': math.Random().nextDouble() * 500 + 100, // Simulated calories
        });
        _ingredientController.clear();
        _quantityController.clear();
      });
    }
  }

  void _removeIngredient(int index) {
    setState(() {
      _ingredients.removeAt(index);
    });
  }

  void _viewDetails() {
    final totalCalories = _ingredients.fold(0.0, (sum, item) => sum + item['calories']);
    Navigator.pushNamed(context, '/details', arguments: {
      'totalCalories': totalCalories,
      'ingredients': _ingredients,
    });
  }

  @override
  Widget build(BuildContext context) {
    final totalCalories = _ingredients.fold(0.0, (sum, item) => sum + item['calories']);
    return Scaffold(
      appBar: AppBar(
        title: Text('Recipe Builder'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.calculate),
            onPressed: _viewDetails,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: _ingredientController,
                  decoration: InputDecoration(
                    labelText: 'Ingredient Name',
                    prefixIcon: Icon(Icons.restaurant, color: Colors.purple),
                    hintText: 'e.g., Eggs',
                  ),
                ),
                SizedBox(height: 8),
                TextField(
                  controller: _quantityController,
                  decoration: InputDecoration(
                    labelText: 'Quantity & Unit',
                    prefixIcon: Icon(Icons.scale, color: Colors.purple),
                    hintText: 'e.g., 3 eggs',
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(child: ElevatedButton(onPressed: _addIngredient, child: Text('Add'))),
                    SizedBox(width: 8),
                    ElevatedButton.icon(
                      onPressed: _viewDetails,
                      icon: Icon(Icons.info),
                      label: Text('Details'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _ingredients.length,
              itemBuilder: (context, index) {
                final item = _ingredients[index];
                return Dismissible(
                  key: Key(item['name']),
                  direction: DismissDirection.endToStart,
                  onDismissed: (_) => _removeIngredient(index),
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.only(right: 20),
                    child: Icon(Icons.delete, color: Colors.white),
                  ),
                  child: Card(
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.purple[100],
                        child: Text(item['name'][0], style: TextStyle(color: Colors.purple, fontWeight: FontWeight.bold)),
                      ),
                      title: Text(item['name']),
                      subtitle: Text('${item['quantity']} ${item['unit']} | ~${item['calories'].toStringAsFixed(0)} cal'),
                      trailing: Icon(Icons.drag_handle, color: Colors.grey),
                    ),
                  ),
                );
              },
            ),
          ),
          if (_ingredients.isNotEmpty)
            Container(
              padding: EdgeInsets.all(16),
              color: Colors.purple[50],
              child: Text('Total Estimated Calories: ${totalCalories.toStringAsFixed(0)}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.purple[800])),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _ingredientController.dispose();
    _quantityController.dispose();
    super.dispose();
  }
}

class DetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final totalCalories = args['totalCalories'] as double;
    final ingredients = args['ingredients'] as List<Map<String, dynamic>>;

    return Scaffold(
      appBar: AppBar(
        title: Text('Recipe Details'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Icon(Icons.restaurant_menu, size: 64, color: Colors.purple),
                    SizedBox(height: 16),
                    Text('Total Calories: ${totalCalories.toStringAsFixed(0)}', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    Text('${ingredients.length} Ingredients', style: TextStyle(color: Colors.grey[600])),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: ingredients.length,
                itemBuilder: (context, index) {
                  final item = ingredients[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 4),
                    child: ListTile(
                      leading: Icon(Icons.local_dining, color: Colors.purple),
                      title: Text(item['name']),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${item['quantity']} ${item['unit']}'),
                          Text('Calories: ${item['calories'].toStringAsFixed(0)}'),
                        ],
                      ),
                      trailing: Icon(Icons.arrow_forward_ios, size: 16),
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