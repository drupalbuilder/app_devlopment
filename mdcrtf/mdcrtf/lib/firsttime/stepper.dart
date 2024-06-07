import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart'; // Import Cupertino library
import 'package:t2t1/firsttime/step1_screen.dart';
import 'package:t2t1/firsttime/step2_screen.dart';
import 'package:t2t1/firsttime/step3_screen.dart';
import 'package:t2t1/firsttime/step4_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.blue),
      home: CustomStepperPage(),
    );
  }
}

class CustomStepperPage extends StatefulWidget {
  @override
  _CustomStepperPageState createState() => _CustomStepperPageState();

  // Method to provide access to the state of CustomStepperPage widget
  static _CustomStepperPageState? of(BuildContext context) =>
      context.findAncestorStateOfType<_CustomStepperPageState>();
}

class _CustomStepperPageState extends State<CustomStepperPage> {
  int _currentStep = 1;
  int _completedSteps = 0;

  void incrementStep() {
    setState(() {
      if (_currentStep < 4) {
        _currentStep++;
        if (_completedSteps < _currentStep - 1) {
          _completedSteps = _currentStep - 1;
        }
      }
    });
  }

  void decrementStep() {
    setState(() {
      if (_currentStep > 1) {
        _currentStep--;
      }
    });
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 1:
        return Setyourdreames(
          onNextPressed: incrementStep,
        );
      case 2:
        return INCOMEsimlator();
      case 3:
        return Step3IG(
          onNextPressed: incrementStep,
        );
      case 4:
        return setazadijourny();
      default:
        return SizedBox(); // Return empty container if stepContent is null
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              child: GestureDetector(
                onTap: () {
                  if (_currentStep > 1) {
                    decrementStep();
                  } else {
                    Navigator.pop(context); // Go back to the previous screen if on the first step
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'ᐸ  Back',
                    style: TextStyle(
                      color: Color(0xFF0396FE),
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 76,
              left: 30,
              right: 30,
              child: Container(
                height: 6,
                color: Colors.grey[300], // Grey color for the line
              ),
            ),
            Positioned(
              top: 34,
              left: 40,
              right: 40,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildStepWidget(1, 'Set your\n dream', _currentStep > 1, _currentStep == 1),
                    _buildStepWidget(2, 'Income\n simulator', _currentStep > 2, _currentStep == 2),
                    _buildStepWidget(3, 'Set Income\n Goal', _currentStep > 3, _currentStep == 3),
                    _buildStepWidget(4, 'Start your\n Azadi Journey', _currentStep > 4, _currentStep == 4),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 152,
              left: 0,
              right: 0,
              bottom: 0,
              child: _buildStepContent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepWidget(int stepNumber, String title, bool completed, bool isActive) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: isActive ? Colors.lightBlueAccent : completed ? Color(0xFF1FA2FF) : Colors.white,
            borderRadius: BorderRadius.circular(50),
            border: Border.all(color: Colors.black.withOpacity(0.2), width: 2.0), // Specified border width
          ),
          child: Center(
            child: completed
                ? Icon(Icons.check, color: Colors.white, size: 24.0)
                : Text('$stepNumber', style: TextStyle(color: isActive ? Colors.white : Colors.black, fontWeight: FontWeight.bold, fontSize: 18)),
          ),
        ),
        SizedBox(height: 4),
        Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: completed ? Color(0xFF1FA2FF) : Colors.grey,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  void setTarget(String target) {}
}

