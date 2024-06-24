import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'listRstar.dart';


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
        print('Response Data: $users');
      } else {
        // Request failed, handle error
      }
    } catch (e) {
      // Handle exceptions
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
            SizedBox(height: 10.0),
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
                    return GestureDetector(
                      onTap: () async {
                        await _markConsultant(consultant);
                      },
                      child: Card(
                        margin: EdgeInsets.all(10.0),
                        child: Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Text(
                                      consultant['name'] ?? '',
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                    ),
                                  ),
                                  if (consultant['marked'] == true)
                                    Icon(
                                      Icons.star,
                                      color: Colors.lightBlueAccent,
                                    ),
                                ],
                              ),
                              SizedBox(height: 5.0),
                              Text('MCA No: ${consultant['mcano'] ?? ''}'),
                              SizedBox(height: 5.0),
                              Text('Valid Title: ${consultant['valid_titl'] ?? ''}'),
                            ],
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

