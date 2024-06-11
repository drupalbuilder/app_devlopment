import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';


class CalendarSettings extends StatefulWidget {
  const CalendarSettings({Key? key}) : super(key: key);

  @override
  _CalendarSettingsState createState() => _CalendarSettingsState();
}

class _CalendarSettingsState extends State<CalendarSettings> {
  List<dynamic> _events = [];
  List<dynamic> _filteredEvents = [];
  bool _isLoading = true;
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _fetchEvents();
  }

  Future<void> _fetchEvents() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String mcaNumber = prefs.getString('mcaNumber') ?? '';

    final response = await http.get(
      Uri.parse('https://mdash.gprlive.com/api/Calendar/$mcaNumber'),
    );

    if (response.statusCode == 200) {
      setState(() {
        _events = json.decode(response.body);
        _isLoading = false;
        _filterEventsByDate(_selectedDay ?? DateTime.now());
      });
    } else {
      // Handle the error appropriately here
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _filterEventsByDate(DateTime date) {
    setState(() {
      _filteredEvents = _events.where((event) {
        DateTime eventDate = DateTime.parse(event['dtime']);
        return isSameDay(eventDate, date);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(0.0),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20.0),
                      bottomRight: Radius.circular(20.0),
                    ),
                    color: Colors.white,
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
                              Navigator.pop(context);
                            },
                            child: Row(
                              children: [
                                Icon(
                                  Icons.arrow_back_ios,
                                  color: Color(0xFF0396FE),
                                  size: 20.0,
                                ),
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
                        ],
                      ),
                      SizedBox(height: 10.0),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'My Calendar',
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

                const SizedBox(height: 20.0),

                const CalendarWidget(),

                const SizedBox(height: 20.0),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AddEventScreen(name: '', contact: '',)),
                        );
                      },
                      child: Text('+ Add Event'),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Color(0xFF0396FE), backgroundColor: Colors.white,
                      ),
                    ),
                    SizedBox(width: 16.0),
                  ],
                ),

                const SizedBox(height: 20.0),

                _isLoading
                    ? CircularProgressIndicator()
                    : _filteredEvents.isEmpty
                    ? Text('No events found for the selected date')
                    : ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: _filteredEvents.length,
                  itemBuilder: (context, index) {
                    final event = _filteredEvents[index];
                    final dtime = event['dtime'] ?? 'No Date';
                    final description = event['description'] ?? 'No Description';
                    return ListTile(
                      title: Text(dtime),
                      subtitle: Text(description),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CalendarWidget extends StatefulWidget {
  const CalendarWidget({Key? key}) : super(key: key);

  @override
  _CalendarWidgetState createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  late CalendarFormat _calendarFormat;
  late DateTime _focusedDay;
  late DateTime _selectedDay;

  @override
  void initState() {
    super.initState();
    _calendarFormat = CalendarFormat.month;
    _focusedDay = DateTime.now();
    _selectedDay = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10.0),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(16.0)),
        color: const Color.fromARGB(255, 255, 255, 255),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.43),
            offset: const Offset(0, 2),
            blurRadius: 2,
          ),
        ],
      ),
      child: TableCalendar(
        firstDay: DateTime.utc(2020, 1, 1),
        lastDay: DateTime.utc(2030, 12, 31),
        focusedDay: _focusedDay,
        calendarFormat: _calendarFormat,
        selectedDayPredicate: (day) {
          return isSameDay(_selectedDay, day);
        },
        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
            // Call the method to filter events based on the selected date
            _filterEventsByDate(selectedDay);
          });
        },
      ),
    );
  }

  void _filterEventsByDate(DateTime date) {
    final parentState = context.findAncestorStateOfType<_CalendarSettingsState>();
    parentState?._filterEventsByDate(date);
  }
}



class AddEventScreen extends StatefulWidget {
  final String name;
  final String contact;

  AddEventScreen({required this.name, required this.contact});

  @override
  _AddEventScreenState createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  TextEditingController _descriptionController = TextEditingController();
  bool addToCalendar = false;
  int selectedDay = 1;
  int selectedMonth = 1;
  int selectedYear = 2024;
  String _csrfToken = '';
  String _xsrfToken = '';
  String _modicareSession = '';
  String _selectedEventType = '0'; // Define the selected event type variable
  String _selectedTime = ''; // Initialize without a default value

  List<String> generateTimeList() {
    List<String> timeList = [];
    for (int i = 0; i < 24; i++) {
      String hour = i < 10 ? '0$i' : '$i';
      timeList.add('$hour:00:00');
    }
    return timeList;
  }

  @override
  void initState() {
    super.initState();
    String initialText = '';
    if (widget.name.isNotEmpty && widget.contact.isNotEmpty) {
      initialText = 'Name: ${widget.name}\nContact: ${widget.contact}\n\n';
    }
    _descriptionController.text = initialText;

    // Fetch CSRF token and other tokens when the screen initializes
    _fetchCsrfToken();

    // Set a default time value
    _selectedTime = generateTimeList().first;
  }

  Future<void> _fetchCsrfToken() async {
    final response = await http.get(
        Uri.parse('https://mdash.gprlive.com/api/csrf-token'));
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
          _xsrfToken =
              RegExp(r'XSRF-TOKEN=([^;]+)').firstMatch(cookies)?.group(1) ?? '';
          _modicareSession =
              RegExp(r'modicare_session=([^;]+)').firstMatch(cookies)?.group(
                  1) ?? '';
        });
      }
    } else {
      print('Failed to fetch CSRF token');
    }
  }

  Future<void> _sendEventData(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String mcaNumber = prefs.getString('mcaNumber') ?? '';

    // Check if tokens are empty and handle the scenario
    if (_csrfToken.isEmpty || _xsrfToken.isEmpty || _modicareSession.isEmpty) {
      print('Tokens are empty. Unable to make the request.');
      return;
    }

    // Get current time in "HH:mm:ss" format
    String currentTime = DateFormat('HH:mm:ss').format(DateTime.now());

    // Prepare headers
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'X-CSRF-TOKEN': _csrfToken,
      'Cookie': 'XSRF-TOKEN=$_xsrfToken; modicare_session=$_modicareSession',
    };

// Prepare request body
    Map<String, dynamic> requestBody = {
      'Calendar': [
        {
          'mca': mcaNumber,
          'dtime': '${selectedYear.toString().padLeft(4, '0')}-'
              '${selectedMonth.toString().padLeft(2, '0')}-'
              '${selectedDay.toString().padLeft(2, '0')} $_selectedTime',
          'type': _selectedEventType, // Use the selected event type
          'description': _descriptionController.text.trim(),
        }
      ]
    };


    // Print the data being sent
    print('Request Headers:');
    print(headers);
    print('Request Body:');
    print(requestBody);

    // Send PUT request to save the event
    final response = await http.put(
      Uri.parse('https://mdash.gprlive.com/api/Calendar/save'),
      headers: headers,
      body: jsonEncode(requestBody),
    );

    // Handle the response
    if (response.statusCode == 200) {
      // Show a SnackBar message on success
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Event saved successfully.'),
          backgroundColor: Colors.black, // Set the background color to black
          duration: Duration(seconds: 2), // Optional: Set duration for the message
        ),
      );

      // Handle success, navigate to a success screen or perform any other action
    } else {
      print('Failed to save event. Status code: ${response.statusCode}');
      // Handle failure, show an error message
    }
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
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
                              ),
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
                      ],
                    ),
                    SizedBox(height: 10.0),
                    Padding(
                      padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Add Event',
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

              SizedBox(height: 10.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  'Select Date',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 10.0),
              // Dropdowns, text fields, checkboxes, buttons, etc. continue here
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Container(
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween, // Adjust alignment as needed
                    children: [
                      Expanded(
                        child: Center(
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.25, // Adjust width as needed
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24.0),
                              border: Border.all(color: Colors.black),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<int>(
                                value: selectedDay,
                                onChanged: (value) {
                                  setState(() {
                                    selectedDay = value!;
                                  });
                                },
                                style: TextStyle(color: Colors.black),
                                items: List.generate(
                                  31,
                                      (index) => DropdownMenuItem<int>(
                                    value: index + 1,
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 8.0), // Adjust padding as needed
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('${index + 1}'),
                                          SizedBox(width: 10), // Add padding between value and border
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                      ),
                      SizedBox(width: 10.0),
                      Expanded(
                        child: Center(
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.25, // Adjust width as needed
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24.0),
                              border: Border.all(color: Colors.black),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<int>(
                                value: selectedMonth,
                                onChanged: (value) {
                                  setState(() {
                                    selectedMonth = value!;
                                  });
                                },
                                style: TextStyle(color: Colors.black),
                                items: List.generate(
                                  12,
                                      (index) => DropdownMenuItem<int>(
                                    value: index + 1,
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 8.0), // Adjust padding as needed
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('${index + 1}'),
                                          SizedBox(width: 10), // Add padding between value and border
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10.0),
                      Expanded(
                        child: Center(
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.25, // Adjust width as needed
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24.0),
                              border: Border.all(color: Colors.black),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<int>(
                                value: selectedYear,
                                onChanged: (value) {
                                  setState(() {
                                    selectedYear = value!;
                                  });
                                },
                                style: TextStyle(color: Colors.black),
                                items: List.generate(
                                  10,
                                      (index) => DropdownMenuItem<int>(
                                    value: 2024 + index,
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 8.0), // Adjust padding as needed
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('${2024 + index}'),
                                          SizedBox(width: 10), // Add padding between value and border
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 20.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  'Select Time',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 10.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24.0),
                    border: Border.all(color: Colors.black),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedTime,
                      onChanged: (value) {
                        setState(() {
                          _selectedTime = value!;
                        });
                      },
                      style: TextStyle(color: Colors.black),
                      items: generateTimeList().map((time) {
                        return DropdownMenuItem<String>(
                          value: time, // Ensure each value is unique
                          child: Padding(
                            padding: EdgeInsets.only(left: 8.0, right: 8.0),
                            child: Text(time),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 20.0),
              // Event type dropdown
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: DropdownButtonFormField<String>(
                  value: _selectedEventType,
                  onChanged: (value) {
                    setState(() {
                      _selectedEventType = value!; // Set the selected event type
                    });
                  },
                  items: [
                    DropdownMenuItem<String>(
                      value: '0',
                      child: Text('Select event'),
                    ),
                    DropdownMenuItem<String>(
                      value: '1',
                      child: Text('Product Training'),
                    ),
                    DropdownMenuItem<String>(
                      value: '2',
                      child: Text('Business Training'),
                    ),
                    DropdownMenuItem<String>(
                      value: '3',
                      child: Text('Home Meeting'),
                    ),
                    DropdownMenuItem<String>(
                      value: '4',
                      child: Text('Plan Presentation'),
                    ),
                    DropdownMenuItem<String>(
                      value: '5',
                      child: Text('Jashn-e-Azadi'),
                    ),
                    DropdownMenuItem<String>(
                      value: '6',
                      child: Text('Parivartan'),
                    ),
                    DropdownMenuItem<String>(
                      value: '7',
                      child: Text('Raftaar'),
                    ),
                    DropdownMenuItem<String>(
                      value: '8',
                      child: Text('Udaan'),
                    ),
                  ],
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: BorderSide(
                        color: Color(0xFF17a2b8),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              // Description text field
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0), // Adjust the horizontal padding as needed
                child: TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    hintText: 'Description',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: BorderSide(
                        color: Color(0xFF17a2b8),
                      ),
                    ),
                  ),
                  maxLines: 6,
                ),
              ),
            SizedBox(height: 20.0),
            // Checkbox for adding to calendar
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0), // Adjust the horizontal padding as needed
                child: Row(
                  children: [
                    Checkbox(
                      value: addToCalendar,
                      onChanged: (value) {
                        setState(() {
                          addToCalendar = value!;
                        });
                      },
                    ),
                    Text('Add to My Calendar'),
                  ],
                ),
              ),

            SizedBox(height: 20.0),
            // Buttons for "Done" and "Cancel"
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _sendEventData(context); // Pass the context to the method
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Color(0xFF0396FE), backgroundColor: Colors.white,                    ),
                    child: Text('Save Event'),
                  ),
                  SizedBox(width: 20.0),
                  OutlinedButton(
                    onPressed: () {
                      // Add your functionality here for canceling the event
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.black, side: BorderSide(color: Colors.blue), // Border color
                    ),
                    child: Text('Cancel'),
                  ),
                ],
              )

            ],
          ),
        ),
      ),
    );
  }
}