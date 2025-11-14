import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Patient Billing System',
      theme: ThemeData(
        primarySwatch: Colors.green,
        brightness: Brightness.light,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
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
        '/billing': (context) => BillingScreen(),
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
  final _patientIdController = TextEditingController();
  final _patientNameController = TextEditingController();
  final _daysControllers = List.generate(5, (_) => TextEditingController());

  final List<String> _roomTypes = ['General Ward (₹500/day)', 'Semi Private (₹1000/day)', 'Private (₹2000/day)', 'Deluxe (₹3000/day)', 'Suite (₹5000/day)'];
  final List<double> _roomRates = [500, 1000, 2000, 3000, 5000];

  double _totalCost = 0;

  void _calculateTotal() {
    setState(() {
      _totalCost = 0;
      for (int i = 0; i < 5; i++) {
        final days = int.tryParse(_daysControllers[i].text) ?? 0;
        _totalCost += days * _roomRates[i];
      }
    });
  }

  void _submitBilling() {
    if (_formKey.currentState!.validate() && (_totalCost > 0)) {
      Navigator.pushNamed(context, '/billing', arguments: {
        'patientId': _patientIdController.text,
        'patientName': _patientNameController.text,
        'totalCost': _totalCost,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Patient Billing'),
        backgroundColor: Colors.green,
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
              TextFormField(
                controller: _patientIdController,
                decoration: InputDecoration(
                  labelText: 'Patient ID',
                  prefixIcon: Icon(Icons.person, color: Colors.green),
                  hintText: 'Enter Patient ID',
                ),
                validator: (v) => v!.isEmpty ? 'Enter Patient ID' : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _patientNameController,
                decoration: InputDecoration(
                  labelText: 'Patient Name',
                  prefixIcon: Icon(Icons.account_circle, color: Colors.green),
                  hintText: 'Enter Patient Name',
                ),
                validator: (v) => v!.isEmpty ? 'Enter Patient Name' : null,
              ),
              SizedBox(height: 24),
              Text('Room Details (Days Stay):', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Expanded(
                child: ListView.builder(
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 4),
                      child: ListTile(
                        leading: Icon(Icons.bed, color: Colors.green),
                        title: Text(_roomTypes[index]),
                        subtitle: TextFormField(
                          controller: _daysControllers[index],
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Days',
                            hintText: '0 if not used',
                          ),
                          onChanged: (_) => _calculateTotal(),
                          validator: (v) => int.tryParse(v ?? '0') == null ? 'Enter valid days' : null,
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _calculateTotal,
                child: Text('Preview Total', style: TextStyle(fontSize: 16)),
              ),
              SizedBox(height: 8),
              if (_totalCost > 0)
                Card(
                  color: _totalCost > 8000 ? Colors.red[50] : Colors.green[50],
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Total Cost: ₹${_totalCost.toStringAsFixed(2)}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: _totalCost > 8000 ? Colors.red[800] : Colors.green[800])),
                        Icon(_totalCost > 8000 ? Icons.warning : Icons.check_circle, color: _totalCost > 8000 ? Colors.red : Colors.green),
                      ],
                    ),
                  ),
                ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _submitBilling,
                child: Text('Generate Bill', style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _patientIdController.dispose();
    _patientNameController.dispose();
    for (var controller in _daysControllers) controller.dispose();
    super.dispose();
  }
}

class BillingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final patientId = args['patientId'] as String;
    final patientName = args['patientName'] as String;
    final totalCost = args['totalCost'] as double;

    final isOver = totalCost > 8000;
    final color = isOver ? Colors.red : Colors.green;

    return Scaffold(
      appBar: AppBar(
        title: Text('Billing Summary'),
        backgroundColor: color,
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
              color: color[50],
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Icon(isOver ? Icons.warning : Icons.check_circle, size: 64, color: color),
                    SizedBox(height: 16),
                    Text('Patient ID: $patientId', style: TextStyle(fontSize: 16, color: Colors.grey[600])),
                    Text('Patient Name: $patientName', style: TextStyle(fontSize: 16, color: Colors.grey[600])),
                    SizedBox(height: 16),
                    Text('Total Room Rent & Cost: ₹${totalCost.toStringAsFixed(2)}', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: color)),
                    Text(isOver ? 'Cost exceeds ₹8000 limit!' : 'Within budget.', style: TextStyle(fontSize: 14, color: color[700])),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24),
            Expanded(
              child: ListView(
                children: [
                  _buildDetailCard('Billing Generated', Icons.receipt, 'Summary for $patientName'),
                  _buildDetailCard('Total Days', Icons.calendar_today, 'Calculated based on room stays'),
                  _buildDetailCard('Status', Icons.info, isOver ? 'Review for approval' : 'Approved'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailCard(String title, IconData icon, String subtitle) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: CircleAvatar(child: Icon(icon, color: Colors.green)),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: Icon(Icons.arrow_forward_ios, size: 16),
      ),
    );
  }
}