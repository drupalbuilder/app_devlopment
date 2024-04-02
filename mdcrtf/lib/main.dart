import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'mainscreen.dart';
import 'dart:convert';




void main() {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter bindings are initialized

  // Set preferred screen orientations (portrait only)76185896
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    runApp(MyApp());
  });
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Login App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginScreen(),
    );
  }
}

class LoginScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _mcaController = TextEditingController();

  void _onLoginButtonPressed(BuildContext context) async {
    if (_formKey.currentState?.validate() ?? false) {
      String mcaNumber = _mcaController.text;
      String apiUrl = 'https://mdash.gprlive.com/api/users/$mcaNumber';

      try {
        final response = await http.get(Uri.parse(apiUrl));

        if (response.statusCode == 200) {
          final jsonData = json.decode(response.body);

          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('userData', json.encode(jsonData));

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => MainScreen(),
            ),
          );
        } else {
          // Handle API error responses
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to fetch user data. Status code: ${response.statusCode}'),
            ),
          );
        }
      } catch (error) {
        // Handle network errors
        print('Error: $error');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('An error occurred: $error'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Stack(
            children: [
              Container(
                color: Color(0xFFFFFFFF),
                child: Padding(
                  padding: const EdgeInsets.only(left: 4.0, top: 100.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.all(14.0),
                        color: Color(0xFFFDFDFD),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.network(
                              'https://rtfapi.modicare.com/img/ModicareIcon@3x.png',
                              height: 22,
                              width: 75,
                            ),
                            Image.network(
                              'https://rtfapi.modicare.com/img/Road%20toFreedom@3x.png',
                              height: 72,
                              width: 200,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: 14.0, right: 8.0, top: 8.0),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MobileLoginScreen()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 10.0), backgroundColor: Color(0xFF1FA2FF),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                          ),
                          child: Text(
                            'Login with Mobile',
                            style: TextStyle(
                              fontSize: 13.0,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        color: Color(0xFFFFFFFF),
                        child: Padding(
                          padding: EdgeInsets.all(14.0),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width * 0.55,
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: Color(0xFFf5eded),
                                        width: 1.0,
                                      ),
                                    ),
                                  ),
                                  child: TextFormField(
                                    controller: _mcaController,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your MCA number';
                                      }
                                      return null;
                                    },
                                    keyboardType: TextInputType.number, // Set keyboard type to number
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.digitsOnly // Allow only numeric input
                                    ],
                                    decoration: InputDecoration(
                                      labelText: 'MCA No.',
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 16.0),
                                Container(
                                  width: double.infinity,
                                  alignment: Alignment.centerLeft,
                                  child: ElevatedButton(
                                    onPressed: () => _onLoginButtonPressed(context),
                                    style: ElevatedButton.styleFrom(
                                      foregroundColor: Colors.transparent, backgroundColor: Colors.transparent,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            50.0),
                                        side: BorderSide.none,
                                      ),
                                    ),
                                    child: Ink(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Color(0xFF1FA2FF),
                                            Color(0xFF1FA2FF),
                                            Color(0xFF12D8FA),
                                          ],
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight,
                                        ),
                                        borderRadius: BorderRadius.circular(
                                            50.0),
                                      ),
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 8.0, horizontal: 24.0),
                                        child: Text(
                                          'Login',
                                          style: TextStyle(
                                            fontSize: 13.0,
                                            color: Colors.white,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 16.0),
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            WebViewExample(
                                              url: 'https://www.modicare.com/join-us',
                                            ),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    'Register',
                                    style: TextStyle(
                                      color: Color(0xFF2FA8D3),
                                    ),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) =>
                                          ForgotPasswordScreen()),
                                    );
                                  },
                                  child: Text(
                                    'Forgot Password',
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                          'https://rtfapi.modicare.com/img/m2.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  width: 178,
                  height: 500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



class OTPEntryScreen extends StatefulWidget {
  @override
  _OTPEntryScreenState createState() => _OTPEntryScreenState();
}

class _OTPEntryScreenState extends State<OTPEntryScreen> {
  final List<TextEditingController> _otpControllers = List.generate(
    5,
        (index) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(
    5,
        (index) => FocusNode(),
  );

  @override
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  Future<void> submitOTP() async {
    String enteredOTP = _otpControllers.map((controller) => controller.text).join();
    if (enteredOTP.isEmpty) {
      // Show error message if OTP field is empty
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please enter OTP."),
        ),
      );
      return;
    }

    bool verificationSuccess = await verifyOTP(enteredOTP); // Call using this
    if (verificationSuccess) {
      // OTP verified successfully
      print("OTP verified successfully.");
      // Navigate to MainScreen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainScreen()),
      );
    } else {
      // Incorrect OTP, show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Invalid OTP. Please enter a valid OTP."),
        ),
      );
    }
  }

  Future<bool> verifyOTP(String otp) async {
    // Make API call to verify OTP
    String apiUrl = "https://api.modicare.com/api/query/validate/otp/vue";
    Map<String, String> headers = {"Content-Type": "application/json"};

    try {
      // Retrieve stored response body from SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? storedResponseBody = prefs.getString('otp_response');

      // Check if storedResponseBody is not null
      if (storedResponseBody == null) {
        print('Stored response body not found in SharedPreferences.');
        return false; // Response body not found in SharedPreferences
      }

      // Replace "sent": true with "otp": "entered_otp"
      String modifiedData = storedResponseBody.replaceAll(
          RegExp(r'"sent"\s*:\s*true'), '"otp": "$otp"');
      // Log the modified request data for debugging
      print('Modified Request Data: $modifiedData');

      // Send the modified response data to the backend
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: modifiedData,
      );
      print('Request Sent to API Endpoint.');

      if (response.statusCode == 200) {
        // OTP verification successful
        // Parse response JSON
        Map<String, dynamic> responseData = json.decode(response.body);

        // Check if the response indicates a successful OTP verification
        if (responseData['valid'] == true) {
          // OTP verified successfully
          print('OTP verified successfully.');

          // Log the response body for debugging
          print('Response from API: ${response.body}');

          return true;
        } else {
          // OTP verification failed
          print('Invalid OTP. Please enter a valid OTP.');
          return false;
        }
      } else {
        // OTP verification failed due to non-200 status code
        print('Failed to verify OTP. Status code: ${response.statusCode}');
        return false;
      }
    } catch (error) {
      // Handle network errors
      print("Error verifying OTP: $error");
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Enter OTP',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (int i = 0; i < 5; i++)
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 4.0),
                      child: TextField(
                        controller: _otpControllers[i],
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        maxLength: 1,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14.0, // Adjust the font size as needed
                          fontWeight: FontWeight.bold,
                          color: Colors.black, // Text color
                        ),
                        decoration: InputDecoration(
                          counterText: '',
                          contentPadding: EdgeInsets.all(12.0), // Inner padding
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black, width: 2.0),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.green, width: 2.0),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          filled: true,
                          fillColor: Colors.white, // Background color
                        ),
                        focusNode: _focusNodes[i],
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            if (i < 5) {
                              // Move focus to the next TextField
                              FocusScope.of(context).requestFocus(_focusNodes[i + 1]);
                            } else {
                              // Last digit entered, submit or perform other actions
                              submitOTP();
                            }
                          } else {
                            if (i > 0) {
                              // Move focus to the previous TextField when deleting a digit
                              FocusScope.of(context).requestFocus(_focusNodes[i - 1]);
                            }
                          }
                        },
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: submitOTP,
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}



class MobileLoginScreen extends StatefulWidget {
  @override
  _MobileLoginScreenState createState() => _MobileLoginScreenState();
}

class _MobileLoginScreenState extends State<MobileLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _mobileController = TextEditingController();
  String otpResponse = '';

  Future<bool> sendOTP(BuildContext context, String mobileNumber) async {
    // Define the API endpoint
    Uri url = Uri.parse("https://api.modicare.com/api/query/send/otp/vue");

    // Define request headers
    Map<String, String> headers = {
      "Content-Type": "application/json",
    };

    // Create request body
    Map<String, dynamic> body = {
      "mobile": mobileNumber,
    };

    // Encode request body
    String requestBody = jsonEncode(body);

    try {
      // Make POST request to trigger OTP
      final response = await http.post(url, headers: headers, body: requestBody);

      // Log the request and response
      print('Request: $requestBody');
      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      // Check if the request was successful (status code 200)
      if (response.statusCode == 200) {
        // Parse the response body
        Map<String, dynamic> responseData = jsonDecode(response.body);

        // Log the parsed response data
        print('Parsed response data: $responseData');

        // Check if OTP was sent successfully
        if (responseData.containsKey('sent') && responseData['sent'] == true) {
          // Store response data in shared preferences
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('otp_response', response.body); // Store entire response body JSON string

          // OTP sent successfully, overlay OTPEntryScreen as a dialog
          showDialog(
            context: context,
            barrierDismissible: false, // Prevent dismissing the dialog by tapping outside
            builder: (BuildContext context) {
              return OTPEntryScreen();
            },
          );

          // Print the response when OTP is sent successfully
          print('Response when OTP sent successfully: $responseData');

          return true; // OTP sent successfully
        }
      }

      // OTP sending failed
      setState(() {
        otpResponse = "Failed to send OTP";
      });
      // Print error message if needed
      print(response.body);

      return false; // OTP sending failed

    } catch (error) {
      // Handle any errors that occurred during the request
      setState(() {
        otpResponse = "Error sending OTP: $error";
      });
      print('Error sending OTP: $error');
      return false; // Error occurred
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Stack(
            children: [
              Container(
                color: Color(0xFFFFFFFF),
                child: Padding(
                  padding: const EdgeInsets.only(left: 4.0, top: 100.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.all(14.0),
                        color: Color(0xFFFFFFFF),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.network(
                              'https://rtfapi.modicare.com/img/ModicareIcon@3x.png',
                              height: 22,
                              width: 75,
                            ),
                            Image.network(
                              'https://rtfapi.modicare.com/img/Road%20toFreedom@3x.png',
                              height: 72,
                              width: 200,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 14.0, right: 8.0, top: 8.0),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => LoginScreen()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
                            backgroundColor: Color(0xFF1FA2FF),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                          ),
                          child: Text(
                            'Login with MCA',
                            style: TextStyle(
                              fontSize: 13.0,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        color: Color(0xFFFDFDFD),
                        child: Padding(
                          padding: EdgeInsets.only(left: 14.0, right: 14.0),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width * 0.55,
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: Color(0xFFf5eded),
                                        width: 1.0,
                                      ),
                                    ),
                                  ),
                                  child: TextFormField(
                                    controller: _mobileController,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your mobile number';
                                      }

                                      // Check if the value contains only numeric characters
                                      if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                                        return 'Invalid characters. Please enter a valid mobile number';
                                      }

                                      // Check if the length of the number is within a specific range
                                      if (value.length < 8 || value.length > 15) {
                                        return 'Invalid mobile number length';
                                      }

                                      // Additional checks or custom validation logic can be added here

                                      return null; // Return null if the input passes all validation checks
                                    },
                                    keyboardType: TextInputType.number,
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                    decoration: InputDecoration(
                                      labelText: 'Mobile Number',
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 16.0),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      if (_formKey.currentState?.validate() ?? false) {
                                        String mobileNumber = _mobileController.text;
                                        sendOTP(context, mobileNumber); // Pass the BuildContext as well
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      foregroundColor: Colors.transparent,
                                      backgroundColor: Colors.transparent,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(50.0),
                                        side: BorderSide.none,
                                      ),
                                    ),
                                    child: Ink(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Color(0xFF1FA2FF),
                                            Color(0xFF1FA2FF),
                                            Color(0xFF12D8FA),
                                          ],
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight,
                                        ),
                                        borderRadius: BorderRadius.circular(50.0),
                                      ),
                                      child: Container(
                                        padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                                        child: Text(
                                          'Send OTP',
                                          style: TextStyle(
                                            fontSize: 13.0,
                                            color: Colors.white,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 16.0),
                                Text(
                                  otpResponse, // Display OTP response message
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: 16.0),
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => WebViewExample(
                                          url: 'https://www.modicare.com/join-us',
                                        ),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    'Register',
                                    style: TextStyle(
                                      color: Color(0xFF2FA8D3),
                                    ),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => ForgotPasswordScreen()),
                                    );
                                  },
                                  child: Text(
                                    'Forgot Password',
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage('https://rtfapi.modicare.com/img/m2.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  width: 178,
                  height: 500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class WebViewExample extends StatelessWidget {
  final String url;

  WebViewExample({required this.url});
  @override
  Widget build(BuildContext context) {
    // Set the status bar color
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.black, // Change this color as needed
      statusBarIconBrightness: Brightness.light, // Change the icon color as needed
    ));

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            InAppWebView(
              initialUrlRequest: URLRequest(
                url: Uri.parse(url),
              ),
              initialOptions: InAppWebViewGroupOptions(
                crossPlatform: InAppWebViewOptions(),
              ),
              shouldOverrideUrlLoading: (controller, navigationAction) async {
                var uri = navigationAction.request.url!;
                var host = uri.host;

                // Check if the host is the specified domain
                if (host == 'www.modicare.com' || host == 'modicare.com') {
                  return NavigationActionPolicy.ALLOW;
                } else {
                  // Open external links in the default browser
                  await launch(uri.toString());
                  return NavigationActionPolicy.CANCEL;
                }
              },
            ),
            Positioned(
              bottom: 16.0,
              left: 16.0,
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                backgroundColor: Color(0xFF1E9FFD),
                child: Icon(Icons.arrow_back),
              ),
            ),
          ],
        ),
      ),
    );
  }
}






class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  late TextEditingController _mcaController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>(); // Add a GlobalKey

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(0.2, 1.0, curve: Curves.easeInOut),
    ));

    _animationController.forward();
    _mcaController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.black,
      statusBarIconBrightness: Brightness.light,
    ));

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 14.0, top: 32.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.arrow_back,
                          color: Color(0xFF0396FE),
                          size: 24,
                        ),
                        SizedBox(width: 2.0),
                        Text(
                          'Back',
                          style: TextStyle(
                            color: Color(0xFF0396FE),
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                          child: SlideTransition(
                            position: _slideAnimation,
                            child: FadeTransition(
                              opacity: _fadeAnimation,
                              child: Image.network(
                                'https://rtfapi.modicare.com/img/ModicareIcon@3x.png',
                                width: 200,
                                height: 200,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20.0),
                        SlideTransition(
                          position: _slideAnimation,
                          child: FadeTransition(
                            opacity: _fadeAnimation,
                            child: Text(
                              'Reset Password?',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10.0),
                        SlideTransition(
                          position: _slideAnimation,
                          child: FadeTransition(
                            opacity: _fadeAnimation,
                            child: Form(
                              key: _formKey, // Add the key here
                              child: Column(
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width * 0.8,
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          color: Color(0xFFf5eded),
                                          width: 1.0,
                                        ),
                                      ),
                                    ),
                                    child: TextFormField(
                                      controller: _mcaController,
                                      decoration: InputDecoration(
                                        hintText: 'MCA No.',
                                        border: InputBorder.none,
                                        contentPadding: EdgeInsets.zero,
                                      ),
                                      keyboardType: TextInputType.number,
                                      inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter.digitsOnly,
                                      ],
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter MCA No.';
                                        }
                                        return null;
                                      },
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14.0,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10.0),
                                  ElevatedButton(
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        // Handle form submission
                                        // Access MCA No. using _mcaController.text
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      foregroundColor: Colors.transparent, padding: EdgeInsets.symmetric(
                                      vertical: 10.0,
                                      horizontal: 25.0,
                                    ), backgroundColor: Colors.transparent,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(50.0),
                                      ),
                                      side: BorderSide.none,
                                      minimumSize: Size(50.0, 50.0),
                                    ).copyWith(
                                      overlayColor: MaterialStateProperty.all(
                                        Colors.white.withOpacity(0.2),
                                      ),
                                    ),
                                    child: Ink(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Color(0xFF1FA2FF),
                                            Color(0xFF12D8FA),
                                            Color(0xFF1FA2FF),
                                          ],
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight,
                                        ),
                                        borderRadius: BorderRadius.circular(50.0),
                                      ),
                                      child: Container(
                                        width: 150.0,
                                        padding: EdgeInsets.symmetric(
                                          vertical: 10.0,
                                          horizontal: 25.0,
                                        ),
                                        child: Text(
                                          'Submit',
                                          style: TextStyle(
                                            fontSize: 14.0,
                                            color: Colors.white,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}