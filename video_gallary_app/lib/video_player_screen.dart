import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class VideoPlayerScreen extends StatefulWidget {
  final VideoData videoData;

  VideoPlayerScreen(this.videoData);

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _videoController;
  late Future<void> _initializeVideoPlayerFuture;
  bool _isPlaying = false;
  double _sliderValue = 0.0;

  @override
  void initState() {
    super.initState();
    _videoController = VideoPlayerController.file(widget.videoData.videoPath)
      ..addListener(() {
        final bool isPlaying = _videoController.value.isPlaying;
        final Duration position = _videoController.value.position;
        final Duration duration = _videoController.value.duration;

        if (isPlaying != _isPlaying ||
            duration.inMilliseconds > 0) {
          setState(() {
            _isPlaying = isPlaying;
            _sliderValue =
                position.inMilliseconds / duration.inMilliseconds;
          });
        }
      });

    _initializeVideoPlayerFuture = _videoController.initialize();
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Player'),
        actions: [
          IconButton(
            icon: _isPlaying
                ? Icon(Icons.pause)
                : Icon(Icons.play_arrow),
            onPressed: () {
              if (_videoController.value.isPlaying) {
                _videoController.pause();
              } else {
                _videoController.play();
              }
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              _showDeleteConfirmation(context);
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                FutureBuilder(
                  future: _initializeVideoPlayerFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return AspectRatio(
                        aspectRatio: _videoController.value.aspectRatio,
                        child: VideoPlayer(_videoController),
                      );
                    } else {
                      return CircularProgressIndicator();
                    }
                  },
                ),
                if (!_videoController.value.isPlaying)
                  Positioned.fill(
                    child: IconButton(
                      iconSize: 50,
                      icon: Icon(Icons.play_arrow),
                      onPressed: () {
                        if (!_videoController.value.isPlaying) {
                          _videoController.play();
                        }
                      },
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                SliderTheme(
                  data: SliderThemeData(
                    trackHeight: 2.0,
                    thumbShape: RoundSliderThumbShape(
                      enabledThumbRadius: 8.0,
                    ),
                    overlayShape: RoundSliderOverlayShape(
                      overlayRadius: 16.0,
                    ),
                  ),
                  child: Slider(
                    value: _sliderValue,
                    onChanged: (value) {
                      setState(() {
                        _sliderValue = value;
                        final Duration position = _videoController.value.duration * value;
                        _videoController.seekTo(position);
                      });
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _formatDuration(_videoController.value.position),
                      style: TextStyle(color: Colors.grey),
                    ),
                    Text(
                      _formatDuration(_videoController.value.duration),
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Delete Video"),
          content: Text("Are you sure you want to delete this video?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                await widget.videoData.videoPath.delete();
                Navigator.of(context).pop();
                Navigator.of(context).pop(); // Pop twice to close the player screen
              },
              child: Text("Delete"),
            ),
          ],
        );
      },
    );
  }
}

class VideoData {
  final File videoPath;
  late Future<Uint8List?> thumbnail;
  String? title;

  VideoData(this.videoPath, {this.title});

  static Future<VideoData> fromFile(File file) async {
    final videoData = VideoData(file);
    videoData.thumbnail = _generateThumbnail(file);
    return videoData;
  }

  static Future<Uint8List?> _generateThumbnail(File videoFile) async {
    final thumbnail = await VideoThumbnail.thumbnailData(
      video: videoFile.path,
      imageFormat: ImageFormat.JPEG,
      maxWidth: 150,
      quality: 25,
    );
    return thumbnail;
  }
}
