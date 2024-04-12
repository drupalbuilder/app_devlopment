import 'package:flutter/material.dart';

class Documents extends StatelessWidget {
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
                        ' DOCUMENTS',
                        style: TextStyle(
                          color: Color.fromARGB(255, 40, 40, 40),
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 20.0),

                // Container with "My Documents" title and contents
                Container(
                  padding: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Color(0xFFFDFFFD), // Set background color to FDFDFDFF
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        offset: Offset(0, 2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'My Documents',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Row(
                        children: [
                          Icon(Icons.circle, size: 10.0, color: Colors.blue),
                          SizedBox(width: 5.0),
                          Text('NEFT'),
                          SizedBox(width: 20.0),
                          Icon(Icons.circle, size: 10.0, color: Colors.blue),
                          SizedBox(width: 5.0),
                          Text('KYC'),
                          SizedBox(width: 20.0),
                          Icon(Icons.circle, size: 10.0, color: Colors.blue),
                          SizedBox(width: 5.0),
                          Text('PAN'),
                        ],
                      ),
                      SizedBox(height: 20.0),
                      TextButton(
                        onPressed: () {
                          // Add your functionality here
                        },
                        child: Row(
                          children: [
                            Icon(Icons.arrow_downward),
                            SizedBox(width: 10.0),
                            Text(
                              'MCA card',
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.0),

                // Container for "Resources" section
                Container(
                  padding: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Color(0xFFFDFFFD), // Set background color to FDFDFDFF
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        offset: Offset(0, 2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Resources',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 10.0),
                      // List of resources
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            title: Text(
                              'Order cancellation form',
                              style: TextStyle(fontSize: 16.0),
                            ),
                            trailing: Icon(Icons.arrow_downward),
                            onTap: () {
                              // Handle onTap
                            },
                          ),
                          ListTile(
                            title: Text(
                              'Product return form',
                              style: TextStyle(fontSize: 16.0),
                            ),
                            trailing: Icon(Icons.arrow_downward),
                            onTap: () {
                              // Handle onTap
                            },
                          ),
                          ListTile(
                            title: Text(
                              'CAF',
                              style: TextStyle(fontSize: 16.0),
                            ),
                            trailing: Icon(Icons.arrow_downward),
                            onTap: () {
                              // Handle onTap
                            },
                          ),
                        ],
                      ),
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
    home: Documents(),
  ));
}
