import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';

import 'mainscreen.dart';



void main() {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter bindings are initialized

  // Set preferred screen orientations (portrait only)
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

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _mcaController = TextEditingController();
  final _passwordController = TextEditingController();

  void _onLoginButtonPressed() {
    if (_formKey.currentState?.validate() ?? false) {
      // Form is valid, navigate to the next page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainScreen()),
      );
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
                                vertical: 8.0, horizontal: 10.0),
                            primary: Color(0xFF1FA2FF),
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
                                  width: MediaQuery
                                      .of(context)
                                      .size
                                      .width * 0.55,
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: Color(0xFFf5eded),
                                        width: 1.0,
                                      ),
                                    ),
                                  ),
                                  child: TextFormField(
                                    controller: _passwordController,
                                    obscureText: true,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your password';
                                      }

                                      // Check if the password has a minimum length of 6 characters
                                      if (value.length < 6) {
                                        return 'Password must be at least 6 characters';
                                      }

                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      labelText: 'Password',
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 16.0),
                                Container(
                                  width: double.infinity,
                                  alignment: Alignment.centerLeft,
                                  child: ElevatedButton(
                                    onPressed: _onLoginButtonPressed,
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.transparent,
                                      onPrimary: Colors.transparent,
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
  final List<TextEditingController> _otpControllers = List.generate(6, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());

  @override
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    super.dispose();
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
                for (int i = 0; i < 6; i++)
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
              onPressed: () {
                String enteredOTP = _otpControllers.map((controller) => controller.text).join();
                if (enteredOTP == '253579') {
                  // Correct OTP, navigate to MainScreen
                  Navigator.pop(context); // Close the OTP entry screen
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => MainScreen()),
                  );
                }
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}

class MobileLoginScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _mobileController = TextEditingController();

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
                            primary: Color(0xFF1FA2FF),
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
                        color: Color(0xFFFFFFFF),
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
                                        // Show OTP entry screen
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return OTPEntryScreen();
                                          },
                                        );
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.transparent,
                                      onPrimary: Colors.transparent,
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
                                      padding: EdgeInsets.symmetric(
                                        vertical: 10.0,
                                        horizontal: 25.0,
                                      ),
                                      primary: Colors.transparent,
                                      onPrimary: Colors.transparent,
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