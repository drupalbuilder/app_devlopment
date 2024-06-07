import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:t2t1/firsttime/stepper.dart';

class Welcomescreen extends StatefulWidget {
  @override
  _WelcomescreenState createState() => _WelcomescreenState();
}

class _WelcomescreenState extends State<Welcomescreen> {
  String title = '';
  String description = '';
  String imageUrl = '';
  bool isDataLoaded = false; // Track if data is loaded

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final response = await http.get(Uri.parse('https://mdash.gprlive.com/api/resources/53'));
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        setState(() {
          title = jsonData['title'] ?? '';
          description = _removeHtmlTags(jsonData['description'] ?? '');
          imageUrl = 'https://mdash.gprlive.com/uploads/images/resources/${jsonData['image']}';
          isDataLoaded = true; // Mark data as loaded
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  String _removeHtmlTags(String htmlString) {
    return htmlString.replaceAll(RegExp(r'<[^>]*>'), '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Loading Animation
          if (!isDataLoaded)
            Center(
              child: LoadingAnimationWidget.waveDots(
                color: Colors.lightBlueAccent,
                size: 100,
              ),
            ),
          // Actual Content
          if (isDataLoaded)
            SafeArea(
              child: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.all(0.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      imageUrl.isNotEmpty
                          ? Padding(
                        padding: EdgeInsets.only(left: 0.0),
                        child: Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                        ),
                      )
                          : SizedBox.shrink(),
                      SizedBox(height: 20.0),
                      Padding(
                        padding: EdgeInsets.only(left: 20.0),
                        child: Text(
                          title,
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w900,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Padding(
                        padding: EdgeInsets.only(left: 20.0),
                        child: Text(
                          description,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 16,
                            color: const Color(0xff535353),
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      SizedBox(height: 20.0),
                      Padding(
                        padding: EdgeInsets.only(left: 20.0),
                        child: Image.network(
                          'https://rtfapi.modicare.com/img/Signature@2x.png',
                          width: 220,
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Padding(
                        padding: EdgeInsets.only(left: 20.0),
                        child: Text(
                          'Mr. Samir K. Modi\nFounder & Managing Director',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 16,
                            color: const Color(0xff535353),
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      SizedBox(height: 30.0),
                      Padding(
                        padding: EdgeInsets.only(left: 20.0, right: 20.0),
                        child: Center(
                          child: SizedBox(
                            width: 130.0,
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xff12D8FA),
                                    Color(0xff1FA2FF),
                                    Color(0xff1FA2FF),
                                  ],
                                  begin: Alignment.centerRight,
                                  end: Alignment.centerLeft,
                                ),
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              child: TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => CustomStepperPage(),
                                    ),
                                  );
                                },
                                child: Text(
                                  'Continue',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20.0),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: Welcomescreen(),
  ));
}
