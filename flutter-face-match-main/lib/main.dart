import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:flutter_face_api_beta/face_api.dart' as Regula;
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(MaterialApp(home: MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var image1 = Regula.MatchFacesImage();
  var img1 = Image.asset('assets/images/portrait.png');
  String _matchResult = "";
  List<Regula.MatchFacesImage> comparisonImages = [];

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    Regula.FaceSDK.init().then((json) {
      var response = jsonDecode(json);
      if (!response["success"]) {
        print("Init failed: ");
        print(json);
      }
    });
    loadComparisonImages();
  }

  Future<void> loadComparisonImages() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final imagesDirectory = Directory('${directory.path}/images');
      if (imagesDirectory.existsSync()) {
        List<FileSystemEntity> files = imagesDirectory.listSync();
        files.forEach((file) {
          if (file is File) {
            var bytes = file.readAsBytesSync();
            var image = Regula.MatchFacesImage();
            image.bitmap = base64Encode(bytes);
            image.imageType = Regula.ImageType.PRINTED;
            setState(() {
              comparisonImages.add(image);
            });
          }
        });
      }
    } catch (e) {
      print("Error loading comparison images: $e");
    }
  }

  Future<void> saveImageToStorage(File imageFile) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final imagesDirectory = Directory('${directory.path}/images');
      if (!imagesDirectory.existsSync()) {
        imagesDirectory.createSync(recursive: true);
      }
      final imagePath = '${imagesDirectory.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';
      imageFile.copySync(imagePath);
    } catch (e) {
      print("Error saving image to storage: $e");
    }
  }

  showAlertDialog(BuildContext context) => showDialog(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: const Text("Select option"),
      actions: [
        TextButton(
          child: const Text("Use gallery"),
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
            ImagePicker()
                .pickImage(source: ImageSource.gallery)
                .then((value) {
              setImage(value);
            });
          },
        ),
        TextButton(
          child: const Text("Use camera"),
          onPressed: () {
            Regula.FaceSDK.presentFaceCaptureActivity().then((result) {
              // Check if result is null or canceled
              if (result == null) return;

              // Update image1 with the captured image data
              setState(() {
                setImage(result);
              });
            });
            Navigator.pop(context); // Close the dialog
          },
        ),
      ],
    ),
  );

  setImage(XFile? xFile) {
    if (xFile == null) return;

    final imageFile = File(xFile.path);
    final imageBytes = imageFile.readAsBytesSync();

    image1.bitmap = base64Encode(imageBytes);
    image1.imageType = Regula.ImageType.PRINTED;

    setState(() {
      img1 = Image.memory(imageBytes);
    });
  }

  matchFacesWithMultipleImages() {
    if (img1 == null || img1 == "" || comparisonImages.isEmpty) return;

    setState(() => _matchResult = "Processing...");

    var requests = comparisonImages.map((image) {
      var request = Regula.MatchFacesRequest();
      request.images = [image1, image];
      return Regula.FaceSDK.matchFaces(jsonEncode(request));
    }).toList();

    Future.wait(requests).then((responses) {
      var matchResults = [];

      for (var i = 0; i < responses.length; i++) {
        var response =
        Regula.MatchFacesResponse.fromJson(jsonDecode(responses[i]));
        if (response!.results.isNotEmpty &&
            response.results[0]!.similarity! >= 0.9) {
          matchResults.add("Matched with Image ${i + 1}");
        } else {
          matchResults.add("Not Matched with Image ${i + 1}");
        }
      }

      setState(() {
        _matchResult = matchResults.join("\n");
      });
    });
  }

  clearResults() {
    setState(() {
      img1 = Image.asset('assets/images/portrait.png');
      _matchResult = "";
      image1 = Regula.MatchFacesImage(); // Reset image1
    });
  }

  Widget createButton(String text, VoidCallback onPress) => Container(
    width: 250,
    child: TextButton(
      style: ButtonStyle(
        foregroundColor:
        MaterialStateProperty.all<Color>(Colors.blue),
        backgroundColor:
        MaterialStateProperty.all<Color>(Colors.black12),
      ),
      onPressed: onPress,
      child: Text(text),
    ),
  );

  Widget createImage(image, VoidCallback onPress) => Material(
    child: InkWell(
      onTap: onPress,
      child: Container(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: Image(height: 100, width: 100, image: image),
        ),
      ),
    ),
  );

  Widget createCircleImage(image) {
    if (image == null || image.bitmap == null) {
      return Container();
    }
    final decodedImage = Image.memory(base64Decode(image.bitmap!));
    return Container(
      margin: EdgeInsets.all(10),
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.blue, width: 2),
      ),
      child: ClipOval(
        child: decodedImage,
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Container(
      margin: const EdgeInsets.fromLTRB(0, 0, 0, 100),
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          createImage(img1.image, () => showAlertDialog(context)),
          SizedBox(height: 10),
          SizedBox(height: 10),
          createButton("Match", () => matchFacesWithMultipleImages()),
          createButton("Clear", () => clearResults()),
          SizedBox(height: 10),
          Text(
            "Result: $_matchResult",
            style: TextStyle(fontSize: 18),
          ),
        ],
      ),
    ),
    floatingActionButton: FloatingActionButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ImageListPage(images: comparisonImages),
          ),
        );
      },
      child: Icon(Icons.list),
    ),
  );
}

class ImageListPage extends StatefulWidget {
  final List<Regula.MatchFacesImage> images;

  const ImageListPage({Key? key, required this.images}) : super(key: key);

  @override
  _ImageListPageState createState() => _ImageListPageState();
}

class _ImageListPageState extends State<ImageListPage> {
  @override
  void initState() {
    super.initState();
    loadComparisonImages();
  }

  Future<void> loadComparisonImages() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final imagesDirectory = Directory('${directory.path}/images');
      if (imagesDirectory.existsSync()) {
        List<FileSystemEntity> files = imagesDirectory.listSync();
        files.forEach((file) {
          if (file is File) {
            var bytes = file.readAsBytesSync();
            var image = Regula.MatchFacesImage();
            image.bitmap = base64Encode(bytes);
            image.imageType = Regula.ImageType.PRINTED;
            setState(() {
              widget.images.add(image);
            });
          }
        });
      }
    } catch (e) {
      print("Error loading comparison images: $e");
    }
  }

  void deleteImage(int index) async {
    setState(() {
      widget.images.removeAt(index); // Remove image from the list
    });

    final directory = await getApplicationDocumentsDirectory();
    final imagePath = '${directory.path}/images/image_$index.jpg';
    File(imagePath).deleteSync(); // Delete image from local storage
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Image List"),
      ),
      body: ListView.builder(
        itemCount: widget.images.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text("Image ${index + 1}"),
            leading: Image.memory(
              base64Decode(widget.images[index].bitmap!),
              width: 50,
              height: 50,
            ),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () => deleteImage(index), // Call deleteImage method
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add image for comparison
          final imagePicker = ImagePicker();
          imagePicker.pickImage(source: ImageSource.gallery).then((pickedImage) {
            if (pickedImage != null) {
              final imageFile = File(pickedImage.path);
              final imageBytes = imageFile.readAsBytesSync();

              var image = Regula.MatchFacesImage();
              image.bitmap = base64Encode(imageBytes);
              image.imageType = Regula.ImageType.PRINTED;

              // Save image to local storage
              final directory = getApplicationDocumentsDirectory();
              directory.then((directory) {
                final imagePath = '${directory.path}/images/image_${DateTime.now().millisecondsSinceEpoch}.jpg';
                imageFile.copySync(imagePath);
              });

              setState(() {
                widget.images.add(image); // Add new image to the list
              });
            }
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
