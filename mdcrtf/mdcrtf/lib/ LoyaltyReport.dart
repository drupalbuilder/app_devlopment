import 'package:flutter/material.dart';

class LoyaltyReport extends StatelessWidget {
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
                  padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20.0),
                      bottomRight: Radius.circular(20.0),
                    ),
                    color: Color.fromARGB(255, 255, 255, 255),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.43),
                        offset: Offset(0, 1),
                        blurRadius: 2,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back,
                            color: Color.fromARGB(255, 40, 40, 40)),
                        onPressed: () {
                          Navigator.pop(context); // Navigate back when pressed
                        },
                      ),
                      Text(
                        'Loyalty Report',
                        style: TextStyle(
                          color: Color.fromARGB(255, 40, 40, 40),
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
                  child: Row(
                    children: [
                    ],
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
    home: LoyaltyReport(),
  ));
}
