import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'infoscreen.dart';

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
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: GestureDetector(
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
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 10),
              Container(
                height: 320,
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
              SizedBox(height: 24),
              Row(
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
              Row(
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
              SizedBox(height: 16),
              Align(
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
              SizedBox(height: 16),
              Text(
                'Action Plan Vs Performance',
                style: TextStyle(
                  fontSize: 16,
                  color: const Color(0xff535353),
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
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
