import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ReportScreen extends StatefulWidget {
  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  late String token;
  dynamic downlineData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchTokenAndData();
  }

  Future<void> fetchTokenAndData() async {
    final mca = '11000000'; // Your MCA number
    final apiKey = 'RFE5GE-9YWNGQ-UYT9T6-KNR1F2';
    final tokenUrl = 'https://api.modicare.com/api/sr/token/app/$mca';
    final downlineUrl = 'https://api.modicare.com/api/app/consultant/downline/list';

    try {
      // Fetch token
      final tokenResponse = await http.post(
        Uri.parse(tokenUrl),
        headers: {'x-api-key': apiKey},
      );

      print('Token Response Status Code: ${tokenResponse.statusCode}');
      print('Token Response Body: ${tokenResponse.body}');

      if (tokenResponse.statusCode == 200) {
        final tokenData = jsonDecode(tokenResponse.body);
        if (tokenData.containsKey('token')) {
          token = tokenData['token'];
          print('Fetched Token: $token'); // Print the fetched token

          // Fetch downline data
          final downlineResponse = await http.post(
            Uri.parse(downlineUrl),
            headers: {
              'Content-Type': 'application/json',
              'x-auth-token': token,
            },
            body: jsonEncode({
              'downline': '11000000',
              'page_no': '1',
              'page_size': '50',
              'type': '1',
            }),
          );

          print('Downline Response Status Code: ${downlineResponse.statusCode}');
          print('Downline Response Body: ${downlineResponse.body}');

          if (downlineResponse.statusCode == 200 && downlineResponse.body.isNotEmpty) {
            final downlineDataJson = jsonDecode(downlineResponse.body);
            if (downlineDataJson.containsKey('consultants')) {
              setState(() {
                downlineData = downlineDataJson['consultants'];
                isLoading = false;
              });
              return;
            } else {
              print('Error: Invalid JSON format in downline data');
            }
          } else {
            print('Error: Failed to fetch downline data, status code ${downlineResponse.statusCode}');
          }
        } else {
          print('Error: Token not found in API response');
        }
      } else {
        print('Error: Failed to fetch token, status code ${tokenResponse.statusCode}');
      }
    } catch (e) {
      print('Error during API request or JSON parsing: $e');
    }

    // Handle error or data not found
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Report Screen'),
      ),
      body: Center(
        child: isLoading
            ? CircularProgressIndicator()
            : downlineData != null
            ? ListView.builder(
          itemCount: downlineData.length,
          itemBuilder: (context, index) {
            final item = downlineData[index];
            return ListTile(
              title: Text(item['name'] ?? ''),
              subtitle: Text(item['email'] ?? ''),
            );
          },
        )
            : Text('Error fetching data.'),
      ),
    );
  }
}
