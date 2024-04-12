import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarSettings extends StatelessWidget {
  const CalendarSettings({Key? key}) : super(key: key);

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
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(20.0),
                      bottomRight: Radius.circular(20.0),
                    ),
                    color: const Color.fromARGB(255, 255, 255, 255),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.43),
                        offset: const Offset(0, 1),
                        blurRadius: 2,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              'ᐸ  Back',
                              style: TextStyle(
                                color: Color(0xFF0396FE),
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Text(
                            'My calendar',
                            style: TextStyle(
                              color: Color.fromARGB(255, 40, 40, 40),
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 60),
                        ],
                      ),
                      SizedBox(height: 10.0),
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
                          MaterialPageRoute(builder: (context) => AddEventScreen()),
                        );
                      },
                      child: Text('+ Add Event'),
                    ),
                    SizedBox(width: 16.0),
                  ],
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
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20.0),
          bottomRight: Radius.circular(20.0),
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
        color: const Color.fromARGB(255, 255, 255, 255),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.43),
            offset: const Offset(0, 1),
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
          });
        },
      ),
    );
  }
}




class AddEventScreen extends StatefulWidget {
  @override
  _AddEventScreenState createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  int selectedYear = 2024; // Variable to track the selected year, initialized with a default value of 2024
  bool addToCalendar = false; // Variable to track whether the checkbox is checked or not

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Unfocus the keyboard when tapping on the blank area
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: SafeArea(
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
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context); // Go back to the previous page
                    },
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'ᐸ  Back',
                        style: TextStyle(
                          color: Color(0xFF0396FE),
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0), // Added some space between the back button and other content
                  SizedBox(height: 40.0),
                  Text(
                    'Add Event',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20.0),
                  Text(
                    'Select Date',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10.0),
                  // Year selection row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            selectedYear = 2024;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: selectedYear == 2024 ? Color(0xFF0396FE) : Colors.transparent,
                                width: 2.0,
                              ),
                            ),
                          ),
                          child: Text('2024'),
                        ),
                      ),
                      SizedBox(width: 20.0),
                      InkWell(
                        onTap: () {
                          setState(() {
                            selectedYear = 2025;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: selectedYear == 2025 ? Color(0xFF0396FE) : Colors.transparent,
                                width: 2.0,
                              ),
                            ),
                          ),
                          child: Text('2025'),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.0),
                  // Month, day, and time selection rows
                  Row(
                    children: [
                      Flexible(
                        flex: 4,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 12.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30.0),
                            border: Border.all(color: Color(0xFF17a2b8)),
                          ),
                          child: SizedBox(
                            width: double.infinity, // Constraint the width to fill the available space
                            child: DropdownButtonFormField<int>(
                              value: 1,
                              onChanged: (value) {},
                              items: List.generate(
                                12,
                                    (index) => DropdownMenuItem<int>(
                                  value: index + 1,
                                  child: Text(_getMonthName(index + 1)),
                                ),
                              ),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10.0),
                      Flexible(
                        flex: 2,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 12.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30.0),
                            border: Border.all(color: Color(0xFF17a2b8)),
                          ),
                          child: DropdownButtonFormField<int>(
                            value: 1,
                            onChanged: (value) {},
                            items: List.generate(
                              31,
                                  (index) => DropdownMenuItem<int>(
                                value: index + 1,
                                child: Text('${index + 1}'),
                              ),
                            ),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10.0),
                      Flexible(
                        flex: 3,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 12.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30.0),
                            border: Border.all(color: Color(0xFF17a2b8)),
                          ),
                          child: DropdownButtonFormField<int>(
                            value: 8,
                            onChanged: (value) {},
                            items: List.generate(
                              24,
                                  (index) => DropdownMenuItem<int>(
                                value: index + 1,
                                child: Text('${index + 1}:00'),
                              ),
                            ),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 20.0),
                  // Event type dropdown
                  DropdownButtonFormField<String>(
                    value: '0',
                    onChanged: (value) {},
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
                  SizedBox(height: 20.0),
                  // Description text field
                  TextFormField(
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
                  SizedBox(height: 20.0),
                  // Checkbox for adding to calendar
                  Row(
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
                  SizedBox(height: 20.0),
                  // Buttons for "Done" and "Cancel"
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {},
                        child: Text('Done'),
                      ),
                      SizedBox(width: 20.0),
                      OutlinedButton(
                        onPressed: () {},
                        child: Text('Cancel'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _getMonthName(int month) {
    switch (month) {
      case 1:
        return 'January';
      case 2:
        return 'February';
      case 3:
        return 'March';
      case 4:
        return 'April';
      case 5:
        return 'May';
      case 6:
        return 'June';
      case 7:
        return 'July';
      case 8:
        return 'August';
      case 9:
        return 'September';
      case 10:
        return 'October';
      case 11:
        return 'November';
      case 12:
        return 'December';
      default:
        return '';
    }
  }
}



void main() {
  runApp(const MaterialApp(
    home: CalendarSettings(),
  ));
}
