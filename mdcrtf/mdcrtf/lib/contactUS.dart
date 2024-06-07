import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUsApp extends StatelessWidget {
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
                        color: Colors.black.withOpacity(0.30),
                        offset: Offset(0, 1.5),
                        blurRadius: 0,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context); // Go back to the previous page
                            },
                            child: Row(
                              children: [
                                Icon(
                                  Icons.arrow_back_ios,
                                  color: Color(0xFF0396FE),
                                  size: 20.0,
                                ), // Adjust the spacing between the icon and text
                                Text(
                                  'Back', // Removed the '<'
                                  style: TextStyle(
                                    color: Color(0xFF0396FE),
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10.0), // Add space here
                      Padding(
                        padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),// Padding top and bottom
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Contact Us',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight
                                    .w900,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),


                SizedBox(height: 20.0),
                ContactItem(
                  title: 'Please email',
                  contactInfo: 'support-modicare@modi-ent.com',
                  buttonText: 'Send',
                  onPressed: () {
                    launch('mailto:support-modicare@modi-ent.com');
                  },
                ),
                ContactItem(
                  title: 'Or call',
                  contactInfo: '0124-6912900',
                  buttonText: 'Call now',
                  onPressed: () {
                    launch('tel:01246912900');
                  },
                ),
                ContactItem(
                  title: 'Talk to Roshni',
                  contactInfo: 'www.modicare.com',
                  buttonText: 'Visit',
                  onPressed: () {
                    launch('https://www.modicare.com');
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

class ContactItem extends StatelessWidget {
  final String title;
  final String contactInfo;
  final String buttonText;
  final VoidCallback onPressed;

  const ContactItem({
    Key? key,
    required this.title,
    required this.contactInfo,
    required this.buttonText,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 20),
          child: Column(
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),
              Text(
                contactInfo,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: onPressed,

                style: ElevatedButton.styleFrom(
                  foregroundColor: Color(0xFF333333),
                  backgroundColor: Color(0xFFFDFDFD),
                  side: BorderSide(width: 1.0, color: Color(0xFF0099FF)),
                ),
                child: Text(buttonText),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ContactUsApp(),
  ));
}
