import 'package:flutter/material.dart';
import 'profile_edit.dart';

class ProfileScreen extends StatelessWidget {
  // Define gradient colors as variables
  final List<Color> gradientColors = [
    Color(0xff50aff1),
    Color(0xFF0071d6),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0, // Remove appbar elevation
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: gradientColors,
            ),
          ),
        ),
        title: Text('Profile', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: Container(
        color: Color(0xFFdfdfdf), // Set background color here
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: gradientColors, // Reuse gradient colors
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 70,
                    backgroundImage: AssetImage('assets/profile_dummy_image.jpg'),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'John Doe',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'john.doe@example.com',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[700],
                  ),
                ),
                SizedBox(height: 30),
                MaterialButton(
                  onPressed: () {
                    // Navigate to ProfileEditingScreen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfileEditingScreen(),
                      ),
                    );
                  },
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  color: gradientColors[0], // Use the first color in the gradient
                  child: Text(
                    'Edit Profile',
                    style: TextStyle(fontSize: 18, color: Colors.white),
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
