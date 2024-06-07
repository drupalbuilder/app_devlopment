import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:loading_animation_widget/loading_animation_widget.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: InfoScreen(),
    );
  }
}

class InfoScreen extends StatefulWidget {
  @override
  _InfoScreenState createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  List<Map<String, String>> faqList = [];
  List<Map<String, String>> filteredFaqList = [];
  bool isLoading = true;
  String errorMessage = '';
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    fetchFAQ();
  }

  Future<void> fetchFAQ() async {
    setState(() {
      isLoading = true; // Show loading indicator while fetching data
      errorMessage = ''; // Initialize errorMessage with an empty string
    });

    try {
      final response =
      await http.get(Uri.parse('https://mdash.gprlive.com/api/faq'));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          faqList = data.map((item) => {
            'question': item['question'].toString(), // Convert to string
            'answer': removeHtmlTags(item['answer'].toString()), // Remove HTML tags
          }).toList();
          filteredFaqList = List.from(faqList); // Initialize filtered list with all FAQs
        });
      } else {
        throw Exception(
            'Failed to load FAQ. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        errorMessage =
        'Failed to get data. Please check your internet connection and try again.';
        isLoading = false;
      });
    } finally {
      setState(() {
        isLoading = false; // Hide loading indicator regardless of success or failure
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
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
                  SizedBox(height: 10.0), // Add space here
                  Padding(
                    padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),// Padding top and bottom
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Faqs',
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
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24.0),
                    borderSide: BorderSide(color: Colors.blue), // Change border color if needed
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                ),
                onChanged: (String value) {
                  // Handle search query here
                  setState(() {
                    searchQuery = value.toLowerCase();
                    filteredFaqList = faqList.where((faq) {
                      return faq['question']!
                          .toLowerCase()
                          .contains(searchQuery) ||
                          faq['answer']!.toLowerCase().contains(searchQuery);
                    }).toList();
                  });
                },
              ),
            ),
            Expanded(
              child: isLoading
                  ? Center(
                child: LoadingAnimationWidget.waveDots(
                  color: Colors.lightBlueAccent, // Customize color if needed
                  size: 100, // Adjust size as needed
                ),
              )
                  : errorMessage.isNotEmpty
                  ? Center(child: Text(errorMessage))
                  : ListView.builder(
                itemCount: filteredFaqList.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      ExpansionTile(
                        title: Text(
                          filteredFaqList[index]['question'] ?? '',
                          style: TextStyle(
                            fontSize: 16, // Question font size
                            color: Colors.black, // Question color
                            fontWeight: FontWeight.bold, // Question font weight
                          ),
                        ),
                        children: <Widget>[
                          Container(
                            color: Color(0xfff4f4f4), // Answer background color
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                filteredFaqList[index]['answer'] ?? '',
                                style: TextStyle(
                                  fontSize: 14, // Answer font size
                                  color: Color(0xff535353), // Answer color
                                  fontWeight: FontWeight.bold, // Answer font weight
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Divider(
                        color: Colors.grey,
                        height: 1,
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String removeHtmlTags(String htmlText) {
    RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);
    return htmlText.replaceAll(exp, '');
  }
}
