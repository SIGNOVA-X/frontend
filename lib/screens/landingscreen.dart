import 'package:flutter/material.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05), // Responsive horizontal padding
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image(
                image: AssetImage('assets/images/signovax.png'),
                width: screenWidth * 0.75, // Responsive image width
              ),
              SizedBox(height: screenHeight * 0.03), // Responsive spacing
              Text(
                'Welcome to',
                style: TextStyle(
                  fontSize: screenWidth * 0.06, // Responsive font size
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'SIG',
                      style: TextStyle(
                        fontSize: screenWidth * 0.12, // Responsive font size
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    TextSpan(
                      text: 'NOVA',
                      style: TextStyle(
                        fontSize: screenWidth * 0.12, // Responsive font size
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w700,
                        color: Color(0xFFAA69E3),
                      ),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                'Empowering Conversations Beyond Words',
                style: TextStyle(
                  fontSize: screenWidth * 0.035, // Responsive font size
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF474747),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: screenHeight * 0.02), // Responsive spacing
              Text(
                'A seamless communication platform bridging the gap for the deaf and mute community.',
                style: TextStyle(
                  fontSize: screenWidth * 0.035, // Responsive font size
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF474747),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: screenHeight * 0.05), // Responsive spacing
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/signup');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFAA69E3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      minimumSize: Size(screenWidth * 0.4, screenHeight * 0.05), // Responsive button size
                    ),
                    child: Text(
                      'Get Started',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: screenWidth * 0.04, // Responsive font size
                      ),
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.05), // Responsive spacing
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/login');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      side: BorderSide(color: Color(0xFFAA69E3)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      minimumSize: Size(screenWidth * 0.4, screenHeight * 0.05), // Responsive button size
                    ),
                    child: Text(
                      'Log in',
                      style: TextStyle(
                        color: Color(0xFF474747),
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.bold,
                        fontSize: screenWidth * 0.04, // Responsive font size
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
