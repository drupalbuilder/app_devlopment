import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'calander.dart';



enum DisplayMode { All, Consumers, NetworkBuilder }

class MyProspect extends StatefulWidget {
  @override
  _MyProspectState createState() => _MyProspectState();
}

class _MyProspectState extends State<MyProspect> {
  List<dynamic> prospects = [];
  List<dynamic> filteredProspects = [];
  TextEditingController searchController = TextEditingController();
  DisplayMode selectedMode = DisplayMode.All;
  bool isDataEmpty = false;

  Color activeButtonColor = Colors.blue;
  Color activeTextColor = Colors.white;
  Color defaultButtonColor = Colors.white;
  Color defaultTextColor = Colors.blue;
  bool isLoading = false;

  String _csrfToken = '';
  String _xsrfToken = '';
  String _modicareSession = '';

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? mcaNumber = prefs.getString('mcaNumber');
    if (mcaNumber != null) {
      final response = await http.get(
          Uri.parse('https://mdash.gprlive.com/api/Prospects/$mcaNumber'));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          prospects = data;
          filterProspects(searchController.text);
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        print('Failed to fetch data: ${response.statusCode}');
      }
    } else {
      setState(() {
        isLoading = false;
      });
      print('MCA number not found in SharedPreferences');
    }
  }

  void filterProspects(String query) {
    setState(() {
      if (query.isNotEmpty) {
        filteredProspects = prospects.where((prospect) =>
        prospect['name'].toString().toLowerCase().contains(
            query.toLowerCase()) ||
            prospect['contact'].toString().contains(query)).toList();
      } else {
        filteredProspects = prospects;
      }
    });
  }

  void filterByMode() {
    setState(() {
      switch (selectedMode) {
        case DisplayMode.All:
          filteredProspects = prospects;
          break;
        case DisplayMode.Consumers:
          filteredProspects = prospects.where((prospect) =>
          prospect['category'] == 1 || prospect['category'] == 3).toList();
          break;
        case DisplayMode.NetworkBuilder:
          filteredProspects = prospects.where((prospect) =>
          prospect['category'] == 2 || prospect['category'] == 3).toList();
          break;
      }
    });
  }

  Future<void> _launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _callContact(String phoneNumber) {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    _launchUrl(launchUri.toString());
  }

  void _sendWhatsAppMessage(String phoneNumber) {
    final Uri launchUri = Uri(
      scheme: 'https',
      host: 'wa.me',
      path: '/$phoneNumber',
    );
    _launchUrl(launchUri.toString());
  }

  void _sendSms(String phoneNumber) {
    final Uri launchUri = Uri(
      scheme: 'sms',
      path: phoneNumber,
    );
    _launchUrl(launchUri.toString());
  }

  Future<void> _fetchCsrfToken() async {
    final response = await http.get(
        Uri.parse('https://mdash.gprlive.com/api/csrf-token'));
    print('CSRF Token Fetch Response:');
    print('Status Code: ${response.statusCode}');
    print('Headers: ${response.headers}');
    print('Body: ${response.body}');

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      setState(() {
        _csrfToken = responseBody['csrf_token'];
      });
      final cookies = response.headers['set-cookie'];
      if (cookies != null) {
        setState(() {
          _xsrfToken =
              RegExp(r'XSRF-TOKEN=([^;]+)').firstMatch(cookies)?.group(1) ?? '';
          _modicareSession =
              RegExp(r'modicare_session=([^;]+)').firstMatch(cookies)?.group(
                  1) ?? '';
        });
      }
    } else {
      print('Failed to fetch CSRF token');
    }
  }


  Future<void> _deleteContact(String contactId, String contactNumber) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String mcaNumber = prefs.getString('mcaNumber') ?? '';

    // Ensure tokens are fetched before making the request
    await _fetchCsrfToken();

    // Check if tokens are empty and handle the scenario
    if (_csrfToken.isEmpty || _xsrfToken.isEmpty || _modicareSession.isEmpty) {
      print('Tokens are empty. Unable to make the request.');
      return;
    }

    // Prepare headers
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'X-CSRF-TOKEN': _csrfToken,
      'Cookie': 'XSRF-TOKEN=$_xsrfToken; modicare_session=$_modicareSession',
    };

    // Prepare body
    Map<String, dynamic> body = {
      "mca": mcaNumber,
      "contact": contactNumber
    };

    final response = await http.delete(
      Uri.parse('https://mdash.gprlive.com/api/Prospects/delete'),
      headers: headers,
      body: json.encode(body),
    );

    print('Delete Request Sent:');
    print('Headers: $headers');
    print('Body: $body');

    if (response.statusCode == 200) {
      // Delete contact success logic...

      // Remove the deleted contact from the filteredProspects list
      setState(() {
        filteredProspects.removeWhere((prospect) => prospect['id'] == contactId);
      });
      // Remove the deleted contact from the prospects list
      prospects.removeWhere((prospect) => prospect['id'] == contactId);
      // Optionally, show a success message to the user
      print('Contact deleted successfully');

      // Check if data is empty or failed to fetch
      if (prospects.isEmpty) {
        // Set isDataEmpty flag to true
        setState(() {
          isDataEmpty = true;
        });
      } else {
        // Fetch data again to refresh the screen
        fetchData();
      }
    } else {
      // Delete contact failure logic...

      // Set isDataEmpty flag to true
      setState(() {
        isDataEmpty = true;
      });
    }

    setState(() {
      isLoading = false;
    });
  }



  void _showDeleteConfirmationDialog(String id, String contact) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Delete Confirmation"),
          content: Text("Are you sure you want to delete this contact?"),
          actions: [
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Delete"),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                _deleteContact(id, contact);
              },
            ),
          ],
        );
      },
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20.0),
                        bottomRight: Radius.circular(20.0),
                      ),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.30),
                          offset: Offset(0, 1.5),
                          blurRadius: 0,
                        ),
                      ],
                    ),
                    padding: EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.arrow_back_ios,
                                    color: Colors.blue,
                                    size: 20.0,
                                  ),
                                  Text(
                                    'Back',
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 0.0),
                          ],
                        ),
                        SizedBox(height: 10.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'My Prospects',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AddProspect(),
                                  ),
                                );
                              },
                              child: Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: activeButtonColor,
                                    ),
                                    padding: const EdgeInsets.all(4),
                                    child: Icon(
                                      Icons.add,
                                      color: activeTextColor,
                                      size: 20,
                                    ),
                                  ),
                                  SizedBox(width: 8.0),
                                  Text(
                                    'Add New',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: activeButtonColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.0),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 12.0, vertical: 4.0),
                    child: TextField(
                      controller: searchController,
                      onChanged: (value) {
                        filterProspects(value);
                      },
                      decoration: InputDecoration(
                        hintText: 'Search prospects...',
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 12.0,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            selectedMode = DisplayMode.All;
                            filterByMode();
                          });
                          fetchData(); // Fetch data again when "All" button is pressed
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: selectedMode == DisplayMode.All
                              ? activeTextColor
                              : defaultTextColor,
                          backgroundColor: selectedMode == DisplayMode.All
                              ? activeButtonColor
                              : defaultButtonColor,
                        ),
                        child: Text('All'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            selectedMode = DisplayMode.Consumers;
                            filterByMode();
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: selectedMode == DisplayMode.Consumers
                              ? activeTextColor
                              : defaultTextColor,
                          backgroundColor: selectedMode == DisplayMode.Consumers
                              ? activeButtonColor
                              : defaultButtonColor,
                        ),
                        child: Text('Consumers'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            selectedMode = DisplayMode.NetworkBuilder;
                            filterByMode();
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: selectedMode ==
                              DisplayMode.NetworkBuilder
                              ? activeTextColor
                              : defaultTextColor,
                          backgroundColor: selectedMode ==
                              DisplayMode.NetworkBuilder
                              ? activeButtonColor
                              : defaultButtonColor,
                        ),
                        child: Text('Network Builders'),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.0),
                  if (filteredProspects.isEmpty)
                    Text('No prospects found')
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: filteredProspects.length,
                      itemBuilder: (context, index) {
                        var prospect = filteredProspects[index];
                        return Card(
                          color: Colors.white,
                          margin: EdgeInsets.symmetric(
                              horizontal: 12.0, vertical: 6.0),
                          child: ListTile(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 16.0),
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      child: Icon(Icons.person),
                                      backgroundColor: Colors.white,

                                      radius: 20,
                                    ),
                                    SizedBox(width: 8.0),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment
                                          .start,
                                      children: [
                                        Text(prospect['name']),
                                        Text(prospect['contact']),
                                      ],
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.perm_contact_calendar),
                                      color: Colors.blue,
                                      onPressed: () {
                                        // Navigate to AddEventScreen and pass data
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                AddEventScreen(
                                                  name: prospect['name'],
                                                  contact: prospect['contact'],
                                                ),
                                          ),
                                        );
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.delete),
                                      color: Colors.black45,
                                      onPressed: () {
                                        _showDeleteConfirmationDialog(
                                            prospect['id'].toString(),
                                            prospect['contact']);
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            subtitle:Row(
                              children: [
                                SizedBox(width: 32.0), // Add padding from the left
                                IconButton(
                                  icon: Icon(Icons.call),
                                  color: Colors.green,
                                  onPressed: () {
                                    _callContact(prospect['contact']);
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.message),
                                  color: Colors.lightBlue,
                                  onPressed: () {
                                    _sendSms(prospect['contact']);
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.messenger_outline),
                                  color: Colors.green,
                                  onPressed: () {
                                    _sendWhatsAppMessage(prospect['contact']);
                                  },
                                ),
                              ],
                            )

                          ),
                        );
                      },
                    ),
                ],
              ),
            ),
            if (isLoading)
              Container(
                color: Colors.black.withOpacity(.5),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}




  class AddProspect extends StatefulWidget {
  @override
  _AddProspectState createState() => _AddProspectState();
}

class _AddProspectState extends State<AddProspect> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _contactController = TextEditingController();
  String _csrfToken = '';
  String _xsrfToken = '';
  String _modicareSession = '';
  String _selectedCategory = '';
  List<Contact> selectedContacts = [];


  void _submitForm() async {
    String name = _nameController.text;
    String contact = _contactController.text;

    // Validate contact number format
    if (contact.length != 10 || !RegExp(r'^[0-9]+$').hasMatch(contact)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter a valid 10-digit contact number.'),
        ),
      );
      return;
    }

    // Check if contact already exists
    bool contactExists = await _checkContactExistence(contact);
    if (contactExists) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Contact already exists. Please enter a new contact.'),
        ),
      );
      return;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String mcaNumber = prefs.getString('mcaNumber') ?? '';

    // Ensure tokens are fetched before making the request
    await _fetchCsrfToken();

    // Check if tokens are empty and handle the scenario
    if (_csrfToken.isEmpty || _xsrfToken.isEmpty || _modicareSession.isEmpty) {
      print('Tokens are empty. Unable to make the request.');
      return;
    }

    // Prepare headers
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'X-CSRF-TOKEN': _csrfToken,
      'Cookie': 'XSRF-TOKEN=$_xsrfToken; modicare_session=$_modicareSession',
    };

    // Prepare request body
    Map<String, dynamic> requestBody = {
      'prospects': [
        {
          'mca': mcaNumber,
          'name': name,
          'contact': contact,
          'category': _selectedCategory,
          // Include the selected category value here
        }
      ]
    };

    // Convert request body to JSON
    String body = jsonEncode(requestBody);

    // Print request details
    print('Request Headers: $headers');
    print('Request Body: $body');

    try {
      var response = await http.put(
        Uri.parse('https://mdash.gprlive.com/api/Prospects/save'),
        headers: headers,
        body: body,
      );

      print('Response:');
      print(response.body);

      if (response.statusCode == 200) {
        // Request successful, display a success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Data submitted successfully'),
            backgroundColor: Colors.black,
          ),
        );
      } else {
        // Request failed, display an error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to submit data. Please try again.'),
          ),
        );
      }
    } catch (e) {
      // Exception occurred, display an error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.black,
        ),
      );
    }
  }


  Future<void> _fetchCsrfToken() async {
    final response = await http.get(
        Uri.parse('https://mdash.gprlive.com/api/csrf-token'));
    print('CSRF Token Fetch Response:');
    print('Status Code: ${response.statusCode}');
    print('Headers: ${response.headers}');
    print('Body: ${response.body}');

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      setState(() {
        _csrfToken = responseBody['csrf_token'];
      });
      final cookies = response.headers['set-cookie'];
      if (cookies != null) {
        setState(() {
          _xsrfToken =
              RegExp(r'XSRF-TOKEN=([^;]+)').firstMatch(cookies)?.group(1) ?? '';
          _modicareSession =
              RegExp(r'modicare_session=([^;]+)').firstMatch(cookies)?.group(
                  1) ?? '';
        });
      }
    } else {
      print('Failed to fetch CSRF token');
    }
  }


  @override
  void initState() {
    super.initState();
    _selectedCategory = ''; // Selects the first category by default
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // Align everything to the left
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20.0),
                    bottomRight: Radius.circular(20.0),
                  ),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.30),
                      offset: Offset(0, 1.5),
                      blurRadius: 0,
                    ),
                  ],
                ),
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Row(
                            children: [
                              Icon(
                                Icons.arrow_back_ios,
                                color: Colors.blue,
                                size: 20.0,
                              ),
                              Text(
                                'Back',
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 0.0), // Added SizedBox for spacing
                      ],
                    ),
                    SizedBox(height: 10.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Add a Prospects',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SelectContactsScreen(
                                  selectedContacts: selectedContacts,
                                ),
                              ),
                            );
                            if (result != null) {
                              setState(() {
                                selectedContacts = result;
                              });
                            }
                          },
                          child: Row(
                            children: [
                              Icon(
                                Icons.contact_phone,
                                size: 18.0,
                                color: Colors.blue,
                              ),
                              SizedBox(width: 8.0), // Add some spacing between icon and text
                              Text(
                                'Open contacts',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),

                      ],
                    ),
                    SizedBox(height: 10.0),
                  ],
                ),
              ),
              SizedBox(height: 60.0),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: 'Select Type',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0), // Apply rounded border
                            borderSide: BorderSide(
                              color: Colors.blue, // Set border color
                            ),
                          ),
                          contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                        ),
                        value: _selectedCategory,
                        items: [
                          DropdownMenuItem(
                            child: Text('Select Type'),
                            value: '',
                          ),
                          DropdownMenuItem(
                            child: Text('Consumers'),
                            value: '1',
                          ),
                          DropdownMenuItem(
                            child: Text('For Networking'),
                            value: '2',
                          ),
                          DropdownMenuItem(
                            child: Text('For Both'),
                            value: '3',
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedCategory = value!;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select a category';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: _nameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your name';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: 'Name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: BorderSide(
                              color: Colors.blue, // Change border color to blue when triggered
                            ),
                          ),
                          contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                        ),
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: _contactController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your contact';
                          }
                          return null;
                        },
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly, // Allows only digits
                        ],
                        keyboardType: TextInputType.phone, // Optional: Sets the keyboard type to numeric
                        decoration: InputDecoration(
                          labelText: 'Contact',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: BorderSide(
                              color: Colors.blue, // Change border color to blue when triggered
                            ),
                          ),
                          contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                        ),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            // Form is valid, submit data
                            _submitForm();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white, // Set button background color to white
                        ),
                        child: Text(
                          'Submit',
                          style: TextStyle(
                            color: Colors.blue, // Set button text color to blue
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20.0),
            ],
          ),
        ),
      ),
    );
  }
}

Future<bool> _checkContactExistence(String contact) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String mcaNumber = prefs.getString('mcaNumber') ?? '';

  if (mcaNumber.isEmpty) {
    print('MCA number is empty');
    return false; // Assuming no MCA number means contacts don't exist
  }

  try {
    var response = await http.get(
      Uri.parse('https://mdash.gprlive.com/api/Prospects/$mcaNumber'),
    );

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      print('Fetched data:');
      print(responseBody); // Print the fetched data
      // Assuming the response is a list of contacts with unique identifiers like phone numbers
      List<String> existingContacts = responseBody.map<String>((contact) => contact['contact'].toString()).toList();

      // Check if the contact already exists in the existingContacts list
      bool contactExists = existingContacts.contains(contact);

      return contactExists;
    } else {
      print('Failed to fetch existing contacts. Status code: ${response.statusCode}');
      return false;
    }
  } catch (e) {
    print('Error checking contact existence: $e');
    return false;
  }
}





class SelectContactsScreen extends StatefulWidget {
  final List<Contact> selectedContacts;

  SelectContactsScreen({required this.selectedContacts});

  @override
  _SelectContactsScreenState createState() => _SelectContactsScreenState();
}

class _SelectContactsScreenState extends State<SelectContactsScreen> {
  List<Contact> _allContacts = [];
  int _pageNumber = 1;
  int _pageSize = 20; // Number of contacts to load per page
  bool _isLoading = false;
  bool _hasMore = true;
  ScrollController _scrollController = ScrollController();
  late List<Contact> selectedContacts;
  String _csrfToken = '';
  String _xsrfToken = '';
  String _modicareSession = '';
  String? _selectedCategory; // Define _selectedCategory field

  @override
  void initState() {
    super.initState();
    selectedContacts = List.from(widget.selectedContacts);
    _loadContacts();
    _fetchCsrfToken();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent &&
          _hasMore &&
          !_isLoading) {
        _loadContacts();
      }
    });
  }

  Future<void> _loadContacts() async {
    if (_isLoading || !_hasMore) return;

    setState(() {
      _isLoading = true;
    });

    Iterable<Contact> contacts = await _fetchContacts();

    setState(() {
      _isLoading = false;
      _allContacts.addAll(contacts);
      _pageNumber++;
      _hasMore = contacts.length == _pageSize;
    });
  }

  Future<Iterable<Contact>> _fetchContacts() async {
    Iterable<Contact> allContacts = await ContactsService.getContacts(query: '');

    // Filter contacts to only include those with a mobile number having more than 10 digits
    Iterable<Contact> contactsWithMobile = allContacts.where((contact) {
      // Check if any phone number in the contact's phone list has more than 10 digits
      bool hasNumberGreaterThan10Digits = false;
      if (contact.phones != null) {
        for (var phone in contact.phones!) {
          if (phone.value != null) {
            String numericPhone = phone.value!.replaceAll(RegExp(r'\D'), '');
            if (numericPhone.length > 10) {
              hasNumberGreaterThan10Digits = true;
              break;
            }
          }
        }
      }
      return hasNumberGreaterThan10Digits;
    });

    int startIndex = (_pageNumber - 1) * _pageSize;
    int endIndex = startIndex + _pageSize;

    List<Contact> paginatedContacts = contactsWithMobile.toList().sublist(
        startIndex,
        endIndex > contactsWithMobile.length
            ? contactsWithMobile.length
            : endIndex);

    return paginatedContacts;
  }





  

  Future<void> _fetchCsrfToken() async {
    final response =
    await http.get(Uri.parse('https://mdash.gprlive.com/api/csrf-token'));
    print('CSRF Token Fetch Response:');
    print('Status Code: ${response.statusCode}');
    print('Headers: ${response.headers}');
    print('Body: ${response.body}');

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      setState(() {
        _csrfToken = responseBody['csrf_token'];
      });
      final cookies = response.headers['set-cookie'];
      if (cookies != null) {
        setState(() {
          _xsrfToken =
              RegExp(r'XSRF-TOKEN=([^;]+)').firstMatch(cookies)?.group(1) ?? '';
          _modicareSession =
              RegExp(r'modicare_session=([^;]+)').firstMatch(cookies)?.group(
                  1) ??
                  '';
        });
      }
    } else {
      print('Failed to fetch CSRF token');
    }
  }



  Future<void> _submitSelectedContacts() async {
    setState(() {
      _isSavingContacts = true; // Set to true when saving starts
    });

    if (_selectedCategory == null || _selectedCategory!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please select a category'),
        backgroundColor: Colors.black,
      ));
      setState(() {
        _isSavingContacts = false; // Set back to false if validation fails
      });
      return;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String mcaNumber = prefs.getString('mcaNumber') ?? '';

    if (_csrfToken.isEmpty || _xsrfToken.isEmpty || _modicareSession.isEmpty) {
      print('Tokens are empty. Unable to make the request.');
      setState(() {
        _isSavingContacts = false; // Set back to false if tokens are empty
      });
      return;
    }

    List<Map<String, String>> prospects = [];
    int selectedCount = 0;
    int existingCount = 0;

    for (Contact contact in selectedContacts) {
      String cleanedContact = contact.phones?.isNotEmpty == true
          ? contact.phones!.first.value?.replaceAll(' ', '') ?? ''
          : '';

      // Remove all non-digit characters
      String digitsOnly = cleanedContact.replaceAll(RegExp(r'\D+'), '');

      // Check if the number is longer than 10 digits
      if (digitsOnly.length > 10) {
        // Trim the number to the last 10 digits
        cleanedContact = digitsOnly.substring(digitsOnly.length - 10);
      } else if (digitsOnly.length < 10) {
        // Skip this contact if the number is less than 10 digits
        continue;
      }

      String cleanedName = '';
      if (contact.displayName != null) {
        for (int i = 0; i < contact.displayName!.length; i++) {
          if (contact.displayName![i].runes.any((rune) => rune < 0x1F600 || rune > 0x1F64F)) {
            cleanedName += contact.displayName![i];
          }
        }
      }

      // Check if contact already exists
      bool contactExists = await _checkContactExistence(cleanedContact);

      if (contactExists) {
        existingCount++;
      } else {
        selectedCount++;
        prospects.add({
          'mca': mcaNumber,
          'name': cleanedName,
          'contact': cleanedContact,
          'category': _selectedCategory!,
        });
      }
    }


    if (prospects.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Selected contacts already exist'),
        backgroundColor: Colors.black,
      ));
      setState(() {
        _isSavingContacts = false; // Set back to false if no new contacts to save
      });
      return;
    }

    Map<String, dynamic> requestBody = {'prospects': prospects};

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'X-CSRF-TOKEN': _csrfToken,
      'Cookie': 'XSRF-TOKEN=$_xsrfToken; modicare_session=$_modicareSession',
    };

    print('Request Headers: $headers');
    print('Request Body: ${jsonEncode(requestBody)}');

    try {
      var response = await http.put(
        Uri.parse('https://mdash.gprlive.com/api/Prospects/save'),
        headers: headers,
        body: jsonEncode(requestBody),
      );

      print('Response Status Code: ${response.statusCode}');
      print('Response Headers: ${response.headers}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        if (existingCount > 0) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('$existingCount already exist. $selectedCount saved successfully!'),
            backgroundColor: Colors.black,
          ));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('$selectedCount saved successfully!'),
            backgroundColor: Colors.black,
          ));
        }
      }
 else {
        print('Failed to save contacts. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error saving contacts: $e');
    }

    setState(() {
      _isSavingContacts = false; // Set back to false when saving completes
    });
  }


  bool _isSavingContacts = false;


  Future<bool> _checkContactExistence(String contact) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String mcaNumber = prefs.getString('mcaNumber') ?? '';

    if (mcaNumber.isEmpty) {
      print('MCA number is empty');
      return false; // Assuming no MCA number means contacts don't exist
    }

    try {
      var response = await http.get(
        Uri.parse('https://mdash.gprlive.com/api/Prospects/$mcaNumber'),
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        print('Fetched data:');
        print(responseBody); // Print the fetched data
        // Assuming the response is a list of contacts with unique identifiers like phone numbers
        List<String> existingContacts = responseBody.map<String>((contact) => contact['contact'].toString()).toList();

        // Check if the contact already exists in the existingContacts list
        bool contactExists = existingContacts.contains(contact);

        return contactExists;
      } else {
        print('Failed to fetch existing contacts. Status code: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error checking contact existence: $e');
      return false;
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Container(
                  padding: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20.0),
                      bottomRight: Radius.circular(20.0),
                    ),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.30),
                        offset: Offset(0, 1.5),
                        blurRadius: 0,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Row(
                          children: [
                            Icon(
                              Icons.arrow_back_ios,
                              color: Colors.blue,
                              size: 20.0,
                            ),
                            Text(
                              'Back',
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Text(
                        'SELECT CATEGORY',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      SizedBox(height: 20.0),
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: 'Select Type',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: BorderSide(
                              color: Colors.blue, // Change border color to blue
                            ),
                          ),
                          contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                        ),
                        items: [
                          DropdownMenuItem(
                            child: Text('Select Type'),
                            value: '',
                          ),
                          DropdownMenuItem(
                            child: Text('Consumers'),
                            value: '1',
                          ),
                          DropdownMenuItem(
                            child: Text('For Networking'),
                            value: '2',
                          ),
                          DropdownMenuItem(
                            child: Text('For Both'),
                            value: '3',
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedCategory = value!;
                          });
                        },
                        value: _selectedCategory,
                        style: TextStyle(color: Colors.black), // Set text color to black
                        dropdownColor: Colors.white, // Set dropdown background color to white
                        isExpanded: true,
                        icon: const Icon(Icons.arrow_drop_down),
                      ),

                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: _allContacts.length + (_isLoading ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == _allContacts.length) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      Contact contact = _allContacts[index];
                      return CheckboxListTile(
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(contact.displayName ?? ''),
                            Text(
                              contact.phones?.isNotEmpty == true
                                  ? contact.phones!.first.value ?? ''
                                  : '',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        value: selectedContacts.contains(contact),
                        onChanged: (bool? value) {
                          setState(() {
                            if (value != null && value) {
                              selectedContacts.add(contact);
                            } else {
                              selectedContacts.remove(contact);
                            }
                          });
                        },
                        checkColor: Colors.white,
                        activeColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      topRight: Radius.circular(20.0),
                    ),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.30),
                        offset: Offset(0, 1.5),
                        blurRadius: 0,
                      ),
                    ],
                  ),
                  child: Center(
                    child: ElevatedButton(
                      onPressed: _submitSelectedContacts,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white, // Set button background color to white
                      ),
                      child: Text(
                        'Add',
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.blue, // Set button text color to blue
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            if (_isSavingContacts)
              Container(
                color: Colors.black.withOpacity(0.5),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}







