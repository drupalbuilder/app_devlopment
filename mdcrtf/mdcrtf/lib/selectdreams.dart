import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class SelectDreams extends StatefulWidget {
  final int dreamId;
  final String dreamTitle;

  const SelectDreams({Key? key, required this.dreamId, required this.dreamTitle}) : super(key: key);

  @override
  _SelectDreamsState createState() => _SelectDreamsState();
}

class _SelectDreamsState extends State<SelectDreams> {
  late TextEditingController _dateController;
  late TextEditingController _moneyController;
  late DateFormat _dateFormat;
  DateTime? selectedDate;

  final List<String> cardImages = [

    'https://mdash.gprlive.com/uploads/images/dreams/1695292854_SHutterstock-300x200-pix_0013_shutterstock_339018524.png',
    'https://mdash.gprlive.com/uploads/images/dreams/1695292865_SHutterstock-300x200-pix_0003_shutterstock_2265832113.png',
    'https://mdash.gprlive.com/uploads/images/dreams/1695292886_SHutterstock-300x200-pix_0006_shutterstock_1513007366.png',
    'https://mdash.gprlive.com/uploads/images/dreams/1695292896_SHutterstock-300x200-pix_0009_shutterstock_789412672.png',
    'https://mdash.gprlive.com/uploads/images/dreams/1695292875_SHutterstock-300x200-pix_0021_shutterstock_513593005.png',
    'https://mdash.gprlive.com/uploads/images/dreams/1697827668_360_F_194436506_uyKU47IZH5jyxHdMJI1Ravkm4uV4HdF2.jpg',
  ];

  int selectedImageIndex = -1; // Initialize with -1 to indicate no selection

  @override
  void initState() {
    super.initState();
    _dateController = TextEditingController();
    _moneyController = TextEditingController(); // Initialize money controller
    _dateFormat = DateFormat('MM/dd/yyyy');
    selectedDate = null;
  }

  @override
  void dispose() {
    _dateController.dispose();
    _moneyController.dispose(); // Dispose money controller
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
        _dateController.text = _dateFormat.format(selectedDate!);
      });
    }
  }

  void _dismissKeyboard(BuildContext context) {
    final currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      currentFocus.focusedChild!.unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
      _dismissKeyboard(context);
    },
    child: Scaffold(
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
                        SizedBox(height: 26.0),
                        Row(
                          children: [
                            Text(
                              'About The Dream:', // Added space before dreamTitle for readability
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              widget.dreamTitle, // Use widget.dreamTitle to access the property
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 26.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20.0),
                        Row(
                          children: [
                            Text(
                              'By When:', // Added space before dreamTitle for readability
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.0),
                        // Add the date input row here
                        Row(
                          children: [
                            SizedBox(width: 10.0),
                            Expanded(
                              child: GestureDetector(
                                onTap: () => _selectDate(context),
                                child: Container(
                                  height: 40.0,
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(color: Colors.grey),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: TextFormField(
                                          controller: _dateController,
                                          enabled: false,
                                          style: TextStyle(fontSize: 16.0),
                                          decoration: InputDecoration(
                                            hintText: 'MM/dd/yyyy',
                                            hintStyle: TextStyle(fontSize: 16.0),
                                          ),
                                        ),
                                      ),
                                      Icon(Icons.calendar_today_outlined),
                                      SizedBox(width: 10.0),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 16.0),
                          ],
                        ),
                        SizedBox(height: 20.0),
                        Row(
                          children: [
                            Text(
                              'How much money will be required:', // Added space before dreamTitle for readability
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.0),
                        // Add the money input field here
                        Row(
                          children: [
                            SizedBox(width: 10.0),
                            Expanded(
                              child: Container(
                                height: 40.0,
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(color: Colors.grey), // Only bottom border
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                        controller: _moneyController, // Use the initialized controller
                                        keyboardType: TextInputType.number, // Set keyboard type to number
                                        inputFormatters: [FilteringTextInputFormatter.digitsOnly], // Allow only digits
                                        decoration: InputDecoration(
                                          hintText: '1,000,00', // Placeholder text
                                          hintStyle: TextStyle(
                                            fontSize: 16.0,
                                          ),
                                        ),
                                        style: TextStyle(
                                          fontSize: 16.0,
                                        ),
                                      ),
                                    ),

                                    SizedBox(width: 10.0),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(width: 16.0), // Adjust spacing if needed
                          ],
                        ),
                        SizedBox(height: 20.0),
                        Row(
                          children: [
                            Text(
                              'Choose from Gallery',
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.0),
                        // Gallery selector for images
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: List.generate(
                              cardImages.length,
                                  (index) {
                                bool isSelected = selectedImageIndex == index;
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedImageIndex = isSelected ? -1 : index;
                                    });
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(5.0),
                                      child: Container(
                                        width: 160.0,
                                        height: 120.0,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: isSelected ? Color(0xFF00ffff) : Colors.transparent,
                                            width: isSelected ? 2.0 : 0.0,
                                          ),
                                          borderRadius: BorderRadius.circular(0.0), // Rounded border for selected image
                                        ),
                                        child: Image.network(
                                          cardImages[index],
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        SizedBox(height: 20.0),
                        Row(
                          children: [
                            Text(
                              'OR',
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20.0),
                        Row(
                          children: [
                            Text(
                              'Upload your own',
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20.0),
                        GestureDetector(
                          onTap: () async {
                            var status = await Permission.storage.request();
                            if (status.isGranted) {
                              final ImagePicker _picker = ImagePicker();
                              final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
                              if (image != null) {
                                // Handle the selected image, such as displaying it or uploading it
                              }
                            } else {
                              // Permission denied. Handle accordingly, such as showing a message or requesting again.
                            }
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.5, // Set width to 50%
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
                                      onTap: () async {
                                        var status = await Permission.camera.request();
                                        if (status.isGranted) {
                                          // Handle camera access
                                        } else {
                                          // Permission denied. Handle accordingly.
                                        }
                                      },
                                      child: Image.network(
                                        'https://rtfapi.modicare.com/img/camera.png',
                                        height: 55.0,
                                        width: 55.0,
                                      ),
                                    ),
                                    SizedBox(height: 10.0),
                                    Text(
                                      'Upload your dream ',
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


                        SizedBox(height: 20.0),


                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
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
                          'Sumbit',
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