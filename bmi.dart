import 'package:flutter/material.dart';

void main() => runApp(const BMICalculator());

class BMICalculator extends StatelessWidget {
  const BMICalculator({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BMI Calculator',
      theme: ThemeData.dark().copyWith(
        primaryColor: const Color(0xFF0A0E21),
        scaffoldBackgroundColor: const Color(0xFF0A0E21),
      ),
      home: const InputPage(),
    );
  }
}

class InputPage extends StatefulWidget {
  const InputPage({super.key});

  @override
  State<InputPage> createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  Gender? selectedGender;
  int height = 170;
  int weight = 60;
  int age = 25;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BMI CALCULATOR'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1D1E33), Color(0xFF111328)],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Gender Selection
              Row(
                children: [
                  Expanded(
                    child: ReusableCard(
                      onTap: () => setState(() => selectedGender = Gender.male),
                      color: selectedGender == Gender.male
                          ? const Color(0xFF4C4F6D)
                          : const Color(0xFF1D1E33),
                      child: GenderWidget(
                        icon: Icons.male,
                        label: 'MALE',
                        color: selectedGender == Gender.male
                            ? Colors.cyan
                            : Colors.white70,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ReusableCard(
                      onTap: () => setState(() => selectedGender = Gender.female),
                      color: selectedGender == Gender.female
                          ? const Color(0xFF4C4F6D)
                          : const Color(0xFF1D1E33),
                      child: GenderWidget(
                        icon: Icons.female,
                        label: 'FEMALE',
                        color: selectedGender == Gender.female
                            ? Colors.pinkAccent
                            : Colors.white70,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Height Slider
              ReusableCard(
                color: const Color(0xFF1D1E33),
                child: Column(
                  children: [
                    const Text('HEIGHT', style: kLabelTextStyle),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(height.toString(), style: kNumberTextStyle),
                        const Text(' cm', style: kLabelTextStyle),
                      ],
                    ),
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        activeTrackColor: Colors.cyan,
                        thumbColor: Colors.cyan,
                        overlayColor: Colors.cyan.withAlpha(40),
                        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 15),
                        overlayShape: const RoundSliderOverlayShape(overlayRadius: 30),
                      ),
                      child: Slider(
                        value: height.toDouble(),
                        min: 120,
                        max: 220,
                        onChanged: (value) => setState(() => height = value.round()),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Weight & Age
              Row(
                children: [
                  Expanded(
                    child: ReusableCard(
                      color: const Color(0xFF1D1E33),
                      child: CounterWidget(
                        label: 'WEIGHT',
                        value: weight,
                        onDecrease: () => setState(() => weight = (weight > 30) ? weight - 1 : 30),
                        onIncrease: () => setState(() => weight += 1),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ReusableCard(
                      color: const Color(0xFF1D1E33),
                      child: CounterWidget(
                        label: 'AGE',
                        value: age,
                        onDecrease: () => setState(() => age = (age > 1) ? age - 1 : 1),
                        onIncrease: () => setState(() => age += 1),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Calculate Button
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.cyan,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 10,
                    shadowColor: Colors.cyan.withOpacity(0.5),
                  ),
                  onPressed: () {
                    final bmi = weight / ((height / 100) * (height / 100));
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ResultPage(bmi: bmi),
                      ),
                    );
                  },
                  child: const Text(
                    'CALCULATE YOUR BMI',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Reusable Widgets
class ReusableCard extends StatelessWidget {
  final Color color;
  final Widget child;
  final VoidCallback? onTap;

  const ReusableCard({super.key, required this.color, required this.child, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.all(4),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: child,
      ),
    );
  }
}

class GenderWidget extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const GenderWidget({super.key, required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 80, color: color),
        const SizedBox(height: 12),
        Text(label, style: TextStyle(fontSize: 18, color: color)),
      ],
    );
  }
}

class CounterWidget extends StatelessWidget {
  final String label;
  final int value;
  final VoidCallback onDecrease;
  final VoidCallback onIncrease;

  const CounterWidget({
    super.key,
    required this.label,
    required this.value,
    required this.onDecrease,
    required this.onIncrease,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(label, style: kLabelTextStyle),
        Text(value.toString(), style: kNumberTextStyle),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RoundIconButton(icon: Icons.remove, onPressed: onDecrease),
            const SizedBox(width: 10),
            RoundIconButton(icon: Icons.add, onPressed: onIncrease),
          ],
        ),
      ],
    );
  }
}

class RoundIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const RoundIconButton({super.key, required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: onPressed,
      elevation: 6,
      constraints: const BoxConstraints.tightFor(width: 56, height: 56),
      shape: const CircleBorder(),
      fillColor: const Color(0xFF4C4F6D),
      child: Icon(icon, color: Colors.white),
    );
  }
}

// Result Page
class ResultPage extends StatelessWidget {
  final double bmi;

  const ResultPage({super.key, required this.bmi});

  String getResult() {
    if (bmi >= 25) return 'Overweight';
    if (bmi > 18.5) return 'Normal';
    return 'Underweight';
  }

  String getInterpretation() {
    if (bmi >= 25) return 'You have a higher than normal body weight. Try to exercise more.';
    if (bmi > 18.5) return 'You have a normal body weight. Good job!';
    return 'You have a lower than normal body weight. You can eat a bit more.';
  }

  Color getColor() {
    if (bmi >= 25) return Colors.redAccent;
    if (bmi > 18.5) return Colors.green;
    return Colors.orange;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('YOUR RESULT')),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1D1E33), Color(0xFF111328)],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                getResult().toUpperCase(),
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: getColor(),
                ),
              ),
              Text(
                bmi.toStringAsFixed(1),
                style: const TextStyle(fontSize: 100, fontWeight: FontWeight.bold),
              ),
              Text(
                'Normal BMI range:\n18.5 - 25',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, color: Colors.white70),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  getInterpretation(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 22),
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.cyan,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text('RE-CALCULATE', style: TextStyle(fontSize: 20)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Constants
const kLabelTextStyle = TextStyle(fontSize: 18, color: Color(0xFF8D8E98));
const kNumberTextStyle = TextStyle(fontSize: 50, fontWeight: FontWeight.w900);


enum Gender { male, female }
