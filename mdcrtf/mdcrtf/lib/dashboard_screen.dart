import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:t2t1/MyPospect.dart';
import 'package:t2t1/Mynetwork.dart';
import ' LoyaltyReport.dart';
import 'BusinessReport.dart';
import 'infoscreen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';



class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int incomeValue = 0;
  String? _selectedMonth;

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
                  padding: EdgeInsets.all(0.0), // Add padding to the chart
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 1.0),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: charts.BarChart(
                    _createSampleData(),
                    animate: true,
                    primaryMeasureAxis: const charts.NumericAxisSpec(
                      renderSpec: charts.NoneRenderSpec(),
                    ),
                    behaviors: [
                      charts.SelectNearest(eventTrigger: charts.SelectionTrigger.tapAndDrag),
                    ],
                    selectionModels: [
                      charts.SelectionModelConfig(
                        type: charts.SelectionModelType.info,
                        changedListener: (model) {
                          if (model.selectedDatum.isNotEmpty && model.selectedDatum.first.datum is OrdinalSales) {
                            final selectedDatum = model.selectedDatum.first.datum as OrdinalSales;
                            if (selectedDatum.month != 'Target') {
                              setState(() {
                                _selectedMonth = selectedDatum.month;
                                incomeValue = selectedDatum.sales;
                              });
                            }
                          }
                        },
                      ),
                    ],
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
                        color: const Color(0xff85e250),
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
                      '₹ ${_getTargetValue()}',
                      style: const TextStyle(
                        fontSize: 24,
                        color: const Color(0xff535353),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 20),
                    Text(
                      '₹ $incomeValue',
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
                      foregroundColor: Color(0xFF333333),
                      backgroundColor: Color(0xFFFDFDFD),
                      side: BorderSide(width: 1.0, color: Color(0xFF0099FF)),
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
                  padding: const EdgeInsets.only(left: 8.0), // Adjust the padding value as needed
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xfff4f4f4), // Set the background color here
                      borderRadius: BorderRadius.horizontal(
                        left: Radius.circular(20.0), // Set the radius for the left side
                        right: Radius.circular(20.0), // Set the radius for the right side
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
                          foregroundColor: Color(0xFF333333),
                          backgroundColor: Color(0xFFFDFDFD),
                          side: BorderSide(width: 1.0, color: Color(0xFF0099FF)),
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
                          foregroundColor: Color(0xFF333333),
                          backgroundColor: Color(0xFFFDFDFD),
                          side: BorderSide(width: 1.0, color: Color(0xFF0099FF)),
                        ),
                        child: Text(
                          'Loyalty report',
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
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xff0099ff),// Blue background color
                      ),
                      padding: const EdgeInsets.all(4), // Adjust padding as needed
                      child: Icon(
                        Icons.add,
                        color: Colors.white, // White icon color
                        size: 20, // Adjust icon size as needed
                      ),
                    ),
                    SizedBox(width: 8), // Adjust the width as needed for spacing
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
                          foregroundColor: Color(0xFF333333),
                          backgroundColor: Color(0xFFFDFDFD),
                          side: BorderSide(width: 1.0, color: Color(0xFF0099FF)),
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
                          foregroundColor: Color(0xFF333333),
                          backgroundColor: Color(0xFFFFFFFF),
                          side: BorderSide(width: 1.0, color: Color(0xFF0099FF)),
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
                padding: EdgeInsets.symmetric(horizontal: 16.0), // Adjust the value as needed
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

              SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCard() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Container(
        width: 150,
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
          ],
        ),
      ),
    );
  }

  List<charts.Series<OrdinalSales, String>> _createSampleData() {
    final data = [
      OrdinalSales('Target', 10000),
      OrdinalSales('Oct', 5000),
      OrdinalSales('Nov', 1000),
      OrdinalSales('Dec', 1600),
      OrdinalSales('Jan', 1800),
      OrdinalSales('Feb', 2000),
      OrdinalSales('Mar', 1000),
    ];

    return [
      charts.Series<OrdinalSales, String>(
        id: 'Sales',
        colorFn: (OrdinalSales sales, _) {
          if (sales.month == _selectedMonth) {
            return charts.Color.fromHex(code: '#85e250');
          } else if (sales.month == 'Target') {
            return charts.Color.fromHex(code: '#fdcd11');
          } else {
            return charts.Color(r: 37, g: 150, b: 190);
          }
        },
        domainFn: (OrdinalSales sales, _) => sales.month,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        data: data,
      ),
    ];
  }

  String _getTargetValue() {
    final targetData = _createSampleData().first.data.firstWhere((element) => element.month == 'Target', orElse: () => OrdinalSales('Target', 0));
    return '${targetData.sales}';
  }
}

Widget videoItem(BuildContext context, String title, String videoUrl) {
  return GestureDetector(
    onTap: () {
      _playYoutubeVideo(context, videoUrl);
    },
    child: SizedBox(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10.0, 14.0, 0, 0), // Padding from left, top, right, and bottom
        child: SizedBox(
          width: 160,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Image.network(
                    'https://img.youtube.com/vi/${videoUrl.split('/').last.split('?').first}/0.jpg',
                    width: 140,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(0),
                          bottomRight: Radius.circular(8),
                        ),
                      ),
                      child: const Icon(
                        Icons.play_arrow,
                        color: Colors.white,
                        size: 20,
                      ),
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
      barrierDismissible: true, // allow dismissing the dialog by clicking outside
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
class OrdinalSales {
  final String month;
  final int sales;

  OrdinalSales(this.month, this.sales);
}

void main() {
  runApp(const MaterialApp(
    home: DashboardScreen(),
  ));
}
