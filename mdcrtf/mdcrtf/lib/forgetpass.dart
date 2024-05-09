import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:t2t1/firsttime/welcomescreen.dart';
import 'package:flutter/services.dart';



class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

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
      duration: const Duration(milliseconds: 500),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
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
      curve: const Interval(0.2, 1.0, curve: Curves.easeInOut),
    ));

    _animationController.forward();
    _mcaController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
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
                    child: const Row(
                      children: [
                        Icon(
                          Icons.arrow_back_ios,
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
                        const SizedBox(height: 20.0),
                        SlideTransition(
                          position: _slideAnimation,
                          child: FadeTransition(
                            opacity: _fadeAnimation,
                            child: const Text(
                              'Reset Password?',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10.0),
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
                                      decoration: const InputDecoration(
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
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 14.0,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10.0),
                                  ElevatedButton(
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        // Handle form submission
                                        // Access MCA No. using _mcaController.text
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      foregroundColor: Colors.transparent, padding: const EdgeInsets.symmetric(
                                      vertical: 10.0,
                                      horizontal: 25.0,
                                    ), backgroundColor: Colors.transparent,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(50.0),
                                      ),
                                      side: BorderSide.none,
                                      minimumSize: const Size(50.0, 50.0),
                                    ).copyWith(
                                      overlayColor: MaterialStateProperty.all(
                                        Colors.white.withOpacity(0.2),
                                      ),
                                    ),
                                    child: Ink(
                                      decoration: BoxDecoration(
                                        gradient: const LinearGradient(
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
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 10.0,
                                          horizontal: 25.0,
                                        ),
                                        child: const Text(
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
                                  const SizedBox(height: 40.0),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Welcomescreen()),
                                      ); // Add your action here

                                    },
                                    style: ElevatedButton.styleFrom(
                                      foregroundColor: Colors.transparent, padding: const EdgeInsets.symmetric(
                                      vertical: 10.0,
                                      horizontal: 25.0,
                                    ), backgroundColor: Colors.transparent,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(50.0),
                                      ),
                                      side: BorderSide.none,
                                      minimumSize: const Size(50.0, 50.0),
                                    ).copyWith(
                                      overlayColor: MaterialStateProperty.all(
                                        Colors.white.withOpacity(0.2),
                                      ),
                                    ),
                                    child: Ink(
                                      decoration: BoxDecoration(
                                        gradient: const LinearGradient(
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
                                        width: 200.0,
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 10.0,
                                          horizontal: 25.0,
                                        ),
                                        child: const Text(
                                          'WELCOME TO MDC',
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