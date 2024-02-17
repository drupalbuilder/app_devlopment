import 'dart:io';
import 'dart:typed_data';
import 'package:video_thumbnail/video_thumbnail.dart';

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
