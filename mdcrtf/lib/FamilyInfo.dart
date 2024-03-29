import 'package:flutter/material.dart';

class FamilyInfoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
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
                      'Calander',
                      style: TextStyle(
                        color: Color.fromARGB(255, 40, 40, 40),
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.0), // Add some spacing
              Container(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Family Info',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Text(
                      '0 Member',
                      style: TextStyle(fontSize: 18.0),
                    ),
                    SizedBox(height: 20.0),
                    Center(
                      child: Text(
                        'No family members added.',
                        style: TextStyle(fontSize: 18.0),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    ElevatedButton(
                      onPressed: () {
                        // Navigate to add family members screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AddMembersScreen()),
                        );
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.add_circle, size: 24.0),
                          SizedBox(width: 10.0),
                          Text(
                            'Add',
                            style: TextStyle(fontSize: 18.0),
                          ),
                        ],
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




class AddMembersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            margin: EdgeInsets.all(0.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                        'Add Family Members',
                        style: TextStyle(
                          color: Color.fromARGB(255, 40, 40, 40),
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.0), // Add some spacing
                Container(
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Add Family members',
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 20.0),
                      Text('Relation:', style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 5.0),
                      DropdownButtonFormField<String>(
                        items: [
                          DropdownMenuItem<String>(
                            value: 'Spouse',
                            child: Text('Spouse'),
                          ),
                          DropdownMenuItem<String>(
                            value: 'Father',
                            child: Text('Father'),
                          ),
                          DropdownMenuItem<String>(
                            value: 'Mother',
                            child: Text('Mother'),
                          ),
                          DropdownMenuItem<String>(
                            value: 'Son',
                            child: Text('Son'),
                          ),
                          DropdownMenuItem<String>(
                            value: 'Daughter',
                            child: Text('Daughter'),
                          ),
                        ],
                        onChanged: (value) {
                          // Handle dropdown value change
                        },
                      ),
                      SizedBox(height: 20.0),
                      Text('Name:', style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 5.0),
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: 'Full name',
                        ),
                      ),
                      SizedBox(height: 20.0),
                      Text('DOB:', style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 5.0),
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: 'Date of Birth',
                        ),
                      ),
                      SizedBox(height: 20.0),
                      Text('Anniversary:', style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 5.0),
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: 'Anniversary',
                        ),
                      ),
                      SizedBox(height: 20.0),
                      Text('Phone:', style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 5.0),
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: 'Phone no.',
                        ),
                      ),
                      SizedBox(height: 20.0),
                      Text('Email:', style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 5.0),
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: 'Email',
                        ),
                      ),
                      SizedBox(height: 20.0),
                      ElevatedButton(
                        onPressed: () {
                          // Handle add button click
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.add_circle, size: 24.0),
                            SizedBox(width: 10.0),
                            Text('Add', style: TextStyle(fontSize: 18.0)),
                          ],
                        ),
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
    debugShowCheckedModeBanner: false,
    home: FamilyInfoScreen(),
  ));
}
