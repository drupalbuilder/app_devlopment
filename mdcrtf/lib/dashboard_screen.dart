import 'package:flutter/material.dart';
import 'infoscreen.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:carousel_slider/carousel_slider.dart';

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
        body: ListView(
          children: [
            Container(
              height: 650,
              margin: EdgeInsets.only(bottom: 20.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20.0),
                  bottomRight: Radius.circular(20.0),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 10,
                    offset: Offset(0, 5),
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
                                  MaterialPageRoute(builder: (context) => InfoScreen()),
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
                            RenderBox renderBox = context.findRenderObject() as RenderBox;
                            var localPosition = renderBox.globalToLocal(details.globalPosition);
                            int tappedIndex = ((localPosition.dx - 16.0) / (MediaQuery.of(context).size.width - 32.0) * 5).round();

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
                                    xValueMapper: (ChartData data, _) => data.month,
                                    yValueMapper: (ChartData data, _) => data.target,
                                    dataLabelSettings: DataLabelSettings(
                                      isVisible: true,
                                      labelPosition: ChartDataLabelPosition.outside,
                                    ),
                                    pointColorMapper: (ChartData data, _) =>
                                    data.month == 'Target' ? Colors.yellow : (chartData.indexOf(data) == selectedMonthIndex ? Colors.green : null),
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
                              amount: selectedMonthIndex == -1 ? '₹ 10,000' : '₹ ${chartData[selectedMonthIndex].target.toStringAsFixed(2)}',
                            ),
                            LegendItem(
                              color: Color(0xFF85e250),
                              label: 'Income',
                              amount: selectedMonthIndex == -1 ? '₹ 10,000' : '₹ ${chartData[selectedMonthIndex].target.toStringAsFixed(2)}',
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
                              primary: Colors.blue,
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
                        Container(
                          height: 150,
                          child: CarouselSlider(
                            options: CarouselOptions(
                              height: 150,
                              autoPlay: false,
                              enableInfiniteScroll: false,
                              viewportFraction: 0.55,
                              initialPage: 0,
                            ),
                            items: List.generate(4, (index) => ModifiedCardItem(index: index)),
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
                    'Container Title',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'This is a paragraph aligned to the left. You can add your content here.',
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
              height: 160,
              color: Color(0xFFF4F4F4),
            ),
            Container(
              height: 500,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}


class ModifiedCardItem extends StatelessWidget {
  final int index;

  ModifiedCardItem({required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5.0),
      width: MediaQuery.of(context).size.width * 0.8,
      decoration: BoxDecoration(
        color: Colors.blueGrey,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Card $index',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 10),
            Text(
              'Next Level\nGPV Required',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
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

void main() {
  runApp(MaterialApp(
    home: DashboardScreen(),
  ));
}
