import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart'; // Import Cupertino library
// ignore: unused_import
import 'package:t2t1/firsttime/step4_screen.dart'; // Import the 4th step screen

class step3_I_g extends StatefulWidget {
  final VoidCallback? onNextPressed;

  const step3_I_g({Key? key, this.onNextPressed}) : super(key: key);

  @override
  _step3_I_gState createState() => _step3_I_gState();
}

class _step3_I_gState extends State<step3_I_g> {
  bool sellProducts = false;
  bool createTeam = false;
  bool bothAbove = false;

  // Define colors for active and inactive switches
  Color activeColor = Colors.blue; // Change this to your desired color
  Color inactiveColor = Colors.grey;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(0.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Set Income Goal',
                        style: TextStyle(
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Text(
                        'Dream Cheque',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Container(
                        padding: EdgeInsets.only(
                          top: 4.0,
                          right: 3.0,
                          bottom: 5.0,
                          left: 64.0,
                        ),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage('https://rtfapi.modicare.com/img/ChequeBorder@3x.png'),
                            fit: BoxFit.cover,
                            alignment: Alignment.topLeft, // Aligns the image to the top left corner
                          ),
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 1,
                              blurRadius: 3,
                              offset: Offset(0, 2), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Bank of Azadi',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Pay Mohammad Mustafa',
                                  style: TextStyle(fontSize: 16.0),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Sum of ₹',
                                  style: TextStyle(fontSize: 16.0),
                                ),
                                Expanded( // Wrap the TextField with Expanded
                                  child: TextField(
                                    decoration: InputDecoration(
                                      hintText: '100000',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10.0),
                            Image.network(
                              'https://rtfapi.modicare.com/img/mr%20modi%20signature-01@3x.png',
                              width: 150,
                            ),
                            Text(
                              'MCA 70690073 Mr. Samir K Modi',
                              style: TextStyle(fontSize: 14.0),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20.0),
                      Text(
                        'Would you like to:',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10.0),
                      ListTile(
                        title: Text('Sell Products'),
                        trailing: CupertinoSwitch( // Using CupertinoSwitch
                          value: sellProducts,
                          onChanged: (value) {
                            setState(() {
                              sellProducts = value;
                              if (sellProducts && createTeam) {
                                bothAbove = true;
                              } else {
                                bothAbove = false;
                              }
                            });
                          },
                          activeColor: activeColor, // Set active color
                          trackColor: inactiveColor, // Set inactive color
                        ),
                      ),
                      ListTile(
                        title: Text('Create Team'),
                        trailing: CupertinoSwitch( // Using CupertinoSwitch
                          value: createTeam,
                          onChanged: (value) {
                            setState(() {
                              createTeam = value;
                              if (sellProducts && createTeam) {
                                bothAbove = true;
                              } else {
                                bothAbove = false;
                              }
                            });
                          },
                          activeColor: activeColor, // Set active color
                          trackColor: inactiveColor, // Set inactive color
                        ),
                      ),
                      ListTile(
                        title: Text('Both Above'),
                        trailing: CupertinoSwitch( // Using CupertinoSwitch
                          value: bothAbove,
                          onChanged: (value) {
                            setState(() {
                              bothAbove = value;
                              if (bothAbove) {
                                sellProducts = true;
                                createTeam = true;
                              } else {
                                sellProducts = false;
                                createTeam = false;
                              }
                            });
                          },
                          activeColor: activeColor, // Set active color
                          trackColor: inactiveColor, // Set inactive color
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.0),
                Container(
                  color: Color(0xFFf8f7fc), // Set background color
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0), // Padding from left and right: 16.0
                    child: Text(
                      '** In Modicare, your earnings are directly proportional to the effort and skills you invest. Success is determined by your dedication and ability to effectively market and sell products to customers and create a team of Modicare Direct Sellers.',
                      style: TextStyle(fontSize: 14.0),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20.0, right: 20.0),
                  child: Center(
                    child: SizedBox(
                      width: 130.0,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color(0xff12D8FA),
                              Color(0xff1FA2FF),
                              Color(0xff1FA2FF),
                            ],
                            begin: Alignment.centerRight,
                            end: Alignment.centerLeft,
                          ),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: TextButton(
                          onPressed: widget.onNextPressed, // Use onNextPressed callback
                          child: Text(
                            'Continue',
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
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
    home: step3_I_g(),
  ));
}
