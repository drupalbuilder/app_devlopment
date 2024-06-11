import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class OrdinalSales {
  final String month;
  final int sales;

  OrdinalSales(this.month, this.sales);
}

class LoyaltyReport extends StatefulWidget {
  @override
  _LoyaltyReportState createState() => _LoyaltyReportState();
}

class _LoyaltyReportState extends State<LoyaltyReport> {
  String _mcaNumber = '';
  String _apiResponse = '';
  List<OrdinalSales> _chartData = [];
  int? _selectedBarIndex;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String mcaNumber = prefs.getString('mcaNumber') ?? '';

    print('MCA Number from SharedPreferences: $mcaNumber'); // Debugging print

    if (mcaNumber.isEmpty) {
      setState(() {
        _mcaNumber = 'No MCA Number stored';
      });
      return;
    }

    // Your API endpoint URL
    String apiUrl = "https://report.modicare.com/api/report/loyalty/qualifier";

    // Construct the request body
    Map<String, String> body = {
      "mcano": mcaNumber,
      "downline": mcaNumber
    };

    // Define headers for the API request
    Map<String, String> headers = {
      "Content-Type": "application/json",
    };

    try {
      // Make the API call
      var response = await http.post(
          Uri.parse(apiUrl), headers: headers, body: jsonEncode(body));

      if (response.statusCode == 200) {
        // If the API call is successful, update the state with the API response and parse data for the chart
        setState(() {
          _apiResponse = response.body;
          _mcaNumber = mcaNumber;
          _chartData = _parseChartData(response.body);
        });
      } else {
        // Handle API error response
        print('Error response from API: ${response.statusCode} - ${response.body}');
        setState(() {
          _apiResponse = 'Error response from API: ${response.statusCode}';
        });
      }
    } catch (e) {
      // Handle API call exception
      print('Error making API call: $e');
      setState(() {
        _apiResponse = 'Error making API call: $e';
      });
    }
  }

  List<OrdinalSales> _parseChartData(String responseBody) {
    List<OrdinalSales> chartData = [];
    final parsed = jsonDecode(responseBody);
    final result = parsed['result'];

    final months = [
      "Jul_2023", "Aug_2023", "Sep_2023", "Oct_2023", "Nov_2023", "Dec_2023",
      "Jan_2024", "Feb_2024", "Mar_2024", "Apr_2024", "May_2024", "Jun_2024"
    ];

    months.forEach((month) {
      double amount = double.tryParse(result[0][month] ?? '0.0') ?? 0.0;
      chartData.add(
          OrdinalSales(month, amount.toInt())); // Convert to int if needed
    });

    return chartData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(0.0),
            child: Column(
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
                              'Loyalty Report',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  // Set scroll direction to horizontal
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    // Set scroll direction to vertical for inner scroll view
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20.0),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 16.0), // Add horizontal padding
                          child: Container(
                            padding: EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey, width: 1.0),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: SizedBox(
                              height: 320.0, // Set a fixed height for the chart

                              width: _chartData.isNotEmpty
                                  ? _chartData.length * 100.0 // Increase the width of bars
                                  : MediaQuery.of(context).size.width, // Set a default width
                              child: charts.BarChart(
                                _chartData.isEmpty
                                    ? []
                                    : [
                                  charts.Series<OrdinalSales, String>(
                                    id: 'Sales',
                                    colorFn: (_, index) {
                                      if (_selectedBarIndex != null && _selectedBarIndex == index) {
                                        return charts.ColorUtil.fromDartColor(Color(0xfffdcd11)); // Use the desired color when the condition is met
                                      } else {
                                        return charts.MaterialPalette.blue.shadeDefault; // Default to yellow shade
                                      }
                                    },
                                    domainFn: (OrdinalSales sales, _) => sales.month,
                                    measureFn: (OrdinalSales sales, _) => sales.sales,
                                    data: _chartData,
                                    labelAccessorFn: (OrdinalSales sales, index) =>
                                    _selectedBarIndex != null && _selectedBarIndex == index
                                        ? '₹ ${sales.sales}' // Show label with rupee symbol and color only if selected
                                        : '',
                                  ),

                                ],
                                animate: true,
                                vertical: true, // Set vertical to true to display bars vertically
                                primaryMeasureAxis: charts.NumericAxisSpec(
                                  tickProviderSpec: charts.BasicNumericTickProviderSpec(desiredTickCount: 6), // Adjust the tick count as needed
                                  renderSpec: charts.GridlineRendererSpec(
                                    labelStyle: charts.TextStyleSpec(fontSize: 12), // Adjust label font size
                                    lineStyle: charts.LineStyleSpec(color: charts.MaterialPalette.transparent), // Set line color to transparent
                                  ),
                                  tickFormatterSpec: charts.BasicNumericTickFormatterSpec(
                                        (num? value) => '₹ ${value != null ? value.toInt().toString() : '0'}', // Add rupees symbol to tick labels without decimals
                                  ),
                                ),
                                domainAxis: charts.OrdinalAxisSpec(
                                  renderSpec: charts.SmallTickRendererSpec(
                                    labelStyle: charts.TextStyleSpec(fontSize: 12), // Adjust label font size
                                  ),
                                ),
                                behaviors: [
                                  charts.SelectNearest(
                                    eventTrigger: charts.SelectionTrigger.tapAndDrag,
                                  ),
                                ],
                                barRendererDecorator: charts.BarLabelDecorator<String>(
                                  insideLabelStyleSpec: charts.TextStyleSpec(fontSize: 12, color: charts.MaterialPalette.white),
                                  outsideLabelStyleSpec: charts.TextStyleSpec(fontSize: 12, color: charts.MaterialPalette.black),
                                ),
                                selectionModels: [
                                  charts.SelectionModelConfig(
                                    type: charts.SelectionModelType.info,
                                    changedListener: (charts.SelectionModel<String> model) {
                                      if (model.hasDatumSelection) {
                                        setState(() {
                                          _selectedBarIndex = model.selectedDatum[0].index!;
                                        });
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                      ],
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
}

void main() {
  runApp(MaterialApp(
    title: 'Loyalty Report',
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    home: LoyaltyReport(),
  ));
}
