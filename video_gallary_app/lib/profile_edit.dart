import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ProfileEditingScreen extends StatefulWidget {
  @override
  _ProfileEditingScreenState createState() => _ProfileEditingScreenState();
}

class _ProfileEditingScreenState extends State<ProfileEditingScreen> {
  PickedFile? _selectedImage;

  Future<void> _pickImage(ImageSource source) async {

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () => _pickImage(ImageSource.gallery),

            ),
            const SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(labelText: 'Full Name'),
              // Add your logic to handle full name changes
            ),
            const SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(labelText: 'Email'),
              // Add your logic to handle email changes
            ),
            const SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(labelText: 'Phone Number'),
              // Add your logic to handle phone number changes
            ),
            const SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(labelText: 'Address'),
              // Add your logic to handle address changes
            ),
          ],
        ),
      ),
    );
  }

}
