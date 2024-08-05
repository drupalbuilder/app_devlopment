import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart'; // Import the vibration package

class ReportScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20.0),
                    bottomRight: Radius.circular(20.0),
                  ),
                  color: Color.fromARGB(255, 255, 255, 255),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.30),
                      offset: Offset(0, 1.5),
                      blurRadius: 0,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context); // Go back to the previous page
                          },
                          child: Row(
                            children: [
                              Icon(
                                Icons.arrow_back_ios,
                                color: Color(0xFF0396FE),
                                size: 20.0,
                              ), // Adjust the spacing between the icon and text
                              Text(
                                'Back',
                                style: TextStyle(
                                  color: Color(0xFF0396FE),
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 10.0), // Add space here
                    Padding(
                      padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0), // Padding top and bottom
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Report an Issue / Feedback',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey, // Choose your desired border color
                          width: 1.0, // Adjust the border width as needed
                        ),
                        borderRadius: BorderRadius.circular(10.0), // Adjust the border radius as needed
                      ),
                      child: TextFormField(
                        maxLines: 8,
                        decoration: InputDecoration(
                          hintText: 'Share your feedback or issues.',
                          contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                          border: InputBorder.none, // Remove the default border of the TextFormField
                        ),
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    GestureDetector(
                      onTap: () {
                        // Add vibration effect on button press
                        if (Vibration.hasVibrator() != null) {
                          Vibration.vibrate(duration: 100); // Vibrate for 100 milliseconds
                        }
                        // Add functionality for the Send button here
                      },
                      child: Container(
                        width: double.infinity,
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
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 12.0),
                          child: Text(
                            'Send',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ReportScreen(),
  ));
}
