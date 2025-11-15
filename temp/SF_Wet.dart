import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather Tracker',
      home: WeatherScreen(),
    );
  }
}

class WeatherScreen extends StatefulWidget {
  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  double _temperature = 22.0;
  String _condition = 'Sunny';

  void _updateWeather() {
    setState(() {
      _temperature += 1.5; // Simulate change
      _condition = _temperature > 25 ? 'Hot' : 'Mild';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Weather Tracker'), backgroundColor: Colors.blue),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.wb_sunny, size: 80, color: Colors.yellow),
            SizedBox(height: 20),
            Text('Temperature: ${_temperature.toStringAsFixed(1)}°C', style: TextStyle(fontSize: 24)),
            SizedBox(height: 10),
            Text('Condition: $_condition', style: TextStyle(fontSize: 18, color: Colors.grey[600])),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: _updateWeather,
              child: Text('Update Weather'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            ),
          ],
        ),
      ),
    );
  }
}