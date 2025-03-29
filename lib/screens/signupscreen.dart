import 'package:flutter/material.dart';
import 'package:signova/components/input.dart';
import 'package:signova/components/buttons.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(top: screenHeight * 0.02, left: screenWidth * 0.04),
            child: RichText(
              text: const TextSpan(
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w800, // Extra bold
                  fontSize: 35,
                ),
                children: [
                  TextSpan(
                    text: 'Hello',
                    style: TextStyle(color: Color(0xFF000000)), // Black
                  ),
                  TextSpan(
                    text: '!',
                    style: TextStyle(color: Color(0xFFAA69E3)), // Purple
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Join Us Today!',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400, // Regular
                        fontSize: 25,
                        color: Color(0xFF474747), // Gray
                      ),
                    ),
                    const Text(
                      'Sign Up',
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
                          buildInputField('Enter your full name'),
                          SizedBox(height: screenHeight * 0.02),
                          buildInputField('Enter your email'),
                          SizedBox(height: screenHeight * 0.02),
                          buildInputField('Create a password', isPassword: true),
                          SizedBox(height: screenHeight * 0.02),
                          buildInputField('Confirm your password', isPassword: true),
                          SizedBox(height: screenHeight * 0.02),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/form');
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFAA69E3),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              minimumSize: Size(screenWidth * 0.8, screenHeight * 0.06),
                            ),
                            child: const Text(
                              'Sign Up',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w700,
                                fontSize: 20,
                                color: Color(0xFFFFFFFF),
                              ),
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          const Text(
                            'Sign up with socials',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                              fontSize: 11,
                              color: Color(0xFF474747),
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          buildSocialButtons(context, screenWidth),
                          SizedBox(height: screenHeight * 0.02),
                          const Text(
                            'By signing up, you agree to our [Terms of Service] and [Privacy Policy].',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                              fontSize: 10,
                              color: Color(0xFF474747),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
