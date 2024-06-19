import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:t2t1/MyPospect.dart';
import 'package:t2t1/Mynetwork.dart';
import 'LoyaltyReport.dart';
import 'BusinessReport.dart';
import 'infoscreen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'listRstar.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String mcaNumber = '';
  String targetValue = '';
  String selectedValueText = '';
  bool isLoading = true;
  List<dynamic> dashboardData = [];
  int? selectedIndex; // Add a variable to store the selected index

  @override
  void initState() {
    super.initState();
    _fetchDashboardData();
    _fetchMcaNumber();
  }

  Future<void> _fetchDashboardData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? mcaNumber = prefs.getString('mcaNumber');

    if (mcaNumber != null) {
      String url = 'https://report.modicare.com/api/report/np/business/web';
      Map<String, String> headers = {"Content-Type": "application/json"};
      String body = jsonEncode({
        "mcano": mcaNumber,
        "dated": "${DateTime.now().year}-${DateTime.now().month}-01"
      });

      try {
        final response = await http.post(Uri.parse(url), headers: headers, body: body);

        if (response.statusCode == 200) {
          dynamic jsonData = jsonDecode(response.body);
          if (jsonData['result'] != null && jsonData['result'] is List) {
            setState(() {
              dashboardData = jsonData['result'];
              isLoading = false;
            });
          } else {
            setState(() {
              isLoading = false;
            });
          }
        } else {
          setState(() {
            isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Failed to fetch dashboard data.'),
            ),
          );
        }
      } catch (error) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('An error occurred: $error'),
          ),
        );
      }
    } else {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No MCA number found.'),
        ),
      );
    }
  }

  Future<void> _fetchUserData() async {
    String userApiUrl = 'https://mdash.gprlive.com/api/users/$mcaNumber';

    try {
      http.Response response = await http.get(Uri.parse(userApiUrl));

      if (response.statusCode == 200) {
        Map<String, dynamic> userData = jsonDecode(response.body);
        int target = userData['target'] ?? 0;

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setInt('targetValue', target);

        setState(() {
          targetValue = target.toString();
        });
      } else {
        throw Exception('Failed to load user data');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
    }
  }

  Future<List<charts.Series<OrdinalSales, String>>> _createChartData() async {
    List<OrdinalSales> data = [];

    SharedPreferences prefs;
    try {
      prefs = await SharedPreferences.getInstance();
    } catch (e) {
      print('Error initializing SharedPreferences: $e');
      return [];
    }

    int targetValue = prefs.getInt('targetValue') ?? 0;

    for (var item in dashboardData) {
      String month = item['BV Month'];
      double grossIncome = double.tryParse(item['Gross']?.replaceAll('₹ ', '') ?? '0.00') ?? 0.0;
      data.add(OrdinalSales(month, grossIncome));
    }

    data.insert(0, OrdinalSales('Target', targetValue.toDouble()));

    if (data.length > 1) {
      selectedValueText = data[1].sales.toString();
    }

    return [
      charts.Series<OrdinalSales, String>(
        id: 'Sales',
        colorFn: (OrdinalSales sales, int? index) {
          if (sales.month == 'Target') {
            return charts.Color.fromHex(code: '#fbcc11');
          } else if (index == selectedIndex) {
            return charts.ColorUtil.fromDartColor(Colors.green); // Change to red if selected
          } else {
            return charts.Color.fromHex(code: '#25CDD7');
          }
        },
        domainFn: (OrdinalSales sales, _) => sales.month,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        data: data,
      ),
    ];
  }

  Future<void> _fetchMcaNumber() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      mcaNumber = prefs.getString('mcaNumber')!;
    });

    _fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Dashboard',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => InfoScreen(),
                          ),
                        );
                      },
                      child: Image.network(
                        'https://rtfapi.modicare.com/assets/images/help.png?act=1',
                        width: 24,
                        height: 24,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  height: 320,
                  padding: EdgeInsets.all(0.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 1.0),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: FutureBuilder<List<charts.Series<dynamic, String>>>(
                    future: _createChartData(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return charts.BarChart(
                          snapshot.data!,
                          animate: true,
                          primaryMeasureAxis: const charts.NumericAxisSpec(
                            renderSpec: charts.NoneRenderSpec(),
                          ),
                          behaviors: [
                            charts.SelectNearest(
                              eventTrigger: charts.SelectionTrigger.tapAndDrag,
                            ),
                          ],
                          selectionModels: [
                            charts.SelectionModelConfig(
                              type: charts.SelectionModelType.info,
                              changedListener: (charts.SelectionModel<String> model) {
                                if (model.hasDatumSelection) {
                                  final selectedDatum = model.selectedDatum.first;
                                  final selectedValue = selectedDatum.datum.sales.toString();
                                  final selectedMonth = selectedDatum.datum.month;
                                  if (selectedMonth != 'Target') {
                                    setState(() {
                                      selectedValueText = selectedValue;
                                      selectedIndex = selectedDatum.index; // Update selected index
                                    });
                                  }
                                }
                              },
                            ),
                          ],
                        );
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text('Error: ${snapshot.error}'),
                        );
                      }
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  ),
                ),
              ),
              SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    Container(
                      width: 15,
                      height: 15,
                      decoration: BoxDecoration(
                        color: const Color(0xfffdcd11),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                    SizedBox(width: 5),
                    const Text(
                      'Target',
                      style: TextStyle(
                        fontSize: 16,
                        color: const Color(0xff535353),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 40),
                    Container(
                      width: 15,
                      height: 15,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                    SizedBox(width: 5),
                    const Text(
                      'Income',
                      style: TextStyle(
                        fontSize: 16,
                        color: const Color(0xff535353),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    Text(
                      '₹$targetValue',
                      style: const TextStyle(
                        fontSize: 24,
                        color: const Color(0xff535353),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 40),
                    Text(
                      '₹$selectedValueText',
                      style: const TextStyle(
                        fontSize: 24,
                        color: const Color(0xff535353),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: ElevatedButton(
                    onPressed: () {
                      // Add your button onPressed logic here
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black, backgroundColor: Colors.white, // Text color
                      side: BorderSide(color: Colors.blue), // Border color
                      elevation: 0, // Remove shadow
                    ),
                    child: Text(
                      'Income Simulator',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Action Plan Vs Performance',
                  style: TextStyle(
                    fontSize: 16,
                    color: const Color(0xff535353),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                  child: Row(
                    children: [
                      buildCard(),
                      buildCard(),
                      buildCard(),
                      buildCard(),
                      buildCard(),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10), // Added spacing
              Container(
                height: 140,
                color: Colors.white,
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'My Business (Current Month)',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Title',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16.0,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    Text(
                      'Paid as: Consultant',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16.0,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    Text(
                      'Valid: Director',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16.0,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  // Adjust the padding value as needed
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xfff4f4f4),
                      // Set the background color here
                      borderRadius: BorderRadius.horizontal(
                        left: Radius.circular(20.0),
                        // Set the radius for the left side
                        right: Radius.circular(
                            20.0), // Set the radius for the right side
                      ),
                    ),
                    child: Row(
                      children: [
                        buildCard(),
                        buildCard(),
                        buildCard(),
                        buildCard(),
                        buildCard(),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BusinessReport(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.black, backgroundColor: Colors.white, // Text color
                          side: BorderSide(color: Colors.blue), // Border color
                          elevation: 0, // Remove shadow
                        ),
                        child: Text(
                          'Business report',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoyaltyReport(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.black, backgroundColor: Colors.white, // Text color
                          side: BorderSide(color: Colors.blue), // Border color
                          elevation: 0, // Remove shadow
                        ),
                        child: Text(
                          'Loyalty Report',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'My Rising Stars',
                  style: TextStyle(
                    fontSize: 16,
                    color: const Color(0xff535353),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: GestureDetector(
                  onTap: () {
                    // Navigate to TestScreen here
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RisingStarsPage()),
                    );
                  },
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xff0099ff), // Blue background color
                        ),
                        padding: const EdgeInsets.all(4),
                        child: Icon(
                          Icons.add,
                          color: Colors.white, // White icon color
                          size: 20, // Adjust icon size as needed
                        ),
                      ),
                      SizedBox(width: 8),
                      Text(
                        'add new',
                        style: TextStyle(
                          fontSize: 16,
                          color: const Color(0xff0099ff),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MyNetwork(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.black, backgroundColor: Colors.white, // Text color
                          side: BorderSide(color: Colors.blue), // Border color
                          elevation: 0, // Remove shadow
                        ),
                        child: Text(
                          'My Network',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MyProspect(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.black, backgroundColor: Colors.white, // Text color
                          side: BorderSide(color: Colors.blue), // Border color
                          elevation: 0, // Remove shadow
                        ),
                        child: Text(
                          'My Prospect',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Academy',
                  style: TextStyle(
                    fontSize: 16,
                    color: const Color(0xff535353),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 10),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                // Adjust the value as needed
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 1.0),
                    borderRadius: BorderRadius.circular(0.0),
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 160,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            videoItem(
                              context,
                              'Importance of sharing the plan',
                              'https://www.youtube.com/embed/EXSTxzPhQ30?showinfo=0&related=0&enablejsapi=1&autoplay=1&rel=0',
                            ),
                            videoItem(
                              context,
                              '3 tips for the first home meeting',
                              'https://www.youtube.com/embed/JGXJ4gLfVrc?showinfo=0&related=0&enablejsapi=1&autoplay=1&rel=0',
                            ),
                            videoItem(
                              context,
                              'Direct Selling industry for small & medium entrepreneurs',
                              'https://www.youtube.com/embed/8gK9Ai2hTyc?showinfo=0&related=0&enablejsapi=1&autoplay=1&rel=0',
                            ),
                            // Add more videos as needed
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 100.0),
            ],
          ),
        ),
      ),
    );

  }


  Widget buildCard() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 14),
      child: Container(
        width: 180,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.8),
              spreadRadius: 1,
              blurRadius: 1,
              offset: Offset(2, 1),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              child: Image.network(
                'https://rtfapi.modicare.com/img/Money-bag.png',
                width: 50,
                height: 50,
              ),
            ),
            Text(
              'Next Level\nGPV Required',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '60',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20.0),

          ],
        ),
      ),
    );
  }


  Widget videoItem(BuildContext context, String title, String videoUrl) {
    return GestureDetector(
      onTap: () {
        _playYoutubeVideo(context, videoUrl);
      },
      child: SizedBox(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10.0, 14.0, 0, 0),
          // Padding from left, top, right, and bottom
          child: SizedBox(
            width: 160,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.network(
                      'https://img.youtube.com/vi/${videoUrl
                          .split('/')
                          .last
                          .split('?')
                          .first}/0.jpg',
                      width: 140,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.play_arrow,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.0),
                SizedBox(
                  width: 160, // Adjust width as needed
                  child: Text(
                    title.length > 25 ? '${title.substring(0, 22)}...' : title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }



  void _playYoutubeVideo(BuildContext context, String? videoUrl) {
    if (videoUrl != null) {
      // Save the current screen orientation

      // Lock the screen orientation to portrait
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);

      showDialog(
        context: context,
        barrierDismissible: true,
        // allow dismissing the dialog by clicking outside
        builder: (BuildContext context) {
          return AlertDialog(
            contentPadding: EdgeInsets.zero,
            content: SizedBox(
              width: double.maxFinite, // Set the width as needed
              height: 400, // Set the height as needed
              child: YoutubePlayer(
                controller: YoutubePlayerController(
                  initialVideoId: YoutubePlayer.convertUrlToId(videoUrl) ?? '',
                  flags: const YoutubePlayerFlags(
                    autoPlay: true,
                    mute: false,
                  ),
                ),
                showVideoProgressIndicator: true,
                onReady: () {
                  // Perform any additional setup here
                },
              ),
            ),
          );
        },
      ).then((value) {
        // Restore the original screen orientation after the dialog is dismissed
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
        ]);
      });
    } else {
      // Handle the case where videoUrl is null, if needed
      if (kDebugMode) {
        print('Video URL is null');
      }
    }
  }

  void main() {
    runApp(const MaterialApp(
      home: DashboardScreen(),
    ));
  }
}




class OrdinalSales {
  final String month;
  final double sales;

  OrdinalSales(this.month, this.sales);
}