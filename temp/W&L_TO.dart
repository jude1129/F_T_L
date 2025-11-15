import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo Layout',
      home: TodoScreen(),
    );
  }
}

class TodoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Daily Tasks'), backgroundColor: Colors.teal),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.teal[50],
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(color: Colors.grey[300]!, blurRadius: 4)],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.task_alt, color: Colors.teal, size: 30),
                      Text('Urgent Tasks', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                      Checkbox(value: true, onChanged: null),
                    ],
                  ),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: Text('Buy groceries', style: TextStyle(fontSize: 16, color: Colors.black87)),
                      ),
                      Icon(Icons.edit, color: Colors.grey),
                    ],
                  ),
                  Divider(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: Text('Call doctor', style: TextStyle(fontSize: 16, color: Colors.black87)),
                      ),
                      Icon(Icons.delete, color: Colors.red),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}