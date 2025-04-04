import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:signova/components/buttons.dart';
import 'package:signova/components/crud.dart';
import 'package:signova/components/input.dart';
import 'package:signova/components/header.dart';
import 'package:signova/components/snackbar.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          buildHeader(screenHeight, screenWidth),
          Align(
            alignment: Alignment.bottomCenter,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: buildLoginForm(screenHeight, screenWidth),
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
        const Text(
          'Welcome Back',
          style: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w400, // Regular
            fontSize: 25,
            color: Color(0xFF474747), // Gray
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
              buildInputField('Enter your email', controller: emailController),
              SizedBox(height: screenHeight * 0.02),
              buildInputField(
                'Enter a password',
                isPassword: true,
                controller: passwordController,
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
                        formData['favoritePerson'] ?? "+917842226345";
                    log("Favorite Person: $favoritePerson");
                  } else {
                    log("No form data found.");
                  }
                  writeStorage('emergency_contact', favoritePerson!);
                  if (storedUser.isNotEmpty) {
                    Navigator.pushNamed(context, '/home-community');
                  } else {
                    showCustomSnackBar(
                      context,
                      'Failed to store username. Try again.',
                    );
                  }
                },
              ),
              SizedBox(height: screenHeight * 0.01),
              const Text(
                'Forgot password?',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                  fontSize: 11,
                  color: Color(0xFF474747),
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              const Text(
                'Log In with socials',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                  fontSize: 11,
                  color: Color(0xFF474747),
                ),
              ),
              SizedBox(height: screenHeight * 0.01),
              buildSocialButtons(context, screenWidth),
              SizedBox(height: screenHeight * 0.02),
            ],
          ),
        ),
      ],
    );
  }
}
