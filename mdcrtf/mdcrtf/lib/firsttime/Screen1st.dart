import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Custom Stepper Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: CustomStepperPage(),
    );
  }
}

class CustomStepperPage extends StatefulWidget {
  @override
  _CustomStepperPageState createState() => _CustomStepperPageState();
}

class _CustomStepperPageState extends State<CustomStepperPage> {
  int _currentStep = 1;
  int _completedSteps = 0;

  void _incrementStep() {
    setState(() {
      if (_currentStep < 4) {
        _currentStep++;
        _completedSteps++;
      }
    });
  }

  void _decrementStep() {
    setState(() {
      if (_currentStep > 1) {
        _currentStep--;
        _completedSteps--;
      }
    });
  }

  Widget _buildStep(int stepNumber, String title, bool isActive, bool isDone) {
    Widget stepContent;
    if (isDone) {
      stepContent = Icon(
        Icons.check,
        color: Colors.white,
        size: 24.0,
      );
    } else {
      stepContent = Text(
        '$stepNumber',
        style: TextStyle(
          color: isActive ? Colors.white : Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      );
    }

    return Column(
      children: [
        Container(
          width: 35,
          height: 35,
          decoration: BoxDecoration(
            color: isActive ? Colors.blue : isDone ? Color(0xFF1FCBFF) : Colors.white,
            borderRadius: BorderRadius.circular(50),
            border: Border.all(color: Colors.black.withOpacity(0.2)),
          ),
          child: Center(child: stepContent),
        ),
        SizedBox(height: 4),
        Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isActive || isDone ? Color(0xFF1FA2FF) : Colors.grey,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Custom Stepper Demo'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              if (_currentStep > 1) {
                _decrementStep(); // Decrement step when back button is pressed
              } else {
                Navigator.of(context).pop(); // Pop the current screen if on the first step
              }
            },
          ),
        ),
        body: Stack(
          children: [
            Positioned(
              top: 35,
              left: 20,
              right: 30,
              child: Container(
                height: 6,
                color: Colors.grey[300], // Grey color for the line
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildStep(1, 'Set your\n dream', _currentStep == 1, _completedSteps >= 1),
                    _buildStep(2, 'Income\n simulator', _currentStep == 2, _completedSteps >= 2),
                    _buildStep(3, 'Set Income\n Goal', _currentStep == 3, _completedSteps >= 3),
                    _buildStep(4, 'Start your\n Azadi Journey', _currentStep == 4, _completedSteps >= 4),
                  ],
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  if (_currentStep > 1) {
                    _decrementStep();
                  }
                },
              ),
              IconButton(
                icon: Icon(Icons.arrow_forward),
                onPressed: () {
                  if (_currentStep < 4) {
                    _incrementStep();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
