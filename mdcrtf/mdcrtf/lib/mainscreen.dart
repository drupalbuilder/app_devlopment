import 'package:flutter/material.dart';
import 'dashboard_screen.dart';
import 'academy_screen.dart';
import 'roadmap_screen.dart';
import 'notifications_screen.dart';
import 'profile_screen.dart';

class HomeIcon extends StatelessWidget {
  final String activeImageUrl;
  final String inactiveImageUrl;
  final bool isActive;
  final double width;
  final double height;

  const HomeIcon({
    required this.activeImageUrl,
    required this.inactiveImageUrl,
    required this.isActive,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Image.network(
        isActive ? activeImageUrl : inactiveImageUrl,
        width: width,
        height: height,
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen();

  @override
  _BottomBarScreenState createState() => _BottomBarScreenState();
}

class _BottomBarScreenState extends State<MainScreen> {
  late List<Map<String, Widget>> _pages;
  int _selectedPageIndex = 0;

  @override
  void initState() {
    _pages = [
      {
        'page': DashboardScreen(),
      },
      {
        'page': const AcademyScreen(),
      },
      {
        'page': const RoadmapScreen(),
      },
      {
        'page': const NotificationsScreen(),
      },
      {
        'page': const ProfileScreen(),
      },
    ];

    // Set the initial selected page index to the index of RoadmapScreen
    _selectedPageIndex = 2;

    super.initState();
  }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedPageIndex]['page']!,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, // Fixed type to prevent shifting
        onTap: _selectPage,
        backgroundColor: Colors.white,
        unselectedItemColor: Theme.of(context).textTheme.bodyLarge!.color,
        selectedItemColor: Colors.blue,
        currentIndex: _selectedPageIndex,
        items: [
          BottomNavigationBarItem(
            icon: HomeIcon(
              activeImageUrl:
              'https://rtfapi.modicare.com/img/HomeIconSelected@2x.png',
              inactiveImageUrl:
              'https://rtfapi.modicare.com/img/Home.png',
              isActive: _selectedPageIndex == 0,
              width: 24, // Set the desired width
              height: 24, // Set the desired height
            ),
            label: '', // No label
          ),
          BottomNavigationBarItem(
            icon: HomeIcon(
              activeImageUrl:
              'https://rtfapi.modicare.com/img/SchoolSelected@2x.png',
              inactiveImageUrl:
              'https://rtfapi.modicare.com/img/schoolunselected.png',
              isActive: _selectedPageIndex == 1,
              width: 24, // Set the desired width
              height: 24, // Set the desired height
            ),
            label: '', // No label
          ),
          BottomNavigationBarItem(
            icon: const Icon(null), // No icon
            label: '', // No label
          ),
          BottomNavigationBarItem(
            icon: HomeIcon(
              activeImageUrl:
              'https://rtfapi.modicare.com/img/NotificationSelected@2x.png',
              inactiveImageUrl:
              'https://rtfapi.modicare.com/img/Notification.png',
              isActive: _selectedPageIndex == 3,
              width: 24, // Set the desired width
              height: 24, // Set the desired height
            ),
            label: '', // No label
          ),
          BottomNavigationBarItem(
            icon: HomeIcon(
              activeImageUrl:
              'https://rtfapi.modicare.com/img/ProfileSelected@2x.png',
              inactiveImageUrl:
              'https://rtfapi.modicare.com/img/profile.png',
              isActive: _selectedPageIndex == 4,
              width: 24, // Set the desired width
              height: 24, // Set the desired height
            ),
            label: '', // No label
          ),
        ],
      ),
      floatingActionButtonLocation:
      FloatingActionButtonLocation.miniCenterDocked,
      floatingActionButton: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white, // Background color
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 5.0,
              spreadRadius: 1.0,
            ),
          ],
        ),
       child: FloatingActionButton(
        hoverElevation: 0,
        backgroundColor: Colors.transparent, // Make FAB transparent
        splashColor: Colors.transparent, // Remove splash color
        elevation: 0, // No elevation for inner FAB
        child: Image.network(
          _selectedPageIndex == 2
              ? 'https://rtfapi.modicare.com/img/RoadMapSelected@2x.png'
              : 'https://rtfapi.modicare.com/img/roadmap.png',
          width: 26, // Set the desired width
          height: 26, // Set the desired height
        ),
        onPressed: () => setState(() {
          _selectedPageIndex = 2;
        }),
      ),

    ),
    );
  }
}
