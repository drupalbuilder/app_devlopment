import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

class RisingStarsPage extends StatefulWidget {
  @override
  _RisingStarsPageState createState() => _RisingStarsPageState();
}

class _RisingStarsPageState extends State<RisingStarsPage> {
  List<dynamic> users = [];

  @override
  void initState() {
    super.initState();
    if (users.isEmpty) {
      fetchData(); // Fetch data only if the user list is empty
    }
  }

  Future<void> fetchData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? mcaNumber = prefs.getString('mcaNumber');

      // Construct URL with API endpoint and action
      String apiUrl = 'https://mdcapp.gprlive.com/api.php?action=risingstars_list';

      // Create headers with the cookie containing mcaNumber
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Cookie': 'mdc_mca=$mcaNumber', // Set the cookie with mcaNumber
      };

      // Make GET request to API
      var response = await http.get(Uri.parse(apiUrl), headers: headers);

      // Check response status
      if (response.statusCode == 200) {
        // Request successful, parse response data
        setState(() {
          users = json.decode(response.body);
        });
      } else {
        // Request failed, handle error
        print('Request failed with status: ${response.statusCode}');
        print('Response Body: ${response.body}');
        // Show error message or update UI accordingly
        setState(() {
          users = []; // Clear the user list
        });
      }
    } catch (e) {
      print('Error fetching rising stars: $e');
      // Show error message or update UI accordingly
      setState(() {
        users = []; // Clear the user list
      });
    }
  }

  Future<void> deleteUser(String mca) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? umca = prefs.getString('mcaNumber');

      if (umca != null) {
        // Construct URL with API endpoint and query parameters
        String apiUrl = 'https://mdcapp.gprlive.com/risingstars_api.php?mca=$mca&umca=$umca';

        // Make DELETE request to API
        var response = await http.delete(Uri.parse(apiUrl));

        // Check response status
        if (response.statusCode == 200) {
          var result = json.decode(response.body);
          if (result['success']) {
            // Request successful, remove user from list
            setState(() {
              users.removeWhere((user) => user['mca'].toString() == mca);
            });
          } else {
            print('Delete failed: ${result['message']}');
          }
        } else {
          // Request failed, handle error
          print('Request failed with status: ${response.statusCode}');
          print('Response Body: ${response.body}');
        }
      } else {
        print('UMCA not found in SharedPreferences');
      }
    } catch (e) {
      print('Error deleting user: $e');
    }
  }

  // Method to call a contact
  void _callContact(String phoneNumber) async {
    final Uri callUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunch(callUri.toString())) {
      await launch(callUri.toString());
    } else {
      // Handle error, for example by showing a snackbar or alert dialog
      print("Could not launch phone call");
    }
  }

  // Method to send an SMS
  void _sendSms(String phoneNumber) async {
    final Uri smsUri = Uri(scheme: 'sms', path: phoneNumber);
    if (await canLaunch(smsUri.toString())) {
      await launch(smsUri.toString());
    } else {
      // Handle error
      print("Could not send SMS");
    }
  }

  // Method to send a WhatsApp message
  void _sendWhatsAppMessage(String phoneNumber) async {
    final Uri whatsappUri = Uri.parse("whatsapp://send?phone=$phoneNumber");
    if (await canLaunch(whatsappUri.toString())) {
      await launch(whatsappUri.toString());
    } else {
      // Handle error
      print("Could not send WhatsApp message");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(0.0),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
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
                              Navigator.pop(
                                  context); // Go back to the previous page
                            },
                            child: Row(
                              children: [
                                Icon(
                                  Icons.arrow_back_ios,
                                  color: Color(0xFF0396FE),
                                  size: 20.0,
                                ),
                                Text(
                                  'Back', // Removed the '<'
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
                        padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
                        // Padding top and bottom
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Your rising stars',
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
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    var user = users[index];

                    // Extract initials from user's name
                    String name = user['name'] ?? '';
                    String initials = name.isNotEmpty ? name[0].toUpperCase() : '';

                    return Container(
                      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
                      child: Material(
                        elevation: 4.0,
                        borderRadius: BorderRadius.circular(10.0),
                        shadowColor: Colors.grey.withOpacity(0.5),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: Container(
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  // Row for Circular Avatar and User Info
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      // Circular Avatar
                                      Container(
                                        width: 80,
                                        height: 80,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.blue,
                                        ),
                                        child: Center(
                                          child: Text(
                                            initials,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 16.0), // Space between avatar and text
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.only(left: 14.0), // Padding between text and avatar
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '${user['name'] ?? ''}',
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black, // Use blue color
                                                ),
                                              ),

                                              SizedBox(height: 5),
                                              Text(
                                                '${user['paidas'] ?? ''}',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500, // You can choose a number between 100 and 900
                                                  color: Colors.grey, // Use blue color
                                                ),
                                              ),
                                              Text(
                                                '${user['valid_title'] ?? ''}',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500, // You can choose a number between 100 and 900
                                                  color: Colors.grey, // Use blue color
                                                ),
                                              ),
                                              Text(
                                                'MCA: ${user['mca'] ?? ''}',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500, // You can choose a number between 100 and 900
                                                  color: Colors.grey, // Use blue color
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),


                                  SizedBox(height: 16.0), // Space between info and icons

                                  // Icon Buttons Row
                                  Row(
                                    children: [
                                      // Loyalty Months Column
                                      Expanded(
                                        flex: 2, // Adjust the flex value to control the space allocation
                                        child: Padding(
                                          padding: const EdgeInsets.only(right: 16.0), // Add padding to the right
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.center, // Center horizontally in column
                                            children: [
                                              Text(
                                                'Loyalty Months',
                                                style: TextStyle(fontSize: 09, fontWeight: FontWeight.bold),
                                              ),
                                              SizedBox(height: 2), // Optional: space between title and value
                                              Text(
                                                '${user['loyalty_month'] ?? 0}', // Display 0 if the value is null
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.blue, // Blue color for the value
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),

                                      // Icon Buttons with padding
                                      Expanded(
                                        flex: 5, // Adjust the flex value to control the space allocation
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween, // Distribute space evenly
                                          children: [
                                            IconButton(
                                              icon: Icon(Icons.call),
                                              color: Colors.lightBlue,
                                              onPressed: () {
                                                if (user['mobileno'] != null) {
                                                  _callContact(user['mobileno']);
                                                }
                                              },
                                            ),
                                            IconButton(
                                              icon: Icon(Icons.message),
                                              color: Colors.lightBlue,
                                              onPressed: () {
                                                if (user['mobileno'] != null) {
                                                  _sendSms(user['mobileno']);
                                                }
                                              },
                                            ),
                                            IconButton(
                                              icon: Icon(Icons.messenger_outline),
                                              color: Colors.lightBlue,
                                              onPressed: () {
                                                if (user['mobileno'] != null) {
                                                  _sendWhatsAppMessage(user['mobileno']);
                                                }
                                              },
                                            ),
                                            Spacer(), // Spacer pushes the star icon to the far right
                                            GestureDetector(
                                              onTap: () async {
                                                if (user['mca'] != null) {
                                                  await deleteUser(user['mca'].toString());
                                                }
                                              },
                                              child: Container(
                                                width: 40,
                                                height: 40,
                                                decoration: BoxDecoration(
                                                  color: Color(0xFFFFA500),
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Center(
                                                  child: Icon(
                                                    Icons.star,
                                                    color: Colors.white,
                                                    size: 28,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  )

                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 20.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
