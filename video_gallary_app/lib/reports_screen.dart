import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({Key? key}) : super(key: key);

  @override
  _ReportsScreenState createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reports'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildEarningCharts(),
              const SizedBox(height: 20),
              _buildPaymentHistory(),
              const SizedBox(height: 20),
              _buildEarnedPoints(),
              const SizedBox(height: 20),
              _buildWithdrawHistory(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEarningCharts() {
    List<SalesData> earningData = [
      SalesData(0, 5),
      SalesData(1, 10),
      SalesData(2, 8),
      SalesData(3, 15),
      SalesData(4, 12),
      SalesData(5, 18),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Earning Charts',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SfCartesianChart(
          primaryXAxis: NumericAxis(),
          primaryYAxis: NumericAxis(),
          series: <LineSeries<SalesData, num>>[
            LineSeries<SalesData, num>(
              dataSource: earningData,
              xValueMapper: (SalesData sales, _) => sales.year,
              yValueMapper: (SalesData sales, _) => sales.sales,
              name: 'Earnings',
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPaymentHistory() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Payment History',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        // Add your payment history UI here
        // You can use ListView.builder for a list of payments
        // Example:
        // ListView.builder(
        //   itemCount: paymentHistory.length,
        //   itemBuilder: (context, index) {
        //     return ListTile(
        //       title: Text('Payment ${index + 1}'),
        //       subtitle: Text('Amount: \$${paymentHistory[index].amount}'),
        //     );
        //   },
        // ),
      ],
    );
  }

  Widget _buildEarnedPoints() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Earned Points',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        // Add your earned points UI here
        // You can use ListView.builder for a list of earned points
      ],
    );
  }

  Widget _buildWithdrawHistory() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Withdraw History',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        // Add your withdraw history UI here
        // You can use ListView.builder for a list of withdraws
      ],
    );
  }
}

class SalesData {
  final num year;
  final num sales;

  SalesData(this.year, this.sales);
}
