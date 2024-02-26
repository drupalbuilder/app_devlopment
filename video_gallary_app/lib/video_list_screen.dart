import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'video_player_screen.dart';

class VideoListScreen extends StatefulWidget {
  const VideoListScreen({Key? key}) : super(key: key);

  @override
  _VideoListScreenState createState() => _VideoListScreenState();
}

class _VideoListScreenState extends State<VideoListScreen> {
  late List<VideoData> _videos;
  late ScrollController _scrollController;
  bool _isLoading = false;
  bool _hasMoreVideos = true;
  late SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    _videos = [];
    _scrollController = ScrollController();
    _loadVideos();
    _scrollController.addListener(_onScroll);
    _initPrefs();
  }

  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      if (!_isLoading && _hasMoreVideos) {
        _loadVideos();
      }
    }
  }

  Future<void> _loadVideos() async {
    setState(() {
      _isLoading = true;
    });

    final appDirectory = await getApplicationDocumentsDirectory();
    final videosDirectory = Directory('${appDirectory.path}/videos');
    final files = videosDirectory.listSync();

    final newVideos = await Future.wait(files
        .where((file) => file.path.endsWith('.mp4'))
        .where((file) =>
    !_videos.any((video) => video.videoPath.path == file.path))
        .map((file) => VideoData.fromFile(File(file.path)))
        .toList());

    // Check if any titles are saved in shared preferences and update video titles
    for (int i = 0; i < newVideos.length; i++) {
      String? savedTitle = _prefs.getString('video_title_${newVideos[i].videoPath.path}');
      if (savedTitle != null) {
        newVideos[i].title = savedTitle;
      }
    }

    setState(() {
      _isLoading = false;
      _videos.addAll(newVideos);
      _hasMoreVideos = newVideos.length > 0; // Check if there are more videos
    });
  }

  // Add the following method to show video count
  Future<int> _getVideoCount() async {
    final appDirectory = await getApplicationDocumentsDirectory();
    final videosDirectory = Directory('${appDirectory.path}/videos');
    final files = videosDirectory.listSync();

    return files.where((file) => file.path.endsWith('.mp4')).length;
  }

  void _editVideoTitle(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController _controller = TextEditingController();
        return AlertDialog(
          title: Text('Edit Video Title'),
          content: TextField(
            controller: _controller,
            decoration: InputDecoration(hintText: 'Enter new title'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                String newTitle = _controller.text.trim();
                if (newTitle.isNotEmpty) {
                  setState(() {
                    _videos[index].title = newTitle;
                  });
                  _prefs.setString('video_title_${_videos[index].videoPath.path}', newTitle);
                  Navigator.of(context).pop();
                }
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
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
        title: FutureBuilder<int>(
          future: _getVideoCount(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Text(
                'Video List (${snapshot.data})',
                style: TextStyle(
                  color: Colors.white, // Change text color to white or any other color
                ),
              );
            } else {
              return Text(
                'Video List',
                style: TextStyle(
                  color: Colors.white, // Change text color to white or any other color
                ),
              );
            }
          },
        ),
      ),
      backgroundColor: Color(0xfff5f5f5), // Set background color
      body: _videos.isNotEmpty
          ? GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
          childAspectRatio: MediaQuery.of(context).size.width /
              (MediaQuery.of(context).size.height / 10),
        ),
        controller: _scrollController,
        itemCount: _videos.length + (_hasMoreVideos ? 1 : 0),
        itemBuilder: (context, index) {
          if (index < _videos.length) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        VideoPlayerScreen(_videos[index]),
                  ),
                );
              },
              child: Card(
                elevation: 6,
                color: Color(0xFFFFFFFF), // Set card background color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width / 6.5,
                        height: MediaQuery.of(context).size.width / 6.5,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Color(0xFF6280C0),
                            width: 1.0,
                          ),
                        ),
                        child: FutureBuilder(
                          future: _videos[index].thumbnail,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              return ClipOval(
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
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          _videos[index].title ?? 'Video ${index + 1}',
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        _editVideoTitle(index);
                      },
                      icon: Icon(Icons.edit),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return _isLoading
                ? Center(child: CircularProgressIndicator())
                : Container();
          }
        },
      )
          : Center(
        child: _isLoading
            ? CircularProgressIndicator()
            : Text('No videos available'),
      ),
    );
  }
}
