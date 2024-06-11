import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ReportScreen extends StatefulWidget {
  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  String _mcaNumber = ''; // To display on the screen
  String _apiResponse = ''; // To store and print the API response

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String mcaNumber = prefs.getString('mcaNumber') ?? '';

    print('MCA Number from SharedPreferences: $mcaNumber'); // Debugging print

    if (mcaNumber.isEmpty) {
      setState(() {
        _mcaNumber = 'No MCA Number stored'; // Update state to show message
      });
      return; // Exit function if no MCA number is stored
    }

    // Your API endpoint URL
    String apiUrl = "https://report.modicare.com/api/report/loyalty/qualifier";

    // Construct the request body
    Map<String, String> body = {
      "mcano": mcaNumber,
      "downline": mcaNumber
    };

    // Define headers for the API request
    Map<String, String> headers = {
      "Content-Type": "application/json",
    };

    try {
      // Make the API call
      var response = await http.post(Uri.parse(apiUrl), headers: headers, body: jsonEncode(body));

      if (response.statusCode == 200) {
        // If the API call is successful, update the state with the API response and the MCA number
        setState(() {
          _apiResponse = response.body;
          _mcaNumber = mcaNumber;
        });
        print('API Response: ${response.body}'); // Print API response
      } else {
        // Handle API error response
        print('Error response from API: ${response.statusCode} - ${response.body}');
        setState(() {
          _apiResponse = 'Error response from API: ${response.statusCode}';
        });
      }
    } catch (e) {
      // Handle API call exception
      print('Error making API call: $e');
      setState(() {
        _apiResponse = 'Error making API call: $e';
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fetch Data Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'MCA Number:',
              style: TextStyle(fontSize: 20),
            ),
            Text(
              _mcaNumber,
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'API Response:',
              style: TextStyle(fontSize: 20),
            ),
            Text(
              _apiResponse,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ReportScreen(),
  ));
}
