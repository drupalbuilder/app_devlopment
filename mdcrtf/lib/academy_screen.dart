import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import 'infoscreen.dart';

class AcademyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set the background color to white
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: double.infinity,
                  height: 80,
                  child: Stack(
                    children: [
                      Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.network(
                            'https://rtfapi.modicare.com/assets/images/spbm.jpeg',
                            width: 150,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => InfoScreen(),
                              ),
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Image.network(
                              'https://rtfapi.modicare.com/assets/images/help.png?act=1',
                              width: 20,
                              height: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.grey,
                        width: 1.0,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Azadi Mantras',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                // First row with border
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(0.0),
                  ),
                  child: Column(
                    children: [
                      Container(
                        height: 160,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            videoItem(
                              context,
                              'Importance of sharing the plan',
                              'https://www.youtube.com/embed/EXSTxzPhQ30?showinfo=0&related=0&enablejsapi=1&autoplay=1&rel=0',
                            ),
                            videoItem(
                              context,
                              '3 tips for the first home meeting',
                              'https://www.youtube.com/embed/JGXJ4gLfVrc?showinfo=0&related=0&enablejsapi=1&autoplay=1&rel=0',
                            ),
                            videoItem(
                              context,
                              'Direct Selling industry for small & medium entrepreneurs',
                              'https://www.youtube.com/embed/8gK9Ai2hTyc?showinfo=0&related=0&enablejsapi=1&autoplay=1&rel=0',
                            ),
                            // Add more videos as needed
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Additional Videos',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                ),
                SizedBox(height: 10),
                // Second row with border
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(0.0),
                  ),
                  child: Column(
                    children: [
                      Container(
                        height: 160,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            videoItem(
                              context,
                              'Modicare Envirochip Training Program 2016',
                              'https://www.youtube.com/embed/cEiqYPToiZQ?showinfo=0&related=0&enablejsapi=1&autoplay=1&rel=0',
                            ),
                            videoItem(
                              context,
                              'Modicare Envoirochip - Animated Demo',
                              'https://www.youtube.com/embed/RoERmkLylU4?showinfo=0&related=0&enablejsapi=1&autoplay=1&rel=0',
                            ),
                            videoItem(
                              context,
                              'Modicare Envoirochip - Animated Demo',
                              'https://www.youtube.com/embed/RoERmkLylU4?showinfo=0&related=0&enablejsapi=1&autoplay=1&rel=0',
                            ),
                            videoItem(
                              context,
                              'Modicare Envoirochip - Animated Demo',
                              'https://www.youtube.com/embed/RoERmkLylU4?showinfo=0&related=0&enablejsapi=1&autoplay=1&rel=0',
                            ),
                            videoItem(
                              context,
                              'Modicare Envoirochip - Animated Demo',
                              'https://www.youtube.com/embed/RoERmkLylU4?showinfo=0&related=0&enablejsapi=1&autoplay=1&rel=0',
                            ),
                            videoItem(
                              context,
                              'Modicare Envoirochip - Animated Demo',
                              'https://www.youtube.com/embed/RoERmkLylU4?showinfo=0&related=0&enablejsapi=1&autoplay=1&rel=0',
                            ),
                            // Add more videos as needed
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget videoItem(BuildContext context, String title, String videoUrl) {
    return GestureDetector(
      onTap: () {
        _playYoutubeVideo(context, videoUrl);
      },
      child: Container(
        width: 150,
        margin: const EdgeInsets.all(5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Image.network(
                  'https://img.youtube.com/vi/${videoUrl.split('/').last.split('?').first}/0.jpg',
                  width: 120,
                  height: 75,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  child: Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(0),
                        bottomRight: Radius.circular(8),
                      ),
                    ),
                    child: Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Text(
              title,
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  void _playYoutubeVideo(BuildContext context, String? videoUrl) {
    if (videoUrl != null) {
      // Save the current screen orientation
      final initialOrientation = MediaQuery.of(context).orientation;

      // Lock the screen orientation to portrait
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);

      showDialog(
        context: context,
        barrierDismissible: false, // prevent user from dismissing the dialog
        builder: (BuildContext context) {
          return AlertDialog(
            contentPadding: EdgeInsets.zero,
            content: Container(
              width: double.maxFinite, // Set the width as needed
              height: 500, // Set the height as needed
              child: YoutubePlayer(
                controller: YoutubePlayerController(
                  initialVideoId: YoutubePlayer.convertUrlToId(videoUrl) ?? '',
                  flags: YoutubePlayerFlags(
                    autoPlay: true,
                    mute: false,
                  ),
                ),
                showVideoProgressIndicator: true,
                onReady: () {
                  // Perform any additional setup here
                },
              ),
            ),
          );
        },
      ).then((value) {
        // Restore the original screen orientation after the dialog is dismissed
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
        ]);
      });
    } else {
      // Handle the case where videoUrl is null, if needed
      print('Video URL is null');
    }
  }
}
