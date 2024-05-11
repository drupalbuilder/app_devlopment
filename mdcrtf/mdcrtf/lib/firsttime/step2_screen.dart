import 'package:flutter/material.dart';
import 'package:t2t1/firsttime/stepper.dart'; // Import the step 3 screen

class INCOMEsimlator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(0.0),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
                  child: Row(
                    children: [],
                  ),
                ),
                SizedBox(height: 20.0),
                Center(
                  child: Text(
                    'INCOME simulator',
                    style: TextStyle(
                      fontSize: 30.0,
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                GestureDetector(
                  onTap: () {
                    // Trigger the increment of step in CustomStepperPage widget
                    CustomStepperPage.of(context)?.incrementStep(); // Go to step 3
                  },
                  child: SizedBox(
                    width: 240.0, // Adjust the width as needed
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF1FA2FF), Color(0xFF1FA2FF), Color(0xFF12D8FA)],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(50.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 7,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          'Next',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: INCOMEsimlator(),
  ));
}
