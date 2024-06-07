import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:t2t1/firsttime/stepper.dart';


class Setyourdreames extends StatefulWidget {
  final VoidCallback onNextPressed;

  Setyourdreames({required this.onNextPressed});

  @override
  _SetyourdreamesState createState() => _SetyourdreamesState();
}

class _SetyourdreamesState extends State<Setyourdreames> {
  List<Map<String, dynamic>>? dreamDataList; // Make dreamDataList nullable
  Map<int, bool> isCheckedMap = {}; // Define isCheckedMap to store checked states

  @override
  void initState() {
    super.initState();
    retrieveDreamData();
  }

  void retrieveDreamData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int currentIndex = prefs.getInt('currentIndex') ?? 0;
    List<Map<String, dynamic>> dataList = [];
    for (int i = 0; i < currentIndex; i++) {
      dataList.add({
        'dreamTitle': prefs.getString('dreamTitle_$i') ?? 'Dream Title',
        'date': prefs.getString('date_$i') ?? 'Oct 20, 2023',
        'money': prefs.getString('money_$i') ?? '₹20000',
        'selectedImageUrl': prefs.getString('selectedImageUrl_$i') ?? '',
      });
      isCheckedMap[i] = false; // Initialize isCheckedMap with false values
    }
    setState(() {
      dreamDataList = dataList;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Check if dreamDataList is null
    if (dreamDataList == null) {
      // Show a loading indicator or any other placeholder widget
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    bool isAnyChecked = isCheckedMap.containsValue(true); // Check if any checkbox is checked
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                SizedBox(height: 8.0),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 255, 255, 255),
                  ),
                  child: Column(
                    children: [
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
                                  Image.network(
                                    'https://rtfapi.modicare.com/img/camera.png',
                                    height: 55.0,
                                    width: 55.0,
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
                    ],
                  ),
                ),
                SizedBox(height: 8.0),
                GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.8,
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
                  ),
                  itemCount: dreamDataList!.length,
                  itemBuilder: (context, index) {
                    Map<String, dynamic> dreamData = dreamDataList![index];
                    String title = dreamData['dreamTitle'] ?? 'Dream Title'; // Fetch the title for this card
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 8.0),
                        Text(
                          title,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        buildDreamCard(dreamData, index), // Pass index to buildDreamCard
                      ],
                    );
                  },
                ),
                SizedBox(height: 20.0), // Added space before the button
                GestureDetector(
                  onTap: () {
                    if (isAnyChecked) {
                      // Call the onNextPressed callback to notify the parent widget
                      widget.onNextPressed();
                    }
                  },
                  child: Opacity(
                    opacity: isAnyChecked ? 1.0 : 0.5, // Disable button if no checkbox is checked
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
                  ),
                ),
                SizedBox(height: 40.0),
              ],
            ),
          ),
        ),
      ),
    );
  }


  Widget buildDreamCard(Map<String, dynamic> dreamData, int index) {
    bool isChecked = isCheckedMap[index] ?? false;

    return GestureDetector(
      onTap: () {
        setState(() {
          isCheckedMap[index] = !isCheckedMap[index]!;
        });
      },
      child: Stack(
        children: [
          Card(
            margin: EdgeInsets.only(left: 0.0, right: 0.0, bottom: 18.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6.0),
              side: BorderSide(color: Color(0xFFe1e1e1), width: 1.0),
            ),
            elevation: 5.0,
            child: ListView(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
                  color: Color(0xFF0fa2a9),
                  child: Text(
                    '₹ ${dreamData['money']} , ${dreamData['date']}',
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Color(0xFFffffff),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(6.0)),
                  child: Image.network(
                    dreamData['selectedImageUrl'],
                    width: double.infinity,
                    height: 100.0,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child:GestureDetector(
              onTap: () {
                // Remove the card from stored data and update UI
                removeDreamCard(index);
              },
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black12, // Change the color as desired
                ),
                child: Icon(Icons.close_rounded, color: Colors.white),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 78,
            child: Row(
              children: [

                SizedBox(width: 8), // Add some spacing between delete button and checkbox
                Container(
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
              ],
            ),
          ),
        ],
      ),
    );
  }

  void removeDreamCard(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int currentIndex = prefs.getInt('currentIndex') ?? 0;
    if (index >= 0 && index < currentIndex) {
      // Remove data associated with the card at the given index
      prefs.remove('dreamTitle_$index');
      prefs.remove('date_$index');
      prefs.remove('money_$index');
      prefs.remove('selectedImageUrl_$index');

      // Shift the indices of the remaining cards in the SharedPreferences
      for (int i = index + 1; i < currentIndex; i++) {
        String title = prefs.getString('dreamTitle_$i') ?? 'Dream Title';
        String date = prefs.getString('date_$i') ?? 'Oct 20, 2023';
        String money = prefs.getString('money_$i') ?? '₹20000';
        String selectedImageUrl = prefs.getString('selectedImageUrl_$i') ?? '';

        prefs.setString('dreamTitle_${i - 1}', title);
        prefs.setString('date_${i - 1}', date);
        prefs.setString('money_${i - 1}', money);
        prefs.setString('selectedImageUrl_${i - 1}', selectedImageUrl);
      }
      // Decrement the currentIndex in SharedPreferences
      prefs.setInt('currentIndex', currentIndex - 1);
    }
    // Refresh UI to reflect changes
    setState(() {
      dreamDataList!.removeAt(index);
    });
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



class UploadDreams extends StatefulWidget {
  @override
  _UploadDreamsState createState() => _UploadDreamsState();
}

class _UploadDreamsState extends State<UploadDreams> {
  List<String> cardTitles = [];
  List<String> cardImages = [];
  List<bool> isCheckedList = [];
  bool isDataLoaded = false;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    List<String> apiEndpoints = [
      'https://mdash.gprlive.com/api/dreams/2',
      'https://mdash.gprlive.com/api/dreams/3',
      'https://mdash.gprlive.com/api/dreams/66',
      'https://mdash.gprlive.com/api/dreams/60',
      'https://mdash.gprlive.com/api/dreams/126',
    ];

    for (String endpoint in apiEndpoints) {
      try {
        var response = await http.get(Uri.parse(endpoint));
        if (response.statusCode == 200) {
          Map<String, dynamic> data = json.decode(response.body);
          setState(() {
            cardTitles.add(data['name']);
            cardImages.add("https://mdash.gprlive.com/${data['image']}");
            isCheckedList.add(false);
          });
        } else {
          print('Failed to load data from $endpoint');
        }
      } catch (e) {
        print('Error: $e');
      }
    }
    setState(() {
      isDataLoaded = true; // Data is loaded, hide the loading animation
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isDataLoaded
          ? SafeArea(
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
                      Navigator.pop(context);
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
                                cardTitles[index],
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(height: 8.0),
                            SizedBox(
                              width: 200, // Fixed width
                              height: 140, // Fixed height
                              child: Card(
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
                                          dreamId: index,
                                          dreamTitle: cardTitles[index],
                                        ),
                                      ),
                                    );
                                  },
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(6.0),
                                    child: Image.network(
                                      cardImages[index],
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Positioned(
                          bottom: 56,
                          left: MediaQuery.of(context).size.width < 600 ? 74 : 10,
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
      )
          : Center(
        child: LoadingAnimationWidget.waveDots(
          color: Colors.blue,
          size: 100,
        ),
      ),
    );
  }
}





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
  late SharedPreferences prefs;
  List<String> cardImages = [
    'https://mdash.gprlive.com/uploads/images/dreams/1695292854_SHutterstock-300x200-pix_0013_shutterstock_339018524.png',
    'https://mdash.gprlive.com/uploads/images/dreams/1695292865_SHutterstock-300x200-pix_0003_shutterstock_2265832113.png',
    'https://mdash.gprlive.com/uploads/images/dreams/1695292886_SHutterstock-300x200-pix_0006_shutterstock_1513007366.png',
    'https://mdash.gprlive.com/uploads/images/dreams/1695292896_SHutterstock-300x200-pix_0009_shutterstock_789412672.png',
    'https://mdash.gprlive.com/uploads/images/dreams/1695292875_SHutterstock-300x200-pix_0021_shutterstock_513593005.png',
    'https://mdash.gprlive.com/uploads/images/dreams/1697827668_360_F_194436506_uyKU47IZH5jyxHdMJI1Ravkm4uV4HdF2.jpg',
  ];
  String selectedImageUrl = '';

  @override
  void initState() {
    super.initState();
    _dateController = TextEditingController();
    _moneyController = TextEditingController();
    _dateFormat = DateFormat('MM/dd/yyyy');
    selectedDate = null;
    initSharedPreferences();
  }

  void initSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  void dispose() {
    _dateController.dispose();
    _moneyController.dispose();
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

  void _submitData() {
    if (_dateController.text.isEmpty ||
        _moneyController.text.isEmpty ||
        selectedImageUrl.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill in all fields.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    int currentIndex = prefs.getInt('currentIndex') ?? 0;
    prefs.setString('dreamTitle_$currentIndex', widget.dreamTitle);
    prefs.setString('date_$currentIndex', _dateController.text);
    prefs.setString('money_$currentIndex', _moneyController.text);
    prefs.setString('selectedImageUrl_$currentIndex', selectedImageUrl);
    prefs.setInt('currentIndex', currentIndex + 1);

    _dateController.clear();
    _moneyController.clear();
    selectedImageUrl = '';

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Data submitted successfully.'),
        backgroundColor: Colors.green,
      ),
    );

    // Navigate to the info screen
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CustomStepperPage()), // Replace InfoScreen with your info screen widget
    );
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
                                  Navigator.pop(context);
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
                                'About The Dream:',
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
                                widget.dreamTitle,
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
                                'By When:',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10.0),
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
                                'How much money will be required:',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10.0),
                          Row(
                            children: [
                              SizedBox(width: 10.0),
                              Expanded(
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
                                          controller: _moneyController,
                                          keyboardType: TextInputType.number,
                                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                          decoration: InputDecoration(
                                            hintText: '1,000,00',
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
                              SizedBox(width: 16.0),
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
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: List.generate(
                                cardImages.length,
                                    (index) {
                                  bool isSelected = selectedImageUrl == cardImages[index];
                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selectedImageUrl = isSelected ? '' : cardImages[index];
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
                                            borderRadius: BorderRadius.circular(0.0),
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
                              FilePickerResult? result = await FilePicker.platform.pickFiles();
                              if (result != null) {
                                setState(() {
                                  selectedImageUrl = result.files.single.path!;
                                });
                              }
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.5,
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
                                          // This part is for handling camera access
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
                      _submitData();
                    },
                    child: SizedBox(
                      width: 240.0,
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
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            'Submit',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                            ),
                            textAlign: TextAlign.center,
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
      ),
    );
  }
}

class CustomDashedBorderPainter extends CustomPainter {
  final Color borderColor;
  final double borderWidth;
  final double borderRadius;

  CustomDashedBorderPainter({required this.borderColor, required this.borderWidth, required this.borderRadius});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = borderColor
      ..strokeWidth = borderWidth
      ..style = PaintingStyle.stroke;

    final path = Path();
    path.addRRect(RRect.fromRectAndCorners(
      Rect.fromLTWH(0.0, 0.0, size.width, size.height),
      topLeft: Radius.circular(borderRadius),
      topRight: Radius.circular(borderRadius),
      bottomLeft: Radius.circular(borderRadius),
      bottomRight: Radius.circular(borderRadius),
    ));

    final dashWidth = 5;
    final dashSpace = 5;
    double currentX = 0;
    while (currentX < size.width) {
      path.moveTo(currentX, 0);
      path.lineTo(currentX + dashWidth, 0);
      currentX += dashWidth + dashSpace;
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}




