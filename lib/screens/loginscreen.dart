import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:signova/components/buttons.dart';
import 'package:signova/components/crud.dart';
import 'package:signova/components/input.dart';
import 'package:signova/components/snackbar.dart';
import 'package:signova/model/drag_handler.dart'; // Import DragHandler

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  late DragHandler dragHandler;
  double _blurHeight =
      0.65 *
      WidgetsBinding.instance.window.physicalSize.height /
      WidgetsBinding.instance.window.devicePixelRatio;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    dragHandler = DragHandler(
      initialHeightFactor: 0.65,
      maxHeightFactor: 1.0,
    ); // Initialize DragHandler
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = Tween<double>(
      begin: _blurHeight,
      end: _blurHeight,
    ).animate(_animationController);
  }

  void _onVerticalDragUpdate(DragUpdateDetails details) {
    setState(() {
      _blurHeight = dragHandler.handleDragUpdate(
        details: details,
        context: context,
        currentHeight: _blurHeight,
      );
    });
  }

  void _onVerticalDragEnd(DragEndDetails details) {
    _animation = dragHandler.handleDragEnd(
      animationController: _animationController,
      context: context,
      currentHeight: _blurHeight,
    )..addListener(() {
      setState(() {
        _blurHeight = _animation.value;
      });
    });
    _animationController.forward(from: 0.0);
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/signup_background.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: GestureDetector(
              onVerticalDragUpdate: _onVerticalDragUpdate,
              onVerticalDragEnd: _onVerticalDragEnd,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: _blurHeight,
                curve: Curves.easeOut,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(50.0),
                    topRight: Radius.circular(50.0),
                  ),
                  child: Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/blur_background.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(
                        16.0,
                        64.0,
                        16.0,
                        0,
                      ), // Increased top padding
                      child: SingleChildScrollView(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: _blurHeight - 64,
                          ),
                          child: IntrinsicHeight(
                            child: buildLoginForm(screenHeight, screenWidth),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildLoginForm(double screenHeight, double screenWidth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Welcome Back',
          style: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w400, // Regular
            fontSize: 25,
            color: Color(0xFFFFFFFF).withOpacity(0.5), // Gray
          ),
        ),
        const Text(
          'Log In',
          style: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w700, // Bold
            fontSize: 60,
            color: Color(0xFF000000), // Black
          ),
        ),
        SizedBox(height: screenHeight * 0.03),
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              buildInputField(
                'Enter your email',
                controller: emailController,
                borderColor: const Color(0xFFDEA2FF),
                placeholderColor: const Color(0xFFFFFFFF),
                focusedPlaceholderColor: const Color(
                  0xFF474747,
                ).withOpacity(0.5),
                textColor: const Color(0xFF000000),
                fontWeight: FontWeight.w700,
                focusedbackgroundColor: Colors.transparent,
                unfocusedbackgroundColor: const Color(0xFFD9D9D9),
              ),
              SizedBox(height: screenHeight * 0.02),
              buildInputField(
                'Enter a password',
                isPassword: true,
                controller: passwordController,
                borderColor: const Color(0xFFDEA2FF),
                placeholderColor: const Color(0xFFFFFFFF),
                focusedPlaceholderColor: const Color(
                  0xFF474747,
                ).withOpacity(0.5),
                textColor: const Color(0xFF000000),
                fontWeight: FontWeight.w700,
                focusedbackgroundColor: Colors.transparent,
                unfocusedbackgroundColor: const Color(0xFFD9D9D9),
              ),
              SizedBox(height: screenHeight * 0.02),
              buildSignupLoginButton(
                context,
                screenWidth,
                screenHeight,
                'Log In',
                () async {
                  final email = emailController.text.trim();
                  final password = passwordController.text.trim();

                  if (email.isEmpty || password.isEmpty) {
                    showCustomSnackBar(context, 'Please Fill Required Details');
                    return;
                  }
                  if (!(await validateUserCredentials(email, password))) {
                    showCustomSnackBar(context, 'Invalid email or password');
                    return;
                  }
                  log("email : ${email}");
                  writeStorage('username', email);

                  String storedUser = readStorage('username');
                  log("stored user :$storedUser");

                  // setting emergency contact
                  Map<String, dynamic>? formData = await getFormData();
                  String? favoritePerson;
                  if (formData != null) {
                    favoritePerson =
                        formData['emergency_contact'] ?? "+917842226345";
                    log("Favorite Person: $favoritePerson");
                  } else {
                    log("No form data found.");
                  }
                  writeStorage('emergency_contact', favoritePerson!);
                  var checkec = readStorage('emergency_contact');
                  log("emergency: $checkec");
                  if (storedUser.isNotEmpty) {
                    Navigator.pushNamed(context, '/home-community');
                  } else {
                    showCustomSnackBar(
                      context,
                      'Failed to store username. Try again.',
                    );
                  }
                },
                color: const Color(0xFFAA69E3),
                textColor: const Color(0xFFFFFFFF),
                fontWeight: FontWeight.w700,
              ),
              SizedBox(height: screenHeight * 0.01),
              const Text(
                'Forgot password?',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                  fontSize: 11,
                  color: Color(0xB3FFFFFF),
                ),
              ),
              SizedBox(height: screenHeight * 0.03),
              const Text(
                'Log In with socials',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                  fontSize: 11,
                  color: Color(0xB3FFFFFF),
                ),
              ),
              SizedBox(height: screenHeight * 0.01),
              buildSocialButtons(
                context,
                screenWidth,
                buttonColor: const Color(0xFF474747).withOpacity(0.5),
                iconColor: const Color(0xFFFFFFFF),
              ),
              SizedBox(height: screenHeight * 0.02),
            ],
          ),
        ),
      ],
    );
  }
}
