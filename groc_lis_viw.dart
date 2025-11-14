import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Grocery List App',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        brightness: Brightness.light,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
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
        '/summary': (context) => SummaryScreen(),
      },
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _itemController = TextEditingController();
  List<Map<String, dynamic>> _groceryItems = [
    {'name': 'Apples', 'quantity': 5, 'checked': false, 'category': 'Fruits'},
    {'name': 'Bread', 'quantity': 2, 'checked': false, 'category': 'Bakery'},
    {'name': 'Milk', 'quantity': 1, 'checked': true, 'category': 'Dairy'},
  ];

  void _addItem() {
    if (_itemController.text.isNotEmpty) {
      setState(() {
        _groceryItems.add({
          'name': _itemController.text,
          'quantity': 1,
          'checked': false,
          'category': 'Misc',
        });
        _itemController.clear();
      });
    }
  }

  void _toggleItem(int index) {
    setState(() {
      _groceryItems[index]['checked'] = !_groceryItems[index]['checked'];
    });
  }

  void _viewSummary() {
    final completed = _groceryItems.where((item) => item['checked']).length;
    Navigator.pushNamed(context, '/summary', arguments: {
      'totalItems': _groceryItems.length,
      'completed': completed,
      'items': _groceryItems,
    });
  }

  @override
  Widget build(BuildContext context) {
    final completed = _groceryItems.where((item) => item['checked']).length;
    return Scaffold(
      appBar: AppBar(
        title: Text('Grocery List'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: _viewSummary,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _itemController,
                    decoration: InputDecoration(
                      labelText: 'Add Item',
                      prefixIcon: Icon(Icons.add_shopping_cart, color: Colors.orange),
                      hintText: 'e.g., Bananas',
                    ),
                    onSubmitted: (_) => _addItem(),
                  ),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _addItem,
                  child: Icon(Icons.add),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _groceryItems.length,
              itemBuilder: (context, index) {
                final item = _groceryItems[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  color: item['checked'] ? Colors.green[50] : Colors.white,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: _getCategoryColor(item['category']),
                      child: Text(item['name'][0], style: TextStyle(color: Colors.white)),
                    ),
                    title: Text(
                      item['name'],
                      style: TextStyle(
                        decoration: item['checked'] ? TextDecoration.lineThrough : null,
                        fontWeight: item['checked'] ? FontWeight.normal : FontWeight.bold,
                      ),
                    ),
                    subtitle: Text('${item['quantity']} x ${item['category']}'),
                    trailing: Checkbox(
                      value: item['checked'],
                      onChanged: (_) => _toggleItem(index),
                      activeColor: Colors.orange,
                    ),
                    onTap: () => _toggleItem(index),
                  ),
                );
              },
            ),
          ),
          if (_groceryItems.isNotEmpty)
            Padding(
              padding: EdgeInsets.all(16),
              child: LinearProgressIndicator(
                value: completed / _groceryItems.length,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
              ),
            ),
        ],
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Fruits': return Colors.red;
      case 'Bakery': return Colors.brown;
      case 'Dairy': return Colors.blue;
      default: return Colors.grey;
    }
  }

  @override
  void dispose() {
    _itemController.dispose();
    super.dispose();
  }
}

class SummaryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final totalItems = args['totalItems'] as int;
    final completed = args['completed'] as int;
    final items = args['items'] as List<Map<String, dynamic>>;

    return Scaffold(
      appBar: AppBar(
        title: Text('Shopping Summary'),
        backgroundColor: Colors.orange,
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
                    Text('Progress: ${(completed / totalItems * 100).toStringAsFixed(0)}%', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    Text('$completed / $totalItems items completed', style: TextStyle(color: Colors.grey[600])),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 4),
                    child: ListTile(
                      leading: Icon(Icons.check_circle, color: item['checked'] ? Colors.green : Colors.orange),
                      title: Text(item['name']),
                      subtitle: Text('Qty: ${item['quantity']} | ${item['category']}'),
                      trailing: item['checked'] ? Icon(Icons.done, color: Colors.green) : null,
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