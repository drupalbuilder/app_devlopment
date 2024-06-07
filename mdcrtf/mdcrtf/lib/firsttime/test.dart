import 'package:flutter/material.dart';

class ReportScreen extends StatefulWidget {
  final String name;
  final String contact;

  ReportScreen({required this.name, required this.contact});

  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    String initialText = '';
    if (widget.name.isNotEmpty && widget.contact.isNotEmpty) {
      initialText = 'Name: ${widget.name}\nContact: ${widget.contact}\n\n';
    }
    _descriptionController.text = initialText;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Report'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(
                hintText: 'Description',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide(
                    color: Color(0xFF17a2b8),
                  ),
                ),
              ),
              maxLines: 6,
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                // Add your save action here
                String description = _descriptionController.text;
                // Process the description as needed
                print(description); // Just for testing, replace this with your saving logic
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ReportScreen(name: 'John Doe', contact: '+1234567890'),
  ));
}
