import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart'; // Import Cupertino library

class ToggleButton extends StatelessWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  final Color activeColor;
  final Color inactiveColor;

  const ToggleButton({
    Key? key,
    required this.value,
    this.onChanged,
    required this.activeColor,
    required this.inactiveColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoSwitch(
      value: value,
      onChanged: onChanged,
      activeColor: activeColor,
      trackColor: inactiveColor,
    );
  }
}

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  bool _soundEnabled = true;
  bool _vibrationEnabled = true;

  Color activeColor = Colors.blue; // Change this to your desired color
  Color inactiveColor = Colors.grey;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
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
                      padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0), // Padding top and bottom
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'App Setting',
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
              Container(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Notification',
                      style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                    ListTile(
                      title: const Text('Sound'),
                      trailing: ToggleButton(
                        value: _soundEnabled,
                        onChanged: (bool value) {
                          setState(() {
                            _soundEnabled = value;
                          });
                        },
                        activeColor: activeColor,
                        inactiveColor: inactiveColor,
                      ),
                    ),
                    ListTile(
                      title: const Text('Vibration'),
                      trailing: ToggleButton(
                        value: _vibrationEnabled,
                        onChanged: (bool value) {
                          setState(() {
                            _vibrationEnabled = value;
                          });
                        },
                        activeColor: activeColor,
                        inactiveColor: inactiveColor,
                      ),
                    ),
                    // Text Size section (which is currently hidden)
                    // Uncomment if you want to use this section
                    // SizedBox(height: 20.0),
                    // Text(
                    //   'Text Size',
                    //   style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                    // ),
                    // ListTile(
                    //   title: Text('Regular'),
                    // ),
                    const SizedBox(height: 20.0),
                    const Text(
                      'Security',
                      style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                    ListTile(
                      title: const Text('Reset My Password'),
                      onTap: () {
                        // Handle reset password action
                      },
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
}

void main() {
  runApp(const MaterialApp(
    home: SettingPage(),
  ));
}


