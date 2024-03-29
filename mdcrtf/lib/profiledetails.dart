import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class Profiledetails extends StatefulWidget {
  @override
  _ProfiledetailsState createState() => _ProfiledetailsState();
}

class _ProfiledetailsState extends State<Profiledetails> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _mcaController = TextEditingController();
  TextEditingController _mobileController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _dobController = TextEditingController();
  TextEditingController _imgController = TextEditingController();
  TextEditingController _addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userDataJson = prefs.getString('userData') ?? '';

    if (userDataJson.isNotEmpty) {
      Map<String, dynamic> userData = json.decode(userDataJson);

      setState(() {
        _nameController.text = userData['name'] ?? '';
        _mcaController.text = userData['mca'] != null ? userData['mca'].toString() : '';
        _mobileController.text = userData['mobileno'] ?? '';
        _emailController.text = userData['email'] ?? '';
        _dobController.text = userData['dob'] ?? '';
        _imgController.text = userData['img'] ?? '';
        _addressController.text = userData['address'] ?? '';

        // Update the CircleAvatar's backgroundImage if img is available
        if (userData['img'] != null && userData['img'].isNotEmpty) {
          _imgController.text = userData['img'];
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
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
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Profile Image Section
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'My Profile',
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 10.0),
                                Text(
                                  'Name',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                SizedBox(height: 10.0),
                                Text(
                                  ' ${_nameController.text}',
                                  style: TextStyle(
                                  ),
                                ),

                                SizedBox(height: 10.0),
                                Text(
                                  'MCA',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 10.0),
                                Text(
                                  '${_mcaController.text}',
                                  style: TextStyle(
                                  ),
                                ),
                                SizedBox(height: 10.0),
                                Text(
                                  'Date of Birth',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 10.0),
                                Text(
                                  '${_dobController.text}',
                                  style: TextStyle(
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              alignment: Alignment.centerRight,
                              child: GestureDetector(
                                onTap: () {
                                  // Handle image upload
                                },
                                child: Stack(
                                  children: [
                                    CircleAvatar(
                                      radius: 50.0,
                                      backgroundImage: _imgController.text.isNotEmpty
                                          ? NetworkImage(_imgController.text.toString())
                                          : AssetImage('assets/profile_placeholder.png') as ImageProvider,
                                    ),
                                    Positioned(
                                      bottom: 0,
                                      right: 0,
                                      child: Container(
                                        padding: EdgeInsets.all(8.0),
                                        decoration: BoxDecoration(
                                          color: Colors.black54,
                                          borderRadius: BorderRadius.circular(50.0),
                                        ),
                                        child: Icon(
                                          Icons.camera_alt,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),


                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20.0),
                      // Contact Details Section
                      Text(
                        'Contact Details',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10.0),
                      // Phone
                      Text(
                        'Phone',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Text(
                        '${_mobileController.text}',
                        style: TextStyle(
                        ),
                      ),
                      SizedBox(height: 10.0),
                      // Email
                      Text(
                        'Email',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Text(
                        '${_emailController.text}',
                        style: TextStyle(
                        ),
                      ),
                      SizedBox(height: 20.0),
                      // Address Section
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Address',
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              // Navigate to AddAddressScreen
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => AddAddressScreen()),
                              );
                            },
                            child: Row(
                              children: [
                                Icon(
                                  Icons.add_circle_outline,
                                  color: Colors.blue,
                                ),
                                Text('Add'),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10.0),
                      Text(
                        '${_addressController.text}',
                        style: TextStyle(
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}







class AddAddressScreen extends StatelessWidget {
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
                        'Update Address',
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Address',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: '1234 Main St',
                            ),
                            validator: (value) {
                              if (value?.isEmpty ?? true) {
                                return 'Please enter the address';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 20.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Address 2',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Apartment, studio, or floor',
                            ),
                            validator: (value) {
                              if (value?.isEmpty ?? true) {
                                return 'Please enter the second address';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 20.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Country',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          DropdownButtonFormField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                            items: [
                              DropdownMenuItem(
                                value: 'India',
                                child: Text('India'),
                              ),
                              // Add more countries as needed
                            ],
                            onChanged: (value) {
                              // Handle country selection
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 20.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'State',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          DropdownButtonFormField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                            items: [
                              DropdownMenuItem(
                                value: 'Andaman And Nicobar Islands',
                                child: Text('Andaman And Nicobar Islands'),
                              ),
                              DropdownMenuItem(
                                value: 'Andhra Pradesh',
                                child: Text('Andhra Pradesh'),
                              ),
                              // Add more states as needed
                            ],
                            onChanged: (value) {
                              // Handle state selection
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 20.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'City',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value?.isEmpty ?? true) {
                                return 'Please enter the city';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 20.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Postcode',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value?.isEmpty ?? true) {
                                return 'Please enter the postcode';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 20.0),
                      ElevatedButton(
                        onPressed: () {
                          // Implement your update logic here
                        },
                        child: Text('Update Address'),
                      ),
                      SizedBox(height: 20.0),
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
    home: AddAddressScreen(),
  ));
}

