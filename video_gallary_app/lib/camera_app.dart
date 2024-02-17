import 'package:flutter/material.dart';
import 'package:camera/camera.dart' as camera;
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class CameraApp extends StatefulWidget {
  const CameraApp({Key? key}) : super(key: key);

  @override
  _CameraAppState createState() => _CameraAppState();
}

class _CameraAppState extends State<CameraApp> {
  late camera.CameraController _controller;
  late Future<void> _initializeControllerFuture;
  bool _isRecording = false;
  bool _isPaused = false;

  @override
  void initState() {
    super.initState();
    _initializeControllerFuture = _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await camera.availableCameras();
    final firstCamera = cameras.first;

    _controller = camera.CameraController(
      firstCamera,
      camera.ResolutionPreset.medium,
      imageFormatGroup: camera.ImageFormatGroup.yuv420,
    );

    await _controller.initialize();
  }

  Future<void> _startRecording() async {
    await _controller.startVideoRecording();

    setState(() {
      _isRecording = true;
      _isPaused = false;
    });
  }

  Future<void> _pauseOrResumeRecording() async {
    if (_isRecording) {
      _isPaused = true;
      await _controller.pauseVideoRecording();
    } else {
      _isPaused = false;
      await _controller.resumeVideoRecording();
    }

    setState(() {
      _isRecording = !_isRecording;
      _isPaused = _isPaused;
    });
  }

  Future<void> _stopRecording() async {
    final appDirectory = await getApplicationDocumentsDirectory();
    final videosDirectory = Directory('${appDirectory.path}/videos');
    await videosDirectory.create(recursive: true);

    final videoFileName = '${DateTime.now()}.mp4';

    if (_isRecording || _isPaused) {
      final XFile videoFile = await _controller.stopVideoRecording();
      final videoPath = '${videosDirectory.path}/$videoFileName';
      await videoFile.saveTo(videoPath);

      // Upload the video file to the server
      // await _uploadVideoFile(videoPath);
    }

    setState(() {
      _isRecording = false;
      _isPaused = false;
    });
  }

  Future<void> _uploadVideoFile(String videoPath) async {
    final url = 'YOUR_UPLOAD_ENDPOINT'; // Replace with your server's upload endpoint
    final file = File(videoPath);

    try {
      final response = await http.post(
        Uri.parse(url),
        body: {
          'video': file.readAsBytesSync(),
        },
      );

      // Handle server response if needed
     // print('Server response: ${response.statusCode}');
    } catch (e) {
     // print('Error uploading file: $e');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Record Video'),
      ),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Column(
              children: [
                Expanded(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      camera.CameraPreview(_controller),
                      Positioned(
                        bottom: 16,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (!_isRecording && !_isPaused)
                              ElevatedButton(
                                onPressed: _startRecording,
                                child: const Text('Record'),
                              ),
                            if (_isRecording || _isPaused)
                              ElevatedButton(
                                onPressed: _pauseOrResumeRecording,
                                child:
                                Text(_isRecording ? 'Pause' : 'Resume'),
                              ),
                            if (_isRecording || _isPaused)
                              const SizedBox(width: 16),
                            if (_isRecording || _isPaused)
                              ElevatedButton(
                                onPressed: _stopRecording,
                                child: const Text('Stop'),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error initializing camera: ${snapshot.error}'),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
