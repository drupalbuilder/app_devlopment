import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:t2t1/forgetpass.dart';
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
    runApp(const MyApp());
  });
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

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

  LoginScreen({super.key});

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
              builder: (context) => const MainScreen(),
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
        if (kDebugMode) {
          print('Error: $error');
        }
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
                color: const Color(0xFFFFFFFF),
                child: Padding(
                  padding: const EdgeInsets.only(left: 4.0, top: 100.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(14.0),
                        color: const Color(0xFFFDFDFD),
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
                        padding: const EdgeInsets.only(
                            left: 14.0, right: 8.0, top: 8.0),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const MobileLoginScreen()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 10.0), backgroundColor: const Color(0xFF1FA2FF),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                          ),
                          child: const Text(
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
                        color: const Color(0xFFFFFFFF),
                        child: Padding(
                          padding: const EdgeInsets.all(14.0),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width * 0.55,
                                  decoration: const BoxDecoration(
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
                                    decoration: const InputDecoration(
                                      labelText: 'MCA No.',
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16.0),
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
                                        gradient: const LinearGradient(
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
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8.0, horizontal: 24.0),
                                        child: const Text(
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
                                const SizedBox(height: 16.0),
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const WebViewExample(
                                              url: 'https://www.modicare.com/join-us',
                                            ),
                                      ),
                                    );
                                  },
                                  child: const Text(
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
                                          const ForgotPasswordScreen()),
                                    );
                                  },
                                  child: const Text(
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
                  decoration: const BoxDecoration(
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
  const OTPEntryScreen({super.key});

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
        const SnackBar(
          content: Text("Please enter OTP."),
        ),
      );
      return;
    }

    bool verificationSuccess = await verifyOTP(enteredOTP); // Call using this
    if (verificationSuccess) {
      // OTP verified successfully
      if (kDebugMode) {
        print("OTP verified successfully.");
      }
      // Navigate to MainScreen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainScreen()),
      );
    } else {
      // Incorrect OTP, show error message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
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
        if (kDebugMode) {
          if (kDebugMode) {
            print('Stored response body not found in SharedPreferences.');
          }
        }
        return false; // Response body not found in SharedPreferences
      }

      // Replace "sent": true with "otp": "entered_otp"
      String modifiedData = storedResponseBody.replaceAll(
          RegExp(r'"sent"\s*:\s*true'), '"otp": "$otp"');
      // Log the modified request data for debugging
      if (kDebugMode) {
        if (kDebugMode) {
          print('Modified Request Data: $modifiedData');
        }
      }

      // Send the modified response data to the backend
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: modifiedData,
      );
      if (kDebugMode) {
        print('Request Sent to API Endpoint.');
      }

      if (response.statusCode == 200) {
        // OTP verification successful
        // Parse response JSON
        Map<String, dynamic> responseData = json.decode(response.body);

        // Check if the response indicates a successful OTP verification
        if (responseData['valid'] == true) {
          // OTP verified successfully
          if (kDebugMode) {
            print('OTP verified successfully.');
          }

          // Log the response body for debugging
          if (kDebugMode) {
            print('Response from API: ${response.body}');
          }

          return true;
        } else {
          // OTP verification failed
          if (kDebugMode) {
            print('Invalid OTP. Please enter a valid OTP.');
          }
          return false;
        }
      } else {
        // OTP verification failed due to non-200 status code
        if (kDebugMode) {
          print('Failed to verify OTP. Status code: ${response.statusCode}');
        }
        return false;
      }
    } catch (error) {
      // Handle network errors
      if (kDebugMode) {
        print("Error verifying OTP: $error");
      }
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Enter OTP',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (int i = 0; i < 5; i++)
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: TextField(
                        controller: _otpControllers[i],
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        maxLength: 1,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 14.0, // Adjust the font size as needed
                          fontWeight: FontWeight.bold,
                          color: Colors.black, // Text color
                        ),
                        decoration: InputDecoration(
                          counterText: '',
                          contentPadding: const EdgeInsets.all(12.0), // Inner padding
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.black, width: 2.0),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.green, width: 2.0),
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
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: submitOTP,
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}



class MobileLoginScreen extends StatefulWidget {
  const MobileLoginScreen({super.key});

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
      if (kDebugMode) {
        print('Request: $requestBody');
      }
      if (kDebugMode) {
        print('Response status code: ${response.statusCode}');
      }
      if (kDebugMode) {
        print('Response body: ${response.body}');
      }

      // Check if the request was successful (status code 200)
      if (response.statusCode == 200) {
        // Parse the response body
        Map<String, dynamic> responseData = jsonDecode(response.body);

        // Log the parsed response data
        if (kDebugMode) {
          print('Parsed response data: $responseData');
        }

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
              return const OTPEntryScreen();
            },
          );

          // Print the response when OTP is sent successfully
          if (kDebugMode) {
            print('Response when OTP sent successfully: $responseData');
          }

          return true; // OTP sent successfully
        }
      }

      // OTP sending failed
      setState(() {
        otpResponse = "Failed to send OTP";
      });
      // Print error message if needed
      if (kDebugMode) {
        if (kDebugMode) {
          print(response.body);
        }
      }

      return false; // OTP sending failed

    } catch (error) {
      // Handle any errors that occurred during the request
      setState(() {
        otpResponse = "Error sending OTP: $error";
      });
      if (kDebugMode) {
        if (kDebugMode) {
          if (kDebugMode) {
            print('Error sending OTP: $error');
          }
        }
      }
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
                color: const Color(0xFFFFFFFF),
                child: Padding(
                  padding: const EdgeInsets.only(left: 4.0, top: 100.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(14.0),
                        color: const Color(0xFFFFFFFF),
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
                        padding: const EdgeInsets.only(left: 14.0, right: 8.0, top: 8.0),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => LoginScreen()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
                            backgroundColor: const Color(0xFF1FA2FF),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                          ),
                          child: const Text(
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
                        color: const Color(0xFFFDFDFD),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 14.0, right: 14.0),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width * 0.55,
                                  decoration: const BoxDecoration(
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
                                    decoration: const InputDecoration(
                                      labelText: 'Mobile Number',
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16.0),
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
                                        gradient: const LinearGradient(
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
                                        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 14.0),
                                        child: const Text(
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
                                const SizedBox(height: 0.0),
                                Text(
                                  otpResponse, // Display OTP response message
                                  style: const TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 16.0),
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const WebViewExample(
                                          url: 'https://www.modicare.com/join-us',
                                        ),
                                      ),
                                    );
                                  },
                                  child: const Text(
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
                                      MaterialPageRoute(builder: (context) => const ForgotPasswordScreen()),
                                    );
                                  },
                                  child: const Text(
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
                  decoration: const BoxDecoration(
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

  const WebViewExample({super.key, required this.url});
  @override
  Widget build(BuildContext context) {
    // Set the status bar color
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
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
                  await launchUrl(uri.toString() as Uri);
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
                backgroundColor: const Color(0xFF1E9FFD),
                child: const Icon(Icons.arrow_back),
              ),
            ),
          ],
        ),
      ),
    );
  }
}





