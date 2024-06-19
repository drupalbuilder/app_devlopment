import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(ReportScreen());
}

class ReportScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'API Requests',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}


class MyHomePage extends StatelessWidget {
  final TextEditingController mcaController = TextEditingController();

  Future<void> postData() async {
    try {
      String apiUrl = 'https://mdcapp.gprlive.com/.call/?api=risinga';
      var response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: '{"mca": "${mcaController.text}"}',
      );

      if (response.statusCode == 200) {
        print('Data added successfully');
      } else {
        print('Failed to add data');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('API Requests'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: mcaController,
              decoration: InputDecoration(
                labelText: 'Enter MCA',
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                postData();
              },
              child: Text('Add Data'),
            ),
          ],
        ),
      ),
    );
  }
}
