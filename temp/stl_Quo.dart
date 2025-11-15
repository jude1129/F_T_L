import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Daily Quote',
      home: QuoteScreen(),
    );
  }
}

class QuoteScreen extends StatelessWidget {
  final String _quote = 'The only way to do great work is to love what you do.';
  final String _author = '- Steve Jobs';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Daily Quote'), backgroundColor: Colors.purple),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.purple[100]!, Colors.white],
          ),
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.format_quote, size: 60, color: Colors.purple),
                SizedBox(height: 20),
                Text(
                  _quote,
                  style: TextStyle(fontSize: 20, fontStyle: FontStyle.italic),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                Text(
                  _author,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.purple[800]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}