import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shopping Cart',
      home: CartScreen(),
    );
  }
}

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<Map<String, dynamic>> _cartItems = [
    {'name': 'Laptop', 'price': 999.99, 'quantity': 1},
  ];
  double _total = 999.99;

  void _addItem() {
    setState(() {
      _cartItems.add({'name': 'Mouse', 'price': 29.99, 'quantity': 1});
      _total += 29.99;
    });
  }

  void _removeItem(int index) {
    setState(() {
      _total -= _cartItems[index]['price'] * _cartItems[index]['quantity'];
      _cartItems.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Shopping Cart'), backgroundColor: Colors.orange),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _cartItems.length,
              padding: EdgeInsets.all(16),
              itemBuilder: (context, index) {
                final item = _cartItems[index];
                return ListTile(
                  leading: Icon(Icons.shopping_bag, color: Colors.orange),
                  title: Text(item['name']),
                  subtitle: Text('Qty: ${item['quantity']}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('\$${item['price'].toStringAsFixed(2)}'),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _removeItem(index),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Text('Total: \$${_total.toStringAsFixed(2)}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addItem,
        child: Icon(Icons.add),
        backgroundColor: Colors.orange,
      ),
    );
  }
}