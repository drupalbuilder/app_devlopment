import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
      final response = await http.get(Uri.parse('https://mdash.gprlive.com/api/faq'));

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
        errorMessage = 'Failed to get data. Please check your internet connection and try again.';
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
                    color: Colors.black.withOpacity(0.43),
                    offset: Offset(0, 1),
                    blurRadius: 2,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back,
                        color: Color.fromARGB(255, 40, 40, 40)),
                    onPressed: () {
                      Navigator.pop(context); // Navigate back when pressed
                    },
                  ),
                  Text(
                    'FAQ',
                    style: TextStyle(
                      color: Color.fromARGB(255, 40, 40, 40),
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
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
                  ? Center(child: CircularProgressIndicator())
                  : errorMessage.isNotEmpty
                  ? Center(child: Text(errorMessage))
                  : ListView.builder(
                itemCount: filteredFaqList.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      ExpansionTile(
                        title: Text(filteredFaqList[index]
                        ['question'] ?? ''),
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(filteredFaqList[index]
                            ['answer'] ??
                                ''),
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




