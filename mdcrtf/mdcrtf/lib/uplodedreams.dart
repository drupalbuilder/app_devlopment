import 'package:flutter/material.dart';
import 'selectdreams.dart';

void main() {
  runApp(MaterialApp(
    home: UploadDreams(),
  ));
}

class UploadDreams extends StatefulWidget {
  @override
  _UploadDreamsState createState() => _UploadDreamsState();
}

class _UploadDreamsState extends State<UploadDreams> {
  final List<String> cardTitles = [
    'Dream Travel',
    'Dream Car',
    'Dream Home',
    'Child\'s Education', // Escape the single quote with a backslash
    'Dream Bike',
    'Others',
  ];

  final List<String> cardImages = [
    'https://mdash.gprlive.com/uploads/images/dreams/1695292854_SHutterstock-300x200-pix_0013_shutterstock_339018524.png',
    'https://mdash.gprlive.com/uploads/images/dreams/1695292865_SHutterstock-300x200-pix_0003_shutterstock_2265832113.png',
    'https://mdash.gprlive.com/uploads/images/dreams/1695292886_SHutterstock-300x200-pix_0006_shutterstock_1513007366.png',
    'https://mdash.gprlive.com/uploads/images/dreams/1695292896_SHutterstock-300x200-pix_0009_shutterstock_789412672.png',
    'https://mdash.gprlive.com/uploads/images/dreams/1695292875_SHutterstock-300x200-pix_0021_shutterstock_513593005.png',
    'https://mdash.gprlive.com/uploads/images/dreams/1695292854_SHutterstock-300x200-pix_0013_shutterstock_339018524.png',
  ];

  List<bool> isCheckedList = List.generate(6, (index) => false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 16.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context); // Go back to the previous page
                    },
                    child: Text(
                      'ᐸ  Back',
                      style: TextStyle(
                        color: Color(0xFF0396FE),
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 16.0),
                  child: Text(
                    'Set your dream',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 26.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                GridView.builder(
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200.0,
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
                    childAspectRatio: MediaQuery.of(context).size.width < 600 ? 0.8 : 1.0,
                  ),
                  itemCount: cardTitles.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Stack(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 8.0),
                              child: Text(
                                cardTitles[index], // Use the title from the list
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(height: 8.0), // Padding between title and card
                            Card(
                              margin: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6.0),
                                side: BorderSide(color: Color(0xFFe1e1e1), width: 1.0),
                              ),
                              elevation: 5.0,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SelectDreams(
                                        dreamId: index, // Pass the ID to the SelectDreams screen
                                        dreamTitle: cardTitles[index], // Pass the title to the SelectDreams screen
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6.0),
                                    // Apply border radius to the container
                                    border: Border.all(color: Color(0xFFe1e1e1), width: 1.0),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(6.0),
                                    child: Image.network(
                                      cardImages[index], // Use the image URL from the list
                                      fit: BoxFit.cover, // Ensure the image covers the entire space
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Positioned(
                          bottom: 6,
                          left: MediaQuery.of(context).size.width < 600 ? 40 : 66,
                          child: Container(
                            width: 35,
                            height: 35,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isCheckedList[index] ? Color(0xFF0DB1E3) : Colors.grey,
                            ),
                            child: isCheckedList[index]
                                ? Icon(Icons.check, color: Colors.white)
                                : Icon(Icons.add, color: Colors.white),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
