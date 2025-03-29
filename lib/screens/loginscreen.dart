import 'package:flutter/material.dart';
import 'package:signova/components/buttons.dart'; 
import 'package:signova/components/input.dart';
import 'package:signova/components/header.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
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
              buildInputField('Enter your email'),
              SizedBox(height: screenHeight * 0.02),
              buildInputField('Enter a password', isPassword: true),
              SizedBox(height: screenHeight * 0.02),
              buildSignupLoginButton(context,screenWidth, screenHeight, 'Log In','/home-community'),
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
              buildSocialButtons(context,screenWidth),
              SizedBox(height: screenHeight * 0.02),
            ],
          ),
        ),
      ],
    );
  }



}
