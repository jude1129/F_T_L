import 'package:flutter/material.dart';
import 'dart:math' as math;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EMI Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.light,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
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
        '/results': (context) => ResultsScreen(),
      },
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _formKey = GlobalKey<FormState>();
  double _principal = 0;
  double _rate = 0;
  int _tenure = 0;
  double _emi = 0;

  void _calculateEMI() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        final p = _principal;
        final r = _rate / 12 / 100;
        final n = _tenure;
        _emi = p * r * math.pow(1 + r, n) / (math.pow(1 + r, n) - 1);
      });
      Navigator.pushNamed(context, '/results', arguments: {
        'emi': _emi,
        'principal': _principal,
        'rate': _rate,
        'tenure': _tenure,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('EMI Calculator'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildInputField('Principal Amount', Icons.account_balance, (v) => _principal = double.tryParse(v ?? '0') ?? 0),
              SizedBox(height: 16),
              _buildInputField('Interest Rate (%)', Icons.trending_up, (v) => _rate = double.tryParse(v ?? '0') ?? 0),
              SizedBox(height: 16),
              _buildInputField('Tenure (Months)', Icons.calendar_today, (v) => _tenure = int.tryParse(v ?? '0') ?? 0),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: _calculateEMI,
                child: Text('Calculate EMI', style: TextStyle(fontSize: 18)),
              ),
              SizedBox(height: 16),
              if (_emi > 0)
                Card(
                  color: Colors.green[50],
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Text('Estimated EMI: ₹${_emi.toStringAsFixed(2)}', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green[800])),
                        Text('Per Month', style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(String label, IconData icon, Function(String?) onChanged) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.blue),
        hintText: 'Enter ${label.toLowerCase()}',
      ),
      keyboardType: TextInputType.number,
      validator: (v) => (v == null || double.tryParse(v) == null || double.parse(v) <= 0) ? 'Enter valid number > 0' : null,
      onChanged: onChanged,
    );
  }
}

class ResultsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final emi = args['emi'] as double;
    final principal = args['principal'] as double;
    final rate = args['rate'] as double;
    final tenure = args['tenure'] as int;

    final monthlyRate = rate / 12 / 100;
    List<Map<String, double>> schedule = [];
    double balance = principal;
    for (int i = 1; i <= tenure; i++) {
      final interest = balance * monthlyRate;
      final principalPaid = emi - interest;
      balance -= principalPaid;
      schedule.add({
        'month': i.toDouble(),
        'principal': principalPaid,
        'interest': interest,
        'balance': balance.clamp(0.0, double.infinity),
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('EMI Breakdown'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(16),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Text('Loan Summary', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text('Principal: ₹${principal.toStringAsFixed(2)}', style: TextStyle(color: Colors.grey[600])),
                  Text('Rate: ${rate.toStringAsFixed(2)}%', style: TextStyle(color: Colors.grey[600])),
                  Text('Tenure: ${tenure} months', style: TextStyle(color: Colors.grey[600])),
                  Divider(height: 24),
                  Text('Monthly EMI: ₹${emi.toStringAsFixed(2)}', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue)),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: schedule.length,
              itemBuilder: (context, index) {
                final item = schedule[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text('${item['month']!.toInt()}'),
                      backgroundColor: Colors.blue[100],
                    ),
                    title: Text('Month ${item['month']!.toInt()}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Principal: ₹${item['principal']!.toStringAsFixed(2)}'),
                        Text('Interest: ₹${item['interest']!.toStringAsFixed(2)}'),
                      ],
                    ),
                    trailing: Text('₹${emi.toStringAsFixed(2)}', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}