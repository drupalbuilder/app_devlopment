import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'camera_app.dart';
import 'video_list_screen.dart';
import 'video_player_screen.dart';
import 'profile_screen.dart';
import 'reports_screen.dart';

class LandingPageWithVideoCount extends StatefulWidget {
  const LandingPageWithVideoCount({Key? key}) : super(key: key);

  @override
  _LandingPageWithVideoCountState createState() =>
      _LandingPageWithVideoCountState();
}

class _LandingPageWithVideoCountState
    extends State<LandingPageWithVideoCount> {
  late int _videoCount;
  late List<Future<VideoData>> _latestVideos;

  @override
  void initState() {
    super.initState();
    _videoCount = 0;
    _latestVideos = [];
    _loadVideoCount();
    _loadLatestVideos();
  }

  Future<void> _loadVideoCount() async {
    final appDirectory = await getApplicationDocumentsDirectory();
    final videosDirectory = Directory('${appDirectory.path}/videos');
    final files = videosDirectory.listSync();

    setState(() {
      _videoCount = files
          .where((file) => file.path.endsWith('.mp4'))
          .length;
    });
  }

  Future<void> _loadLatestVideos() async {
    final appDirectory = await getApplicationDocumentsDirectory();
    final videosDirectory = Directory('${appDirectory.path}/videos');
    final files = videosDirectory.listSync().whereType<File>().toList();

    files.sort((a, b) => b.lastModifiedSync().compareTo(a.lastModifiedSync()));

    final latestVideos = files
        .take(6)
        .map((file) => VideoData.fromFile(file))
        .toList();

    setState(() {
      _latestVideos = latestVideos;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Color(0xff50aff1),
                Color(0xFF0071d6),
              ],
            ),
          ),
        ),
        title: Text(
          'Home page ',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          CircleAvatar(
            backgroundImage: AssetImage('assets/profile_dummy_image.jpg'),
          ),
        ],
      ),
      body: Container(
        color: Color(0xFFdfdfdf), // Set background color
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: 20),
                      Text(
                        'Total Videos in Library: $_videoCount',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Latest Videos:',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      _buildLatestVideosGrid(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildBottomNavItem(Icons.home, 'Home', () {
              setState(() {
                _videoCount = 0; // Reset the video count
                _latestVideos = []; // Clear the latest videos list
              });
              _loadVideoCount(); // Reload video count
              _loadLatestVideos(); // Reload latest videos
            }),
            _buildBottomNavItem(Icons.video_library, 'Library', () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const VideoListScreen(),
                ),
              );
            }),
            _buildBottomNavItem(Icons.videocam, 'Record', () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CameraApp()),
              );
            }),
            _buildBottomNavItem(Icons.analytics, 'Reports', () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ReportsScreen()),
              );
            }),
            _buildBottomNavItem(Icons.account_circle, 'Profile', () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfileScreen()),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavItem(IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12),
        // Increase vertical padding
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ShaderMask(
              shaderCallback: (Rect bounds) {
                return LinearGradient(
                  colors: [
                    Color(0xff50aff1),
                    Color(0xFF0071d6),
                  ],
                ).createShader(bounds);
              },
              child: Icon(
                icon,
                size: 32, // Increase icon size
                color: Colors.white,
              ),
            ),
            SizedBox(height: 0), // Increase space between icon and label
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.black,
                fontWeight: FontWeight.bold, // Add bold effect
                //fontWidth: 0.5, // Add font width if needed
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLatestVideosGrid() {
    return _latestVideos.isNotEmpty
        ? FutureBuilder<List<VideoData>>(
      future: Future.wait(_latestVideos),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          final latestVideos = snapshot.data!;
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
              childAspectRatio: 2 / 3,
            ),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: latestVideos.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          VideoPlayerScreen(latestVideos[index]),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 7,
                        offset:
                        Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      FutureBuilder(
                        future: latestVideos[index].thumbnail,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.memory(
                                snapshot.data as Uint8List,
                                fit: BoxFit.cover,
                              ),
                            );
                          } else {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        },
                      ),
                      Positioned.fill(
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      VideoPlayerScreen(
                                          latestVideos[index]),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    )
        : Center(child: CircularProgressIndicator());
  }
}

