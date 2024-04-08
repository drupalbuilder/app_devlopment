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

  const HomeIcon({super.key,
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
  const MainScreen({super.key});

  @override
  _BottomBarScreenState createState() => _BottomBarScreenState();
}

class _BottomBarScreenState extends State<MainScreen> {
  late List<Map<String, Widget>> _pages;
  int _selectedPageIndex = 0;
  bool _isRoadmapScreenActive = false;

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
    super.initState();
  }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
      _isRoadmapScreenActive = (index == 2);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedPageIndex]['page']!,
      bottomNavigationBar: BottomAppBar(
        color: Colors.white, // Background color
        shape: const CircularNotchedRectangle(),
        notchMargin: 0.01,
        clipBehavior: Clip.antiAlias,
        child: SizedBox(
          height: kBottomNavigationBarHeight * 0.98,
          child: BottomNavigationBar(
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
              const BottomNavigationBarItem(
                // Use appropriate icon, in this case, no icon is used
                icon: Icon(null),
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
        ),
      ),
      floatingActionButtonLocation:
      FloatingActionButtonLocation.miniCenterDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FloatingActionButton(
          hoverElevation: 22,
          backgroundColor: Colors.white,
          splashColor: Colors.transparent, // Remove splash color
          tooltip: 'Search',
          elevation: 4,
          child: Image.network(
            _isRoadmapScreenActive
                 ? 'https://rtfapi.modicare.com/img/RoadMapSelected@2x.png'
                : 'https://rtfapi.modicare.com/img/roadmap.png',
            width: 24, // Set the desired width
            height: 24, // Set the desired height
          ),
          onPressed: () => setState(() {
            _selectedPageIndex = 2;
            _isRoadmapScreenActive = true; // Update the variable when pressing the floating button
          }),
        ),
      ),
    );
  }
}
