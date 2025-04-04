import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/landing_background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Spacer(flex: 2), // Push content down to position SIGNOVA-X above center
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'SIGNOVA-',
                      style: GoogleFonts.italiana(
                        fontSize: screenWidth * 0.15,
                        color: Colors.white,
                      ),
                    ),
                    TextSpan(
                      text: 'X',
                      style: GoogleFonts.italiana(
                        fontSize: screenWidth * 0.15,
                        color: const Color(0xFFAF98BF),
                      ),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                'Empowering Conversations Beyond Words',
                style: GoogleFonts.inter(
                  fontSize: screenWidth * 0.035,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              Spacer(flex: 3),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1), // Add horizontal padding
                child: Text(
                  'A seamless communication platform bridging the gap for the deaf and mute community.',
                  style: GoogleFonts.inter(
                    fontSize: screenWidth * 0.03,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center, // Ensure proper alignment for multi-line text
                ),
              ),
              SizedBox(
                width: min(screenWidth * 0.015, 30),
                height: min(screenHeight * 0.015, 30),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: screenHeight * 0.05),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: screenWidth * 0.4, // Set fixed width for both buttons
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFFAF98BF), Color(0xFF5A189A)],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/signup');
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            padding: EdgeInsets.symmetric(
                              vertical: screenHeight * 0.02,
                            ),
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                          ),
                          child: Text(
                            'Get Started',
                            style: GoogleFonts.inter(
                              fontSize: screenWidth * 0.045,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.05), // Space between buttons
                    SizedBox(
                      width: screenWidth * 0.4, // Set fixed width for both buttons
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFFAF98BF), Color(0xFF5A189A)],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/login');
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            padding: EdgeInsets.symmetric(
                              vertical: screenHeight * 0.02,
                            ),
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                          ),
                          child: Text(
                            'Log In',
                            style: GoogleFonts.inter(
                              fontSize: screenWidth * 0.045,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
