import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';


class Step3IG extends StatefulWidget {
  final VoidCallback? onNextPressed;

  const Step3IG({Key? key, this.onNextPressed}) : super(key: key);

  @override
  _Step3IGState createState() => _Step3IGState();
}

class _Step3IGState extends State<Step3IG> {
  bool sellProducts = true;
  bool createTeam = false;
  bool bothAbove = false;
  TextEditingController _incomeController = TextEditingController();
  Color activeColor = Colors.blue; // Change this to your desired color
  Color inactiveColor = Colors.grey;
  bool isIncomeFieldFilled = false; // Track if income field is filled
  bool isAnyCheckboxSelected = true; // Track if any checkbox is selected

  void _validateAndContinue() {
    if (isIncomeFieldFilled && isAnyCheckboxSelected) {
      widget.onNextPressed?.call();
    } else {
      String message = '';
      if (!isIncomeFieldFilled) {
        message += 'Please fill the income field. ';
      }
      if (!isAnyCheckboxSelected) {
        message += 'Please select at least one option.';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }


  final TextEditingController _controller = TextEditingController();
  String _csrfToken = '';
  String _xsrfToken = '';
  String _modicareSession = '';

  @override
  void initState() {
    super.initState();
    _fetchCsrfToken();
  }

  Future<void> _fetchCsrfToken() async {
    final response = await http.get(Uri.parse('https://mdash.gprlive.com/api/csrf-token'));
    print('CSRF Token Fetch Response:');
    print('Status Code: ${response.statusCode}');
    print('Headers: ${response.headers}');
    print('Body: ${response.body}');

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      setState(() {
        _csrfToken = responseBody['csrf_token'];
      });
      final cookies = response.headers['set-cookie'];
      if (cookies != null) {
        setState(() {
          _xsrfToken = RegExp(r'XSRF-TOKEN=([^;]+)').firstMatch(cookies)?.group(1) ?? '';
          _modicareSession = RegExp(r'modicare_session=([^;]+)').firstMatch(cookies)?.group(1) ?? '';
        });
      }
    } else {
      print('Failed to fetch CSRF token');
    }
  }

  Future<void> _sendUpdateRequest(String targetValue) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String mcaNumber = prefs.getString('mcaNumber') ?? ''; // Fetch mcaNumber from SharedPreferences

    dynamic targetRole; // Use dynamic type for flexibility
    if (sellProducts && !createTeam && !bothAbove) {
      targetRole = 1;
    } else if (!sellProducts && createTeam && !bothAbove) {
      targetRole = 2;
    } else if (sellProducts && createTeam && bothAbove) {
      targetRole = [1, 2]; // Now targetRole can be an integer or an array
    }

    // Only proceed if targetRole is not null
    if (targetRole != null) {
      final url = Uri.parse('https://mdash.gprlive.com/api/update-user/$mcaNumber');
      final headers = {
        'Content-Type': 'application/json',
        'X-CSRF-TOKEN': _csrfToken,
        'Cookie': 'XSRF-TOKEN=$_xsrfToken; modicare_session=$_modicareSession',
      };
      final body = jsonEncode({'target': targetValue, 'target_role': targetRole});

      // Print request details
      print('Request URL: $url');
      print('Request Headers: $headers');
      print('Request Body: $body');

      try {
        final response = await http.put(url, headers: headers, body: body);

        // Print response details
        print('Update Response:');
        print('Status Code: ${response.statusCode}');
        print('Headers: ${response.headers}');
        print('Body: ${response.body}');

        if (response.statusCode == 200) {
          print('Update successful');
        } else {
          print('Failed to update user');
        }
      } catch (e) {
        print('Exception caught: $e');
      }
    } else {
      print('No target role selected'); // Handle the case where no target role is selected
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(0.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Set Income Goal',
                        style: TextStyle(
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Text(
                        'Dream Cheque',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Container(
                        padding: EdgeInsets.only(
                          top: 4.0,
                          right: 3.0,
                          bottom: 5.0,
                          left: 64.0,
                        ),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage('https://rtfapi.modicare.com/img/ChequeBorder@3x.png'),
                            fit: BoxFit.cover,
                            alignment: Alignment.topLeft, // Aligns the image to the top left corner
                          ),
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 1,
                              blurRadius: 3,
                              offset: Offset(0, 2), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Bank of Azadi',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Pay Mohammad Mustafa',
                                  style: TextStyle(fontSize: 16.0),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Sum of ₹',
                                  style: TextStyle(fontSize: 16.0),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: TextField(
                                      controller: _controller, // Add the controller here
                                      keyboardType: TextInputType.number,
                                      inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                                      onChanged: (value) {
                                        setState(() {
                                          isIncomeFieldFilled = value.isNotEmpty;
                                        });
                                      },
                                      decoration: InputDecoration(
                                        hintText: 'Enter amount',
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10.0),
                            Image.network(
                              'https://rtfapi.modicare.com/img/mr%20modi%20signature-01@3x.png',
                              width: 150,
                            ),
                            Text(
                              'MCA 70690073 Mr. Samir K Modi',
                              style: TextStyle(fontSize: 14.0),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20.0),
                      Text(
                        'Would you like to:',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10.0),
                      ListTile(
                        title: Text('Sell Products'),
                        trailing: CupertinoSwitch( // Using CupertinoSwitch
                          value: sellProducts,
                          onChanged: (value) {
                            setState(() {
                              sellProducts = value;
                              if (sellProducts && createTeam) {
                                bothAbove = true;
                              } else {
                                bothAbove = false;
                              }
                              isAnyCheckboxSelected = sellProducts || createTeam || bothAbove;
                            });
                          },
                          activeColor: activeColor, // Set active color
                          trackColor: inactiveColor, // Set inactive color
                        ),
                      ),
                      ListTile(
                        title: Text('Create Team'),
                        trailing: CupertinoSwitch( // Using CupertinoSwitch
                          value: createTeam,
                          onChanged: (value) {
                            setState(() {
                              createTeam = value;
                              if (sellProducts && createTeam) {
                                bothAbove = true;
                              } else {
                                bothAbove = false;
                              }
                              isAnyCheckboxSelected = sellProducts || createTeam || bothAbove;
                            });
                          },
                          activeColor: activeColor, // Set active color
                          trackColor: inactiveColor, // Set inactive color
                        ),
                      ),
                      ListTile(
                        title: Text('Both Above'),
                        trailing: CupertinoSwitch( // Using CupertinoSwitch
                          value: bothAbove,
                          onChanged: (value) {
                            setState(() {
                              bothAbove = value;
                              if (bothAbove) {
                                sellProducts = true;
                                createTeam = true;
                              } else {
                                sellProducts = false;
                                createTeam = false;
                              }
                              isAnyCheckboxSelected = sellProducts || createTeam || bothAbove;
                            });
                          },
                          activeColor: activeColor, // Set active color
                          trackColor: inactiveColor, // Set inactive color
                        ),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(left: 20.0, right: 20.0),
                  child: Center(
                    child: SizedBox(
                      width: 130.0,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color(0xff12D8FA),
                              Color(0xff1FA2FF),
                              Color(0xff1FA2FF),
                            ],
                            begin: Alignment.centerRight,
                            end: Alignment.centerLeft,
                          ),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: TextButton(
                          onPressed: () {
                            _sendUpdateRequest(_controller.text);
                            _validateAndContinue(); // Validate before calling onNextPressed
                          },
                          child: Text(
                            'Continue',
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                Container(
                  color: Color(0xFFf8f7fc), // Set background color
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0), // Padding from left and right: 16.0
                    child: Text(
                      '** In Modicare, your earnings are directly proportional to the effort and skills you invest. Success is determined by your dedication and ability to effectively market and sell products to customers and create a team of Modicare Direct Sellers.',
                      style: TextStyle(fontSize: 14.0),
                    ),
                  ),
                ),
                SizedBox(height: 30.0),
                SizedBox(height: 100.0),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _incomeController.dispose(); // Dispose the controller when not needed
    super.dispose();
  }
}

void main() {
  runApp(MaterialApp(
    home: Step3IG(),
  ));
}
