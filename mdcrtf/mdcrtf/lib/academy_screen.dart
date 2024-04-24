import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import 'infoscreen.dart';

class AcademyScreen extends StatelessWidget {
  const AcademyScreen({super.key});

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
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.grey,
                        width: 1.0,
                      ),
                    ),
                  ),
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
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Image.network(
                              'https://rtfapi.modicare.com/assets/images/help.png?act=1',
                              width: 24,
                              height: 24,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Azadi Mantras',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
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
                      SizedBox(
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
                const SizedBox(height: 10),
                const Text(
                  'Additional Videos',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: 10),
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
                      SizedBox(
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
      child: SizedBox(
        height: 200, // Adjust this height as needed
        child: Padding(
          padding: const EdgeInsets.fromLTRB(4.0, 20.0, 0.0, 0.0), // Padding from left, top, right, and bottom
          child: SizedBox(
            width: 150,
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
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(0),
                            bottomRight: Radius.circular(8),
                          ),
                        ),
                        child: const Icon(
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
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }



  void _playYoutubeVideo(BuildContext context, String? videoUrl) {
    if (videoUrl != null) {
      // Save the current screen orientation

      // Lock the screen orientation to portrait
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);

      showDialog(
        context: context,
        barrierDismissible: true, // allow dismissing the dialog by clicking outside
        builder: (BuildContext context) {
          return AlertDialog(
            contentPadding: EdgeInsets.zero,
            content: SizedBox(
              width: double.maxFinite, // Set the width as needed
              height: 400, // Set the height as needed
              child: YoutubePlayer(
                controller: YoutubePlayerController(
                  initialVideoId: YoutubePlayer.convertUrlToId(videoUrl) ?? '',
                  flags: const YoutubePlayerFlags(
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
      if (kDebugMode) {
        print('Video URL is null');
      }
    }
  }

}
