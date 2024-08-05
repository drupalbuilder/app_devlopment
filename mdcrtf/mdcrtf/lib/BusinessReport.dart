import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:charts_flutter/flutter.dart' as charts;



enum DisplayMode {
  Business,
  Bonuses,
}

class BusinessReport extends StatefulWidget {
  @override
  _BusinessReportState createState() => _BusinessReportState();
}

class _BusinessReportState extends State<BusinessReport> {
  List<dynamic> dashboardData = [];
  List<OrdinalSales> chartData = [];
  bool isLoading = true;
  String selectedMonth = '';
  DisplayMode selectedMode = DisplayMode.Business;
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _fetchDashboardData();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color(0xfffff9f9),
        child: SafeArea(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16.0),
                color: Colors.white,
                child: Row(
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
                          ),
                          SizedBox(width: 0.0), // Add some space between the icon and text
                          Text(
                            'Back',
                            style: TextStyle(
                              color: Color(0xFF0396FE),
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Spacer(),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 16.0, bottom: 6.0),
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'My Business Report',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 8.0),
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(20.0),
                            bottomRight: Radius.circular(20.0),
                          ),
                          color: const Color.fromARGB(255, 255, 255, 255),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.30),
                              offset: Offset(0, 1.5),
                              blurRadius: 0,
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 300,
                              child: charts.BarChart(
                                _createChartData(),
                                animate: true,
                                primaryMeasureAxis: charts.NumericAxisSpec(
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
                                    changedListener: _onSelectionChanged,
                                  ),
                                ],
                              ),
                            ),
                            // Add the row for Target and Income indicators
                            Padding(
                              padding: EdgeInsets.only(left: 16.0, top: 16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
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
                                        'GPV',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: const Color(0xff535353),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(width: 30),
                                      Container(
                                        width: 15,
                                        height: 15,
                                        decoration: BoxDecoration(
                                          color: const Color(0xff08a64d),
                                          borderRadius: BorderRadius.circular(3),
                                        ),
                                      ),
                                      SizedBox(width: 5),
                                      const Text(
                                        'PGPV',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: const Color(0xff535353),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(width: 30),
                                      Container(
                                        width: 15,
                                        height: 15,
                                        decoration: BoxDecoration(
                                          color: const Color(0xfffbcc11),
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
                                  SizedBox(height: 8), // Adjust as needed for spacing

                                  // Values Row
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(width: 0),
                                      Text(
                                        '₹ ${_getGPVValue()}',
                                        style: const TextStyle(
                                          fontSize: 24,
                                          color: const Color(0xff535353),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(width: 30),
                                      Text(
                                        '₹ ${_getPGPVValue()}',
                                        style: const TextStyle(
                                          fontSize: 24,
                                          color: const Color(0xff535353),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(width: 30),
                                      Text(
                                        '${_getIncomeValue()}', // Added '₹' symbol here
                                        style: const TextStyle(
                                          fontSize: 24,
                                          color: const Color(0xff535353),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10), // Added spacing
                      Container(
                        height: 140,
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${_getTittlevar()}',
                              style: TextStyle(
                                color: const Color(0xff535353),
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Title',
                              style: TextStyle(
                                color: const Color(0xff535353),
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.left,
                            ),
                            Text(
                              'Paid as:  ${_getPaidAsTitle()}',
                              style: TextStyle(
                                color: const Color(0xff535353),
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.left,
                            ),
                            Text(
                              'Valid:  ${_getValidvar()}',
                              style: TextStyle(
                                color: const Color(0xff535353),
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 16.0, top: 16.0), // Adjust the value as needed
                        child: Row(
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  selectedMode = DisplayMode.Business;
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: selectedMode == DisplayMode.Business ? Color(0xFF08a8e7) : Colors.white, // Active text color
                                foregroundColor: selectedMode == DisplayMode.Business ? Colors.white : Color(0xFF08a8e7), // Active background color
                                padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
                                textStyle: TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                                side: BorderSide(
                                  color: Color(0xFF08a8e7),
                                  width: 1.0,
                                ),
                              ),
                              child: Text('Business'),
                            ),
                            SizedBox(width: 8.0),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  selectedMode = DisplayMode.Bonuses;
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: selectedMode == DisplayMode.Bonuses ? Color(0xFF08a8e7) : Colors.white, // Active text color
                                foregroundColor: selectedMode == DisplayMode.Bonuses ? Colors.white : Color(0xFF08a8e7), // Active background color
                                padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
                                textStyle: TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                                side: BorderSide(
                                  color: Color(0xFF08a8e7),
                                  width: 1.0,
                                ),
                              ),
                              child: Text('Bonuses'),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16.0),
                      selectedMode == DisplayMode.Business
                          ? _buildBusinessWidget()
                          : _buildBonusesWidget(),
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

  String _getGPVValue() {
    if (dashboardData.isNotEmpty) {
      var data = dashboardData.firstWhere(
            (item) => item['BV Month'] == selectedMonth,
        orElse: () => {'GPV': 0},
      );
      return (data['GPV'] ?? 0).toString(); // Use null-aware operator to handle null values
    } else {
      return '0'; // Return '0' as the default value when dashboardData is empty
    }
  }

  String _getPGPVValue() {
    if (dashboardData.isNotEmpty) {
      var data = dashboardData.firstWhere(
            (item) => item['BV Month'] == selectedMonth,
        orElse: () => {'PGPV': 0},
      );
      return (data['PGPV'] ?? 0).toString(); // Use null-aware operator to handle null values
    } else {
      return '0'; // Return '0' as the default value when dashboardData is empty
    }
  }

  String _getIncomeValue() {
    if (dashboardData.isNotEmpty) {
      var data = dashboardData.firstWhere(
            (item) => item['BV Month'] == selectedMonth,
        orElse: () => {'Gross': 0},
      );
      return (data['Gross'] ?? 0).toString(); // Use null-aware operator to handle null values
    } else {
      return '0'; // Return '0' as the default value when dashboardData is empty
    }
  }

  String _getTittlevar() {
    if (dashboardData.isNotEmpty) {
      var data = dashboardData.firstWhere(
            (item) => item['BV Month'] == selectedMonth,
        orElse: () => {'BV Month': 0},
      );
      return (data['BV Month'] ?? 0).toString(); // Use null-aware operator to handle null values
    } else {
      return '0'; // Return '0' as the default value when dashboardData is empty
    }
  }

  String   _getPaidAsTitle() {
    if (dashboardData.isNotEmpty) {
      var data = dashboardData.firstWhere(
            (item) => item['BV Month'] == selectedMonth,
        orElse: () => null, // Added orElse to handle situations where no matching item is found
      );
      if (data != null) {
        return (data['Valid Title'] ?? 0).toString(); // Use null-aware operator to handle null values
      }
    }
    return ''; // Return a default value in case the condition is not met
  }
    String _getValidvar() {
      if (dashboardData.isNotEmpty) {
        var data = dashboardData.firstWhere(
              (item) => item['BV Month'] == selectedMonth,
          orElse: () => null, // Added orElse to handle situations where no matching item is found
        );
        if (data != null) {
          return (data['Paid As Title'] ?? 0).toString(); // Use null-aware operator to handle null values
        }
      }
      return ''; // Return a default value in case the condition is not met
    }


  Widget _buildBusinessWidget() {
    List<Widget> widgets = [];
    for (var item in dashboardData) {
      if (item['BV Month'] == selectedMonth) {
        widgets.addAll([
          _builditems(
            title: 'BV Month',
            value: (item['BV Month'] ?? 0).toString(),
          ),
          _builditems(
            title: 'PPV / PBV',
            value: '${item['PPV'] ?? 0} / ${item['PBV'] ?? 0}',
          ),
          _builditems(
            title: 'Extra PV',
            value: (item['Extra PV'] ?? 0).toString(),
          ),
          _builditems(
            title: 'Extra BV',
            value: (item['Extra BV'] ?? 0).toString(),
          ),
          _builditems(
            title: 'Rollup PV',
            value: (item['Rollup PV'] ?? 0).toString(),
          ),
          _builditems(
            title: 'Accumulated PV',
            value: (item['Accumulated PV'] ?? 0).toString(),
          ),
          _builditems(
            title: 'GPV / GBV',
            value: (item['GPV / GBV'] ?? 0).toString(),
          ),
          _builditems(
            title: 'PGPV / PGBV',
            value: (item['PGPV / PGBV'] ?? 0).toString(),
          ),
          _builditems(
            title: 'Current Level',
            value: (item['Current Level'] ?? 0).toString(),
          ),
          _builditems(
            title: 'Points short By PV for next level',
            value: (item['Points short By PV for next level'] ?? 0).toString(),
          ),
          _builditems(
            title: 'Legs',
            value: (item['Legs'] ?? 0).toString(),
          ),
          _builditems(
            title: 'Total qualified Director and above Legs',
            value: (item['Total qualified Director and above Legs'] ?? 0).toString(),
          ),
          _builditems(
            title: 'Valid Title',
            value: (item['Valid Title'] ?? 0).toString(),
          ),
          _builditems(
            title: 'Paid As Title',
            value: (item['Paid As Title'] ?? 0).toString(),
          ),
          _builditems(
            title: 'Director Bonus Points',
            value: (item['Director Bonus Points'] ?? 0).toString(),
          ),
          _builditems(
            title: 'Builder Bonus Points',
            value: (item['Builder Bonus Points'] ?? 0).toString(),
          ),
          _builditems(
            title: 'Team Bonus Points',
            value: (item['Team Bonus Points'] ?? 0).toString(),
          ),
          _builditems(
            title: 'Travel Fund Bonus Points',
            value: (item['Travel Fund Bonus Points'] ?? 0).toString(),
          ),
          _builditems(
            title: 'Leadership Productivity Bonus Points',
            value: (item['Leadership Productivity Bonus Points'] ?? 0).toString(),
          ),
          _builditems(
            title: 'Founder Bonus Points',
            value: (item['Founder Bonus Points'] ?? 0).toString(),
          ),
          // Add more items as needed
        ]);
      }
    }
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: widgets,
      ),
    );
  }



  Widget _buildBonusesWidget() {
    List<Widget> widgets = [];
    for (var item in dashboardData) {
      if (item['BV Month'] == selectedMonth) {
        widgets.addAll([
          _builditems(
            title: 'Accumulated Performance Bonus',
            value: (item['Accumulated Performance Bonus'] ?? 0).toString(),
          ),
          _builditems(
            title: 'Director Bonus',
            value: (item['Director Bonus'] ?? 0).toString(),
          ),
          _builditems(
            title: 'Diamond Bonus Points',
            value: (item['Diamond Bonus Points'] ?? 0).toString(),
          ),
          _builditems(
            title: 'Team Bonus',
            value: (item['Team Bonus'] ?? 0).toString(),
          ),
          _builditems(
            title: 'Car Fund',
            value: (item['Car Fund'] ?? 0).toString(),
          ),
          _builditems(
            title: 'Travel Fund',
            value: (item['Travel Fund'] ?? 0).toString(),
          ),
          _builditems(
            title: 'House Bonus',
            value: (item['House Bonus'] ?? 0).toString(),
          ),
          _builditems(
            title: 'Builder Bonus',
            value: (item['Builder Bonus'] ?? 0).toString(),
          ),
          _builditems(
            title: 'Leadership Productivity Bonus',
            value: (item['Leadership Productivity Bonus'] ?? 0).toString(),
          ),
          _builditems(
            title: 'Founder Bonus',
            value: (item['Founder Bonus'] ?? 0).toString(),
          ),
          _builditems(
            title: 'Gross',
            value: (item['Gross'] ?? 0).toString(),
          ),
          _builditems(
            title: 'Diamond Bonus',
            value: (item['Diamond Bonus'] ?? 0).toString(),
          ),
          // Add more bonus-related items here using _builditems function
        ]);
      }
    }
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 0.0), // Horizontal margin for the outer container
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: widgets,
      ),
    );
  }


  Widget _builditems({required String title, required String value}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8.0), // Margin bottom between items
      decoration: BoxDecoration(
        color: Colors.white, // White background color
        borderRadius: BorderRadius.circular(0.0), // Rounded corners
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.8), // Box shadow color with opacity
            spreadRadius: 0,
            blurRadius: 2,
            offset: Offset(0, 0), // Shadow offset
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 14.0), // Padding inside container
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w900,
                color: const Color(0xff535353), // White background color
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.w900,
                color: const Color(0xff868686),
              ),
            ),
          ],
        ),
      ),
    );
  }




  Future<void> _fetchDashboardData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? mcaNumber = prefs.getString('mcaNumber');

    if (mcaNumber != null) {
      String url = 'https://report.modicare.com/api/report/np/business/web/six';
      Map<String, String> headers = {
        "Content-Type": "application/json",
        "x-api-key": "Y9S3TA-8R3NGQ-TPJ9T7-808631"
      };
      String body = jsonEncode({
        "mcano": mcaNumber,
        "dated": "${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}-01"
      });

      try {
        final response = await http.post(
          Uri.parse(url),
          headers: headers,
          body: body,
        );

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
              content: Text('Failed to fetch dashboard data.'),
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


// Update _createChartData method to include the selected index
  List<charts.Series<OrdinalSales, String>> _createChartData() {
    chartData.clear();
    for (var item in dashboardData) {
      String month = item['BV Month'];
      double grossIncome = double.tryParse(
          item['Gross']?.replaceAll('₹ ', '') ?? '0.00') ?? 0.0;
      chartData.add(OrdinalSales(month, grossIncome));
    }

    // Set the default selection if the data is not empty
    if (chartData.isNotEmpty && selectedIndex >= 0 && selectedIndex < chartData.length) {
      selectedMonth = chartData[selectedIndex].month;
    }

    return [
      charts.Series<OrdinalSales, String>(
        id: 'Sales',
        colorFn: (sales, _) {
          if (sales.month == selectedMonth) {
            return charts.Color.fromHex(code: '#fdcd11');
          } else if (sales.month == 'Target') {
            return charts.Color.fromHex(code: '#fdcd11');
          } else {
            return charts.Color(r: 37, g: 205, b: 215);
          }
        },
        domainFn: (sales, _) => sales.month,
        measureFn: (sales, _) => sales.sales,
        data: chartData,
      ),
    ];
  }



// Update _onSelectionChanged method to handle selection changes
  void _onSelectionChanged(charts.SelectionModel model) {
    if (model.hasDatumSelection) {
      final selectedDatum = model.selectedDatum[0];
      setState(() {
        selectedMonth = selectedDatum.datum.month;
        // Update the selectedIndex based on the selected data
        selectedIndex = chartData.indexWhere((element) => element.month == selectedMonth);
      });
    }
  }



}

class OrdinalSales {
  final String month;
  final double sales;

  OrdinalSales(this.month, this.sales);
}

void main() {
  runApp(MaterialApp(
    home: BusinessReport(),
  ));
}








