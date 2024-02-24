import 'package:flutter/material.dart';

class ProfileEditingScreen extends StatefulWidget {
  @override
  _ProfileEditingScreenState createState() => _ProfileEditingScreenState();
}

class _ProfileEditingScreenState extends State<ProfileEditingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Color(0xff50aff1).withOpacity(0.5), // Adjust opacity here
                Color(0xFF0071d6).withOpacity(0.5), // Adjust opacity here
              ],
            ),
          ),
        ),
        title: Text('Edit Profile'),
        actions: [
          TextButton(
            onPressed: () {
              // Implement save changes logic
            },
            child: Text(
              'Save Changes',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Color(0xff50aff1).withOpacity(0.5), // Adjust opacity here
              Color(0xFF0071d6).withOpacity(1), // Adjust opacity here
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    // Implement logic to change profile picture
                  },
                  child: Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white, // Set background color to white
                    ),
                    child: Icon(
                      Icons.person,
                      size: 70,
                      color: Color(0xff50aff1), // Set icon color to match gradient
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                _buildProfileTextField('Full Name', Icons.person),
                const SizedBox(height: 20),
                _buildProfileTextField('Email', Icons.email),
                const SizedBox(height: 20),
                _buildProfileTextField('Phone Number', Icons.phone),
                const SizedBox(height: 20),
                _buildProfileTextField('Address', Icons.location_on),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileTextField(String labelText, IconData icon) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
        decoration: InputDecoration(
          labelText: labelText,
          icon: Icon(icon, color: Colors.white),
          labelStyle: TextStyle(color: Colors.white),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(8.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(8.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        style: TextStyle(color: Colors.white),
        cursorColor: Colors.white,
        // Add your logic to handle profile changes
      ),
    );
  }
}
