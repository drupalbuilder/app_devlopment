import 'package:flutter/material.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  bool _soundEnabled = true;
  bool _vibrationEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back,
                          color: Color.fromARGB(255, 40, 40, 40)),
                      onPressed: () {
                        Navigator.pop(context); // Navigate back when pressed
                      },
                    ),
                    const Text(
                      'App Setting',
                      style: TextStyle(
                        color: Color.fromARGB(255, 40, 40, 40),
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
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
                    SwitchListTile(
                      title: const Text('Sound'),
                      value: _soundEnabled,
                      onChanged: (bool value) {
                        setState(() {
                          _soundEnabled = value;
                        });
                      },
                    ),
                    SwitchListTile(
                      title: const Text('Vibration'),
                      value: _vibrationEnabled,
                      onChanged: (bool value) {
                        setState(() {
                          _vibrationEnabled = value;
                        });
                      },
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
