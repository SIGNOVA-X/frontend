import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart'; // Add this import for playing sound
import 'package:google_fonts/google_fonts.dart'; // Import Google Fonts

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  final AudioPlayer _audioPlayer = AudioPlayer(); // Initialize AudioPlayer

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _animation = Tween<double>(
      begin: 1.0, // Start at normal size
      end: 1.5,  // Zoom in
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward(); // Play the zoom-in animation

    // Play the sound effect with corrected asset path and file extension
    _audioPlayer.play(AssetSource('sound/intro.mp3')).catchError((error) {
      print('Error playing audio: $error'); // Log any errors
    });

    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, '/'); // Navigate to HomeScreen
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _audioPlayer.dispose(); // Dispose the audio player
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD9BDF5),
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            ScaleTransition(
              scale: _animation,
              child: Image.asset('assets/images/signovax.png'),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.8, // Position below the logo
              child: ScaleTransition(
                scale: _animation, // Apply the same animation to the text
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'SIGNOVA-',
                        style: GoogleFonts.italiana(
                          fontSize: 40,
                          color: Colors.white.withOpacity(0.5), // White with 50% opacity
                        ),
                      ),
                      TextSpan(
                        text: 'X',
                        style: GoogleFonts.italiana(
                          fontSize: 40,
                          color: Color(0xFFAF98BF), // AF98BF color
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
    );
  }
}
