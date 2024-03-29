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
import 'mainscreen.dart';
import 'profiledetails.dart';
import 'infoscreen.dart';
import 'privacy&policy.dart';
import 'setting.dart';
import 'terms&use.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFDFDFDFF),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Stack(
                children: [
                  Container(
                    height: 300,
                    child: ImageSlider(
                      imageUrls: [
                        'https://rtfapi.modicare.com/assets/dgallery/2/2-1.jpeg',
                        'https://rtfapi.modicare.com/assets/dgallery/2/2-1.jpeg',
                        'https://rtfapi.modicare.com/img/SignatureWithLogo@3x.png',

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
                        padding: EdgeInsets.symmetric(horizontal: 0),
                        alignment: Alignment.topCenter,
                        child: Stack(
                          children: [
                            Image.network(
                              'https://rtfapi.modicare.com/img/curve@3x.png',
                              height: 500,
                              fit: BoxFit.contain,
                            ),
                            Positioned(
                              top: 20,
                              right: 20,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => Managedreams()));
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                  child: Text(
                                    'Manage Dreams',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
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
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) => CalendarSettings()),
                                          );
                                        },
                                        child: Image.network(
                                          'https://rtfapi.modicare.com/img/calendar@3x.png',
                                          width: 24,
                                          height: 24,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        'Calendar',
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 12,
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
                                            MaterialPageRoute(builder: (context) => LoginScreen()),
                                          );
                                        },
                                        child: Image.network(
                                          'https://rtfapi.modicare.com/img/logout@3x.png',
                                          width: 24,
                                          height: 24,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        'logout',
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),


                                ],
                              ),
                            ),
                            Positioned(
                              top: 80,
                              left: MediaQuery.of(context).orientation == Orientation.portrait
                                  ? (MediaQuery.of(context).size.width - 90) / 2 // Center horizontally for portrait
                                  : (MediaQuery.of(context).size.width - 90) / 2, // Center horizontally for landscape
                              child: Container(
                                width: 90, // assuming this is the width for portrait mode
                                height: 90,
                                decoration: BoxDecoration(
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
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  children: [
                    Text(
                      'CONSULTANT',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: Column(
                        children: [
                          Row(
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
                          SizedBox(height: 10),
                          Container(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                // Add your action here
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF01aafe),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: Text('Income Goal Setting'),
                            ),
                          ),
                          SizedBox(height: 10),
                          Container(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => PlayWinScreen()),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF01aafe),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: Text('Play & Win'),
                            ),
                          ),
                          SizedBox(height: 50),
                          ListView(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            children: [
                              GestureDetector(
                                onTap: () {
                                  // Navigate to Family Info screen
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => Profiledetails()));
                                },
                                child: _buildListItem('My Profile', context),
                              ),
                              GestureDetector(
                                onTap: () {
                                  // Navigate to Family Info screen
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => FamilyInfoScreen()));
                                },
                                child: _buildListItem('Family Info', context),
                              ),
                              GestureDetector(
                                onTap: () {
                                  // Navigate to Family Info screen
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => Documents()));
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
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        // Add your action for Terms of Use here
                      },
                      child: Text(
                        'Terms of Use',
                        style: TextStyle(
                          color: Color(0xFF09f),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        // Add your action for Privacy Policy here
                      },
                      child: Text(
                        'Privacy Policy',
                        style: TextStyle(
                          color: Color(0xFF09f),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildCircularIconButton(Icons.question_answer, Colors.blue, () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => InfoScreen()));    // Add your FAQ action here
                  }, 'FAQ'),
                  _buildCircularIconButton(Icons.settings, Colors.blue, () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => SettingPage()));
                  }, 'Settings'),
                  _buildCircularIconButton(Icons.contact_phone, Colors.blue, () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ContactUsApp())); // Add your contact action here
                  }, 'Contact'),
                  _buildCircularIconButton(Icons.report, Colors.blue, () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ReportScreen()));  // Add your app settings action here
                  }, 'Report'),
                ],
              ),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.only(top: 14),
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
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.only(bottom: 50),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => TermsAndPolicyScreen()),
                        );
                      },
                      child: Text(
                        'Terms of Use',
                        style: TextStyle(
                          color: Color(0xFF1FA2FF),
                        ),
                      ),
                    ),
                    SizedBox(width: 20), // Adjust the width as needed
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => PrivacyAndPolicyScreen()),
                        );
                      },
                      child: Text(
                        'Privacy of Use',
                        style: TextStyle(
                          color: Color(0xFF1FA2FF),
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
      padding: EdgeInsets.only(bottom: 10, top: 10, left: 16, right: 16),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey, width: 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              color: Colors.black,
              fontWeight: FontWeight.normal,
            ),
          ),
          Image.network(
            'https://rtfapi.modicare.com/img/detailArrow@3x.png',
            width: 20,
            height: 20,
          ),
        ],
      ),
    );
  }

  Widget _buildCircularIconButton(IconData icon, Color color, VoidCallback onPressed, String label) {
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
        SizedBox(height: 4),
        Text(label),
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

    Timer.periodic(Duration(seconds: 3), (Timer timer) {
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
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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