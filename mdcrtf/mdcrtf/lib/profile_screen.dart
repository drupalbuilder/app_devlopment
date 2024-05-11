import 'dart:async';
import 'package:flutter/material.dart';
import 'package:t2t1/reportscreen.dart';
import 'FamilyInfo.dart';
import 'Managedreams.dart';
import 'PlayWin.dart';
import 'adddocuments.dart';
import 'calander.dart';
import 'contactUS.dart';
import 'main.dart';
import 'profiledetails.dart';
import 'infoscreen.dart';
import 'privacy&policy.dart';
import 'setting.dart';
import 'terms&use.dart';
import 'income_goal_setting.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfffdfdfdff),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Stack(
                children: [
                  const SizedBox(
                    height: 300,
                    child: ImageSlider(
                      imageUrls: [
                        'https://rtfapi.modicare.com/assets/dgallery/2/2-1.jpeg',
                        'https://rtfapi.modicare.com/assets/dgallery/2/2-1.jpeg',
                        // Additional image URL
                        // Add more image URLs if needed
                      ],
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 0),
                        alignment: Alignment.topCenter,
                        child: Stack(
                          children: [
                            Image.network(
                              'https://rtfapi.modicare.com/img/curve@3x.png',
                              height: 520,
                              fit: BoxFit.contain,
                            ),
                            Positioned(
                              top: 20,
                              right: 20,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(
                                      builder: (context) => Managedreams()));
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  child: Text(
                                    'Manage Dreams',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: const Color(0xff535353),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            Positioned(
                              top: 212,
                              left: 20,
                              right: 20,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceBetween,
                                children: [
                                  Column(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (
                                                context) => const CalendarSettings()),
                                          );
                                        },
                                        child: Image.network(
                                          'https://rtfapi.modicare.com/img/calendar@3x.png',
                                          width: 24,
                                          height: 24,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      const Text(
                                        'Calendar',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    LoginScreen()),
                                          );
                                        },
                                        child: Image.network(
                                          'https://rtfapi.modicare.com/img/logout@3x.png',
                                          width: 24,
                                          height: 24,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      const Text(
                                        'logout',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),


                                ],
                              ),
                            ),
                            Positioned(
                              top: 100,
                              left: MediaQuery
                                  .of(context)
                                  .orientation == Orientation.portrait
                                  ? (MediaQuery
                                  .of(context)
                                  .size
                                  .width - 90) /
                                  2 // Center horizontally for portrait
                                  : (MediaQuery
                                  .of(context)
                                  .size
                                  .width - 90) / 2,
                              // Center horizontally for landscape
                              child: Container(
                                width: 90,
                                // assuming this is the width for portrait mode
                                height: 90,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 10),
                child: Column(
                  children: [
                    Column(
                      children: [
                        Text(
                          'Mohammad Mustafa',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w900, // Increased font weight for a bolder effect
                          ),
                        ),

                        SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 0),
                          child: Column(
                            children: [
                              Text(
                                'CONSULTANT',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: Column(
                        children: [
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '130',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 5),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Azadi',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFFffc73d),
                                    ),
                                  ),
                                  Text(
                                    'pts',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              SizedBox(height: 10),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => IncomeGoals()),
                                    ); // Add your action here
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF01aafe),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    foregroundColor: Colors.white,
                                  ),
                                  child: Text(
                                    'Income Goal Setting',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              SizedBox(height: 10),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) =>
                                          PlayWinScreen()),
                                    ); // Add your action here
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF01aafe),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    foregroundColor: Colors.white,
                                  ),
                                  child: Text(
                                    'Play & Win',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 50),
                          ListView(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            children: [
                              GestureDetector(
                                onTap: () {
                                  // Navigate to Family Info screen
                                  Navigator.push(context, MaterialPageRoute(
                                      builder: (context) => Profiledetails()));
                                },
                                child: _buildListItem('My Profile', context),
                              ),
                              GestureDetector(
                                onTap: () {
                                  // Navigate to Family Info screen
                                  Navigator.push(context, MaterialPageRoute(
                                      builder: (context) =>
                                          FamilyInfoScreen()));
                                },
                                child: _buildListItem('Family Info', context),
                              ),
                              GestureDetector(
                                onTap: () {
                                  // Navigate to Family Info screen
                                  Navigator.push(context, MaterialPageRoute(
                                      builder: (context) => Documents()));
                                },
                                child: _buildListItem('Documents', context),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildCircularIconButton(
              Icons.question_answer,
              Colors.blue,
                  () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => InfoScreen(),
                ));
              },
              'FAQ',
              TextStyle(
                fontSize: 16,
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
            _buildCircularIconButton(
              Icons.settings,
              Colors.blue,
                  () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => const SettingPage(),
                ));
              },
              'Settings',
              TextStyle(
                fontSize: 16,
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
            _buildCircularIconButton(
              Icons.contact_phone,
              Colors.blue,
                  () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => ContactUsApp(),
                ));
              },
              'Contact',
              TextStyle(
                fontSize: 16,
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
            _buildCircularIconButton(
              Icons.report,
              Colors.blue,
                  () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => ReportScreen(),
                ));
              },
              'Report',
              TextStyle(
                fontSize: 16,
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.only(top: 14),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.network(
                      'https://rtfapi.modicare.com/img/SignatureWithLogo@3x.png',
                      width: 300, // Adjust width as needed
                      height: 100, // Adjust height as needed
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.only(bottom: 50),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (
                              context) => const TermsAndPolicyScreen()),
                        );
                      },
                      child: const Text(
                        'Terms of Use',
                        style: TextStyle(
                          color: Color(0xFF1FA2FF),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 20), // Adjust the width as needed
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) =>
                              PrivacyAndPolicyScreen()),
                        );
                      },
                      child: const Text(
                        'Privacy of Use',
                        style: TextStyle(
                          color: Color(0xFF1FA2FF),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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

  Widget _buildListItem(String title, BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 10, top: 10, left: 0, right: 0),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey, width: 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              color: const Color(0xff535353),
              fontWeight: FontWeight.bold,
            ),
          ),
          Icon(
            Icons.arrow_forward_ios, // Change this to the desired arrow icon
            size: 20,
            color: Colors.blue, // Adjust the color as needed
          ),
        ],
      ),
    );
  }


  Widget _buildCircularIconButton(IconData icon,
      Color color,
      VoidCallback onPressed,
      String label,
      TextStyle labelStyle,) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
          child: IconButton(
            icon: Icon(icon, color: Colors.white),
            onPressed: onPressed,
          ),
        ),
        const SizedBox(height: 14),
        Text(
          label,
          style: labelStyle, // Apply the TextStyle to the Text widget
        ),
      ],
    );
  }
}



class ImageSlider extends StatefulWidget {
  final List<String> imageUrls;

  const ImageSlider({Key? key, required this.imageUrls}) : super(key: key);

  @override
  _ImageSliderState createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {
  late PageController _pageController;
  int _currentPage = 0;
  bool _forward = true;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);

    Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (_forward) {
        if (_currentPage < widget.imageUrls.length - 1) {
          _currentPage++;
        } else {
          _forward = false;
        }
      } else {
        if (_currentPage > 0) {
          _currentPage--;
        } else {
          _forward = true;
        }
      }
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200, // Adjust height as needed
      child: PageView.builder(
        controller: _pageController,
        itemCount: widget.imageUrls.length,
        itemBuilder: (BuildContext context, int index) {
          return Image.network(
            widget.imageUrls[index],
            fit: BoxFit.cover,
          );
        },
        onPageChanged: (int page) {
          setState(() {
            _currentPage = page;
          });
        },
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}