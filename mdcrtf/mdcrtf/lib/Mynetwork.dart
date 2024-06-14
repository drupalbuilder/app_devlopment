import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

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

    final response = await http.post(
      Uri.parse('https://api.modicare.com/api/app/consultant/downline/list'),
      headers: {
        'Content-Type': 'application/json',
        'x-auth-token': token,
      },
      body: json.encode({
        'downline': '0',
        'page_no': '$pageNo',
        'page_size': '50',
        'type': '1',
      }),
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
  }

  Future<void> _fetchMoreData() async {
    await _fetchDownlineData();
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
                            ), // Adjust the spacing between the icon and text
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
                  SizedBox(height: 0.0), // Add space here
                  Padding(
                    padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),// Padding top and bottom
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'My Network',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight
                                .w900,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.0), // Add space here
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 255, 255, 255),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.30),
                    offset: Offset(0, 2),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: Column(
                children: [
                  SizedBox(height: 0.0), // Add space here
                  Padding(
                    padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),// Padding top and bottom
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Your rising stars ',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight
                                .w900,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10.0),
            Expanded(
              child: NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification scrollInfo) {
                  if (!isLoading &&
                      scrollInfo.metrics.pixels ==
                          scrollInfo.metrics.maxScrollExtent) {
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
                    return Card(
                      margin: EdgeInsets.all(10.0),
                      child: Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              consultant['name'] ?? '', // Handling null case
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 5.0),
                            Text('MCA No: ${consultant['mcano'] ?? ''}'), // Handling null case
                            SizedBox(height: 5.0),
                            Text('Valid Title: ${consultant['valid_titl'] ?? ''}'), // Handling null case
                            // Add more data fields here as needed
                          ],
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


