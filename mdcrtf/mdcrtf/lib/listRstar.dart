import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

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
        // print('Response Data: $users'); // Logging removed
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
            // print('User deleted successfully'); // Logging removed
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
                                // Adjust the spacing between the icon and text
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
                              'Rising star list',
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
                const SizedBox(height: 20.0),
                users.isEmpty
                    ? Container() // Show an empty container when users list is empty
                    : ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    var user = users[index];
                    return Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0), // Added horizontal padding
                      decoration: BoxDecoration(
                        color: Colors.white, // Set background color to white
                        borderRadius: BorderRadius.circular(10.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 2,
                            offset: Offset(0, 1), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Card(
                        elevation: 0, // Remove Card elevation since we're using a container with shadow
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Name: ${user['name'] ?? ''}',
                                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          'MCA: ${user['mca'] ?? ''}',
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                        ),
                                        Text(
                                          'Status: ${user['status'] ?? ''}',
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                        ),
                                        Text(
                                          'Mobile No: ${user['mobileno'] ?? ''}',
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                        ),
                                        Text(
                                          'Email: ${user['email'] ?? ''}',
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                        ),
                                        Text(
                                          'DOB: ${user['dob'] ?? ''}',
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                        ),
                                        Text(
                                          'Joining Date: ${user['joiningDate'] ?? ''}',
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                        ),
                                      ],
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      await deleteUser(user['mca'].toString());
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
                            ],
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
