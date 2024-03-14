import 'package:flutter/material.dart';
import 'dashboard_screen.dart';
import 'academy_screen.dart';
import 'roadmap_screen.dart';
import 'notifications_screen.dart';
import 'profile_screen.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  // Define your screens here
  final List<Widget> _screens = [
    DashboardScreen(),
    AcademyScreen(),
    RoadmapScreen(),
    NotificationsScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: _selectedIndex == 0
                ? Image.network(
              'https://rtfapi.modicare.com/img/HomeIconSelected@2x.png',
              height: 24, // Adjust the height as needed
            )
                : Image.network(
              'https://rtfapi.modicare.com/img/Home.png',
              height: 24, // Adjust the height as needed
            ),
            label: '', // Empty label
          ),
          BottomNavigationBarItem(
            icon: _selectedIndex == 1
                ? Image.network(
              'https://rtfapi.modicare.com/img/SchoolSelected@2x.png',
              height: 24, // Adjust the height as needed
            )
                : Image.network(
              'https://rtfapi.modicare.com/img/schoolunselected.png',
              height: 24, // Adjust the height as needed

            ),
            label: '', // Empty label
          ),
          BottomNavigationBarItem(
            icon: _selectedIndex == 2
                ? Image.network(
              'https://rtfapi.modicare.com/img/RoadMapSelected@2x.png',
              height: 24, // Adjust the height as needed
            )
                : Image.network(
              'https://rtfapi.modicare.com/img/roadmap.png',
              height: 24, // Adjust the height as needed
            ),
            label: '', // Empty label
          ),
          BottomNavigationBarItem(
            icon: Stack(
              children: [
                _selectedIndex == 3
                    ? Image.network(
                  'https://rtfapi.modicare.com/img/NotificationSelected@2x.png',
                  height: 24, // Adjust the height as needed
                )
                    : Image.network(
                  'https://rtfapi.modicare.com/img/Notification.png',
                  height: 24, // Adjust the height as needed
                ),
                Positioned(
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    constraints: BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      '30',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
            label: '', // Empty label
          ),
          BottomNavigationBarItem(
            icon: _selectedIndex == 4
                ? Image.network(
              'https://rtfapi.modicare.com/img/ProfileSelected@2x.png',
              height: 24, // Adjust the height as needed
            )
                : Image.network(
              'https://rtfapi.modicare.com/img/profile.png',
              height: 24, // Adjust the height as needed
            ),
            label: '', // Empty label
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Color(0xFF535353),
        unselectedItemColor: Color(0xFF535353),
        onTap: _onItemTapped,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
