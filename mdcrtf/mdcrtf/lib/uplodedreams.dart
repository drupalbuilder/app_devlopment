import 'package:flutter/material.dart';
import 'selectdreams.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:loading_animation_widget/loading_animation_widget.dart';


void main() {
  runApp(MaterialApp(
    home: UploadDreams(),
  ));
}

class UploadDreams extends StatefulWidget {
  @override
  _UploadDreamsState createState() => _UploadDreamsState();
}

class _UploadDreamsState extends State<UploadDreams> {
  List<String> cardTitles = [];
  List<String> cardImages = [];
  List<bool> isCheckedList = [];
  bool isDataLoaded = false;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    List<String> apiEndpoints = [
      'https://mdash.gprlive.com/api/dreams/2',
      'https://mdash.gprlive.com/api/dreams/3',
      'https://mdash.gprlive.com/api/dreams/66',
      'https://mdash.gprlive.com/api/dreams/60',
      'https://mdash.gprlive.com/api/dreams/126',
    ];

    for (String endpoint in apiEndpoints) {
      try {
        var response = await http.get(Uri.parse(endpoint));
        if (response.statusCode == 200) {
          Map<String, dynamic> data = json.decode(response.body);
          setState(() {
            cardTitles.add(data['name']);
            cardImages.add("https://mdash.gprlive.com/${data['image']}");
            isCheckedList.add(false);
          });
        } else {
          print('Failed to load data from $endpoint');
        }
      } catch (e) {
        print('Error: $e');
      }
    }
    setState(() {
      isDataLoaded = true; // Data is loaded, hide the loading animation
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isDataLoaded
          ? SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 16.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'ᐸ  Back',
                      style: TextStyle(
                        color: Color(0xFF0396FE),
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 16.0),
                  child: Text(
                    'Set your dream',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 26.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                GridView.builder(
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200.0,
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
                    childAspectRatio: MediaQuery.of(context).size.width < 600 ? 0.8 : 1.0,
                  ),
                  itemCount: cardTitles.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Stack(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 8.0),
                              child: Text(
                                cardTitles[index],
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(height: 8.0),
                            SizedBox(
                              width: 200, // Fixed width
                              height: 140, // Fixed height
                              child: Card(
                                margin: EdgeInsets.zero,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6.0),
                                  side: BorderSide(color: Color(0xFFe1e1e1), width: 1.0),
                                ),
                                elevation: 5.0,
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => SelectDreams(
                                          dreamId: index,
                                          dreamTitle: cardTitles[index],
                                        ),
                                      ),
                                    );
                                  },
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(6.0),
                                    child: Image.network(
                                      cardImages[index],
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Positioned(
                          bottom: 56,
                          left: MediaQuery.of(context).size.width < 600 ? 74 : 10,
                          child: Container(
                            width: 35,
                            height: 35,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isCheckedList[index] ? Color(0xFF0DB1E3) : Colors.grey,
                            ),
                            child: isCheckedList[index]
                                ? Icon(Icons.check, color: Colors.white)
                                : Icon(Icons.add, color: Colors.white),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      )
          : Center(
        child: LoadingAnimationWidget.waveDots(
          color: Colors.blue,
          size: 100,
        ),
      ),
    );
  }
}