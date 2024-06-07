import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart'; // Import Cupertino library

class IncomeGoals extends StatefulWidget {
  @override
  _IncomeGoalsState createState() => _IncomeGoalsState();
}

class _IncomeGoalsState extends State<IncomeGoals> {
  bool sellProducts = true;
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
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20.0),
                      bottomRight: Radius.circular(20.0),
                    ),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.30),
                        offset: Offset(0, 1.5),
                        blurRadius: 0,
                      ),
                    ],
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Row(
                              children: [
                                Icon(
                                  Icons.arrow_back_ios,
                                  color: Colors.blue,
                                  size: 20.0,
                                ),
                                Text(
                                  'Back',
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 0.0),
                        ],
                      ),
                      SizedBox(height: 10.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'My Prospects',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          Text(
                            'Mohammad Mustafa',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10.0),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Dream Cheque',
                        style: TextStyle(
                          fontSize: 24.0,
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
    home: IncomeGoals(),
  ));
}
