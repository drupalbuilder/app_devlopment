import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'listRstar.dart';
import 'package:url_launcher/url_launcher.dart';


void main() {
  runApp(MaterialApp(
    home: MyNetwork(),
  ));
}

class MyNetwork extends StatefulWidget {
  @override
  _MyNetworkState createState() => _MyNetworkState();
}

class _MyNetworkState extends State<MyNetwork> {
  String token = '';
  String? mcaNumber;
  List consultants = [];
  int pageNo = 1;
  bool isLoading = false;
  bool hasMore = true;
  List<dynamic> users = [];

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _getTokenAndFetchData();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _fetchMoreData();
      }
    });
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
      await (whatsappUri.toString());
    } else {
      // Handle error
      print("Could not send WhatsApp message");
    }
  }

  Future<void> _getTokenAndFetchData() async {
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('auth_token') ?? '';
    mcaNumber = prefs.getString('mcaNumber');

    if (token.isEmpty) {
      token = await _fetchAuthToken();
      await prefs.setString('auth_token', token);
    }

    await _fetchDownlineData();
    await fetchData(); // Call fetchData here
  }

  Future<String> _fetchAuthToken() async {
    final response = await http.get(
      Uri.parse('https://api.modicare.com/api/sr/token/app/$mcaNumber'),
      headers: {
        'x-api-key': 'RFE5GE-9YWNGQ-UYT9T6-KNR1F2',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['token'];
    } else {
      throw Exception('Failed to fetch auth token');
    }
  }

  Future<void> _fetchDownlineData() async {
    if (isLoading || !hasMore) return;

    setState(() {
      isLoading = true;
    });

    try {
      final token = await _fetchAuthToken(); // Fetch the token before making the request

      final uri = Uri.parse('https://api.modicare.com/api/app/consultant/downline/list');
      final headers = {
        'Content-Type': 'application/json',
        'x-auth-token': token, // Use the fetched token here
      };
      final body = {
        'downline': '0',
        'page_no': '$pageNo',
        'page_size': '50',
        'type': '1',
      };

      print('Request URI: $uri');
      print('Request Headers: $headers');
      print('Request Body: $body');

      final response = await http.post(
        uri,
        headers: headers,
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          pageNo++;
          consultants.addAll(data['result']['consultants']);
          isLoading = false;
          hasMore = data['result']['consultants'].length == 50;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        throw Exception('Failed to fetch downline data');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print(e.toString());
    }
  }

  Future<void> _fetchMoreData() async {
    await _fetchDownlineData();
  }

  Future<void> _markConsultant(Map<String, dynamic> consultant) async {
    final response = await http.post(
      Uri.parse('https://mdcapp.gprlive.com/risingstars_api.php'),
      body: {
        'umca': mcaNumber!,
        'mca': consultant['mcano'].toString(),
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        consultant['marked'] = true;
      });
      print('Data Requested to Server: ${json.encode({
        'umca': mcaNumber,
        'mca': consultant['mcano'],
      })}');
    } else {
      throw Exception('Failed to mark consultant');
    }
  }

  List<String> fetchedMcaNumbers = [];

  Future<void> fetchData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? mcaNumber = prefs.getString('mcaNumber');

      String apiUrl = 'https://mdcapp.gprlive.com/api.php?action=risingstars_list';

      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Cookie': 'mdc_mca=$mcaNumber',
      };

      var response = await http.get(Uri.parse(apiUrl), headers: headers);

      if (response.statusCode == 200) {
        List<dynamic> responseData = json.decode(response.body);
        List<String> mcaNumbers = responseData.map((user) => user['mca'].toString()).toList();

        setState(() {
          users = responseData;
          fetchedMcaNumbers = mcaNumbers;
        });
        print('Response Data: $users');
        print('MCA Numbers: $mcaNumbers');
      } else {
        print('Failed to fetch data');
      }
    } catch (e) {
      print('Error: $e');
    }
  }



  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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
                    color: Colors.black.withOpacity(0.30),
                    offset: Offset(0, 1.5),
                    blurRadius: 0,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, // Align children to the left
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context); // Go back to the previous page
                        },
                        child: Row(
                          children: [
                            Icon(
                              Icons.arrow_back_ios,
                              color: Color(0xFF0396FE),
                              size: 20.0,
                            ),
                            Text(
                              'Back',
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
                  Padding(
                    padding: EdgeInsets.fromLTRB(16.0, 8.0, 0, 0.0), // Padding top and bottom
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'My Network',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ), // Add space here
                  if (users.isNotEmpty) // Add this condition to render the SingleChildScrollView only when users are not empty
                    Align(
                      alignment: Alignment.topLeft, // Align content to the left
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            ...users.take(3).map((user) {
                              String initials = '';
                              List<String> nameParts = user['name'].toString().split(' ');
                              for (String part in nameParts) {
                                initials += part[0];
                              }
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Container(
                                      width: 60,
                                      height: 60,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.blue,
                                      ),
                                      child: Center(
                                        child: Text(
                                          initials.toUpperCase(),
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      '${user['name'].toString().length > 5 ? user['name'].toString().substring(0, 5) + '...' : user['name']}',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                            SizedBox(width: 10), // Adjust spacing between data and "See All" link
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => RisingStarsPage()),
                                );
                              },
                              child: Text(
                                'See All',
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(height: 1.0),
      Expanded(
        child: NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification scrollInfo) {
            if (!isLoading && scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
              _fetchMoreData();
            }
            return true;
          },
          child: ListView.builder(
            controller: _scrollController,
            itemCount: consultants.length + (isLoading || hasMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == consultants.length) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              final consultant = consultants[index];
              bool isMarked = consultant['marked'] == true || fetchedMcaNumbers.contains(consultant['mcano'].toString());

              String name = consultant['name'] ?? '';
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
                            // Row for Circular Avatar and Consultant Info
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
                                          '${consultant['name'] ?? ''}',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black, // Use blue color
                                          ),
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          '${consultant['paid_title'] ?? ''}',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500, // You can choose a number between 100 and 900
                                            color: Colors.grey, // Use blue color
                                          ),
                                        ),
                                        Text(
                                          '${consultant['valid_titl'] ?? ''}',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500, // You can choose a number between 100 and 900
                                            color: Colors.grey, // Use blue color
                                          ),
                                        ),
                                        Text(
                                          'MCA: ${consultant['mcano'] ?? ''}',
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

                            SizedBox(height: 2.0), // Space between info and icons

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
                                          style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(height: 2), // Optional: space between title and value
                                        Text(
                                          '${consultant['loyalty_month'] ?? 0}', // Display 0 if the value is null
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
                                          if (consultant['mobileno'] != null) {
                                            _callContact(consultant['mobileno']);
                                          }
                                        },
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.message),
                                        color: Colors.lightBlue,
                                        onPressed: () {
                                          if (consultant['mobileno'] != null) {
                                            _sendSms(consultant['mobileno']);
                                          }
                                        },
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.messenger_outline),
                                        color: Colors.lightBlue,
                                        onPressed: () {
                                          if (consultant['mobileno'] != null) {
                                            _sendWhatsAppMessage(consultant['mobileno']);
                                          }
                                        },
                                      ),
                                      Spacer(), // Spacer pushes the star icon to the far right
                                      Spacer(), // Spacer pushes the star icon to the far right
                                      // Star Button for Marking
                                      GestureDetector(
                                        onTap: () async {
                                          await _markConsultant(consultant);
                                        },
                                        child: Container(
                                          width: 40,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            color: isMarked ? Color(0xFFFFA500) : Colors.grey,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Center(
                                            child: Icon(
                                              Icons.star,
                                              color: isMarked ? Colors.white : Colors.white,
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
        ),
      ),

          ],
        ),
      ),
    );
  }
}

