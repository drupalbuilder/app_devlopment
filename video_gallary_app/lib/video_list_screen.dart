import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
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

  @override
  void initState() {
    super.initState();
    _videos = [];
    _scrollController = ScrollController();
    _loadVideos();
    _scrollController.addListener(_onScroll);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder<int>(
          future: _getVideoCount(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Text('Video List (${snapshot.data})');
            } else {
              return Text('Video List');
            }
          },
        ),
      ),
      body: _videos.isNotEmpty
          ? GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
          childAspectRatio: 2 / 3,
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
                child: Column(
                  children: [
                    Expanded(
                      child: FutureBuilder(
                        future: _videos[index].thumbnail,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            return Image.memory(
                              snapshot.data as Uint8List,
                              fit: BoxFit.cover,
                            );
                          } else {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        _videos[index].title ?? 'Video ${index + 1}',
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
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
        child: _isLoading ? CircularProgressIndicator() : Text('No videos available'),
      ),
    );
  }
}