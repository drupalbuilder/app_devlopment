import 'package:flutter/material.dart';

import 'uplodedreams.dart';

class Managedreams extends StatefulWidget {
  @override
  _ManagedreamsState createState() => _ManagedreamsState();
}

class _ManagedreamsState extends State<Managedreams> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(0.0),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20.0),
                      bottomRight: Radius.circular(20.0),
                    ),
                    color: Color.fromARGB(255, 255, 255, 255),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.43),
                        offset: Offset(0, 1),
                        blurRadius: 2,
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            GestureDetector(
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
                          ],
                        ),
                        SizedBox(height: 8.0),
                        Row(
                          children: [
                            Text(
                              'Set your dream',

                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20.0),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => UploadDreams()), // Navigate to Uplodedreams Screen
                            );
                          },
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(16.0),
                            child: CustomPaint(
                              painter: DashedBorderPainter(
                                color: Color(0xFF0DB1E3),
                                strokeWidth: 2.0,
                                borderRadius: 10.0,
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
                                child: Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => UploadDreams()), // Navigate to Uplodedreams Screen
                                        );
                                      },
                                      child: Image.network(
                                        'https://rtfapi.modicare.com/img/camera.png',
                                        height: 55.0,
                                        width: 55.0,
                                      ),
                                    ),
                                    SizedBox(height: 10.0),
                                    Text(
                                      'Upload your\n dream photo',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 12.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),



                        SizedBox(height: 8.0),
                        Row(
                          children: [
                            Text(
                              'Dream Travel',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.0),
                        Stack(
                          children: [
                            Card(
                              margin: EdgeInsets.only(left: 0.0, right: 0.0, bottom: 18.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6.0),
                                side: BorderSide(color: Color(0xFFe1e1e1), width: 1.0),
                              ),
                              elevation: 5.0,
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isChecked = !isChecked;
                                  });
                                },
                                child: SizedBox(
                                  width: 196.0,
                                  height: 150.0,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.only(left: 14.0, right: 38.0, bottom: 2.0, top: 2.0),
                                        decoration: BoxDecoration(
                                          color: Color(0xFF0fa2a9),
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10.0),
                                            topRight: Radius.circular(10.0),
                                          ),
                                        ),
                                        child: Text(
                                          '₹20000 , Oct 20, 2023',
                                          style: TextStyle(
                                            fontSize: 14.0,
                                            color: Color(0xFFffffff),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          width: 200.0,
                                          padding: EdgeInsets.zero,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                bottomLeft: Radius.circular(6.0),
                                                bottomRight: Radius.circular(6.0),
                                              ),
                                            ),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.only(
                                                bottomLeft: Radius.circular(6.0),
                                                bottomRight: Radius.circular(6.0),
                                              ),
                                              child: Image.network(
                                                'https://rtfapi.modicare.com/assets/dgallery/2/2-1.jpeg',
                                                width: 196.0,
                                                height: 100.0,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              left: 78,
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: isChecked ? Color(0xFF0DB1E3) : Colors.grey,
                                ),
                                child: isChecked
                                    ? Icon(Icons.check, color: Colors.white)
                                    : Icon(Icons.add, color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20.0), // Added space before the button

                      ],
                    ),
                  ),
                ),
                SizedBox(height: 40.0),
                GestureDetector(
                  onTap: () {
                    // Add functionality for the Continue button here
                  },
                  child: SizedBox(
                    width: 240.0, // Adjust the width as needed
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF1FA2FF), Color(0xFF1FA2FF), Color(0xFF12D8FA)],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(50.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 7,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          'Continue',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                )


              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DashedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double borderRadius;

  DashedBorderPainter({required this.color, required this.strokeWidth, required this.borderRadius});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final double dashWidth = 5.0;
    final double dashSpace = 5.0;

    // Draw top border
    double startX = borderRadius;
    while (startX < size.width - borderRadius) {
      canvas.drawLine(Offset(startX, 0), Offset(startX + dashWidth, 0), paint);
      startX += dashWidth + dashSpace;
    }

    // Draw right border
    double startY = borderRadius;
    while (startY < size.height - borderRadius) {
      canvas.drawLine(Offset(size.width, startY), Offset(size.width, startY + dashWidth), paint);
      startY += dashWidth + dashSpace;
    }

    // Draw bottom border
    startX = size.width - borderRadius;
    while (startX > borderRadius) {
      canvas.drawLine(Offset(startX, size.height), Offset(startX - dashWidth, size.height), paint);
      startX -= dashWidth + dashSpace;
    }

    // Draw left border
    startY = size.height - borderRadius;
    while (startY > borderRadius) {
      canvas.drawLine(Offset(0, startY), Offset(0, startY - dashWidth), paint);
      startY -= dashWidth + dashSpace;
    }

    // Draw rounded corners
    canvas.drawArc(
      Rect.fromLTWH(0, 0, 2 * borderRadius, 2 * borderRadius),
      -1.5708,
      -1.5708,
      false,
      paint,
    );
    canvas.drawArc(
      Rect.fromLTWH(size.width - 2 * borderRadius, 0, 2 * borderRadius, 2 * borderRadius),
      0,
      -1.5708,
      false,
      paint,
    );
    canvas.drawArc(
      Rect.fromLTWH(size.width - 2 * borderRadius, size.height - 2 * borderRadius, 2 * borderRadius, 2 * borderRadius),
      1.5708,
      -1.5708,
      false,
      paint,
    );
    canvas.drawArc(
      Rect.fromLTWH(0, size.height - 2 * borderRadius, 2 * borderRadius, 2 * borderRadius),
      3.1416,
      -1.5708,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

void main() {
  runApp(MaterialApp(
    home: Managedreams(),
  ));
}
