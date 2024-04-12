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
                        color: Colors.black.withOpacity(0.43),
                        offset: Offset(0, 1),
                        blurRadius: 2,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back,
                            color: Color.fromARGB(255, 40, 40, 40)),
                        onPressed: () {
                          Navigator.pop(context); // Navigate back when pressed
                        },
                      ),
                      Text(
                        'Contact Us',
                        style: TextStyle(
                          color: Color.fromARGB(255, 40, 40, 40),
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
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
