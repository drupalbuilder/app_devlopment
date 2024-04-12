import 'package:flutter/material.dart';
import 'infoscreen.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';



class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int selectedMonthIndex = -1;

  @override
  Widget build(BuildContext context) {
    final List<ChartData> chartData = [
      ChartData('Target', 10000),
      ChartData('January', 8000),
      ChartData('February', 10000),
      ChartData('March', 7000),
      ChartData('April', 12000),
      ChartData('May', 9000),
    ];

    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: ListView(
            children: [
              Container(
                height: 750,
                margin: EdgeInsets.only(bottom: 20.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20.0),
                    bottomRight: Radius.circular(20.0),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.43),
                      offset: Offset(0, 1),
                      blurRadius: 2,
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20.0),
                        bottomRight: Radius.circular(20.0),
                      ),
                      child: Container(
                        color: Colors.white,
                        height: 650,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Dashboard',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => InfoScreen()),
                                  );
                                },
                                child: Image.network(
                                  'https://rtfapi.modicare.com/assets/images/help.png?act=1',
                                  width: 20,
                                  height: 20,
                                ),
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTapUp: (TapUpDetails details) {
                              RenderBox renderBox = context
                                  .findRenderObject() as RenderBox;
                              var localPosition = renderBox.globalToLocal(
                                  details.globalPosition);
                              int tappedIndex = ((localPosition.dx - 16.0) /
                                  (MediaQuery
                                      .of(context)
                                      .size
                                      .width - 32.0) * 5).round();

                              setState(() {
                                selectedMonthIndex = tappedIndex;
                              });
                            },
                            child: SizedBox(
                              height: 300,
                              width: double.infinity,
                              child: Container(
                                padding: EdgeInsets.zero,
                                child: SfCartesianChart(
                                  margin: EdgeInsets.zero,
                                  plotAreaBackgroundColor: Colors.white,
                                  primaryXAxis: CategoryAxis(),
                                  primaryYAxis: NumericAxis(
                                    isVisible: false,
                                    title: AxisTitle(text: ''),
                                    majorTickLines: MajorTickLines(size: 0),
                                    majorGridLines: MajorGridLines(width: 0),
                                    minorGridLines: MinorGridLines(width: 0),
                                  ),
                                  series: <ChartSeries<ChartData, String>>[
                                    ColumnSeries<ChartData, String>(
                                      dataSource: chartData,
                                      xValueMapper: (ChartData data, _) =>
                                      data.month,
                                      yValueMapper: (ChartData data, _) =>
                                      data.target,
                                      dataLabelSettings: DataLabelSettings(
                                        isVisible: true,
                                        labelPosition: ChartDataLabelPosition
                                            .outside,
                                      ),
                                      pointColorMapper: (ChartData data, _) =>
                                      data.month == 'Target'
                                          ? Colors.yellow
                                          : (chartData.indexOf(data) ==
                                          selectedMonthIndex
                                          ? Colors.green
                                          : null),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              LegendItem(
                                color: Colors.yellow,
                                label: 'Target',
                                amount: selectedMonthIndex == -1
                                    ? '₹ 10,000'
                                    : '₹ ${chartData[selectedMonthIndex].target
                                    .toStringAsFixed(2)}',
                              ),
                              LegendItem(
                                color: Color(0xFF85e250),
                                label: 'Income',
                                amount: selectedMonthIndex == -1
                                    ? '₹ 10,000'
                                    : '₹ ${chartData[selectedMonthIndex].target
                                    .toStringAsFixed(2)}',
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Container(
                            width: 150,
                            child: ElevatedButton(
                              onPressed: () {
                                // Add your button action here
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                              ),
                              child: Text('Income Simulator'),
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Action Plan Vs Performance',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 20),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _buildCard('Prospects Added', '0/50', context),
                                _buildCard('Other Title', '1/10', context),
                                // Add more cards as needed
                                _buildCard('Other Title', '1/10', context),
                                _buildCard('Prospects Added', '0/50', context),
                                _buildCard('Other Title', '1/10', context),
                                // Add more cards as needed
                                _buildCard('Other Title', '1/10', context),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
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
              Container(
                height: 200,
                color: Color(0xFFF4F4F4),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildCard('Prospects Added', '0/50', context),
                      _buildCard('Other Title', '1/10', context),
                      _buildCard('Other Title', '1/10', context),
                      _buildCard('Prospects Added', '0/50', context),
                      _buildCard('Other Title', '1/10', context),
                      _buildCard('Other Title', '1/10', context),
                    ],
                  ),
                ),
              ),


              Padding(
                padding: EdgeInsets.only(top: 20),
                // Adjust the top padding as needed
                child: Container(
                  height: 200,
                  color: Colors.white,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      videoItem(
                        context,
                        'Modicare Envirochip Training Program 2016',
                        'https://www.youtube.com/embed/cEiqYPToiZQ?showinfo=0&related=0&enablejsapi=1&autoplay=1&rel=0',
                      ),
                      videoItem(
                        context,
                        'Modicare Envoirochip - Animated Demo',
                        'https://www.youtube.com/embed/RoERmkLylU4?showinfo=0&related=0&enablejsapi=1&autoplay=1&rel=0',
                      ),
                      videoItem(
                        context,
                        'Modicare Envirochip Training Program 2016',
                        'https://www.youtube.com/embed/cEiqYPToiZQ?showinfo=0&related=0&enablejsapi=1&autoplay=1&rel=0',
                      ),
                      videoItem(
                        context,
                        'Modicare Envirochip Training Program 2016',
                        'https://www.youtube.com/embed/cEiqYPToiZQ?showinfo=0&related=0&enablejsapi=1&autoplay=1&rel=0',
                      ),
                      videoItem(
                        context,
                        'Modicare Envirochip Training Program 2016',
                        'https://www.youtube.com/embed/cEiqYPToiZQ?showinfo=0&related=0&enablejsapi=1&autoplay=1&rel=0',
                      ),
                      // Add more video items as needed
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard(String title, String subtitle, BuildContext context) {
    return Container(
      width: 160, // Fixed width for the card
      height: 190, // Fixed height for the card
      margin: EdgeInsets.symmetric(horizontal: 6.0),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.8),
            spreadRadius: 1,
            blurRadius: 1,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 5),
            Text(
              subtitle,
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 10),
            SizedBox(
              width: 120,
              height: 100,
              child: Stack(
                children: [
                  CircularProgressIndicator(
                    value: 0, // Set your progress value here
                    strokeWidth: 8,
                    backgroundColor: Colors.grey.withOpacity(0.2),
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                  ),
                  Center(
                    child: Text(
                      '0%', // Set your percentage here
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

  class ChartData {
  final String month;
  final double target;

  ChartData(this.month, this.target);
}

class LegendItem extends StatelessWidget {
  final Color color;
  final String label;
  final String amount;

  LegendItem({required this.color, required this.label, this.amount = ''});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 5),
              Text(label),
            ],
          ),
          if (amount.isNotEmpty) Text(amount),
        ],
      ),
    );
  }
}


Widget videoItem(BuildContext context, String title, String videoUrl) {
  return GestureDetector(
    onTap: () {
      _playYoutubeVideo(context, videoUrl);
    },
    child: SizedBox(
      height: 200, // Adjust this height as needed
      child: Padding(
        padding: const EdgeInsets.fromLTRB(4.0, 20.0, 0.0, 0.0), // Padding from left, top, right, and bottom
        child: Container(
          width: 150,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Image.network(
                    'https://img.youtube.com/vi/${videoUrl.split('/').last.split('?').first}/0.jpg',
                    width: 120,
                    height: 75,
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    child: Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(0),
                          bottomRight: Radius.circular(8),
                        ),
                      ),
                      child: Icon(
                        Icons.play_arrow,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Text(
                title,
                style: TextStyle(fontSize: 12),
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
          content: Container(
            width: double.maxFinite, // Set the width as needed
            height: 400, // Set the height as needed
            child: YoutubePlayer(
              controller: YoutubePlayerController(
                initialVideoId: YoutubePlayer.convertUrlToId(videoUrl) ?? '',
                flags: YoutubePlayerFlags(
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
    print('Video URL is null');
  }
}

void main() {
  runApp(MaterialApp(
    home: DashboardScreen(),
  ));
}
