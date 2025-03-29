import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:signova/screens/chatbotscreen.dart';
import 'package:signova/screens/communicationscreen.dart';
import 'package:signova/screens/homecommunityscreen.dart';
import 'package:signova/screens/landingscreen.dart';
import 'package:signova/screens/loginscreen.dart';
import 'package:signova/screens/profilescreen.dart';
import 'package:signova/screens/signupscreen.dart';
import 'package:signova/screens/formscreen.dart';
import 'package:signova/screens/splashscreen.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Signova',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => SplashScreen(),
        '/': (context) => LandingScreen(),
        '/login': (context) => LoginScreen(),
        '/signup': (context) => SignupScreen(),
        '/home-community': (context) => HomeCommunityScreen(),
        '/communication': (context) => CommunicationScreen(),
        '/profile': (context) => ProfileScreen(),
        '/chatbot': (context) => ChatbotScreen(),
        '/form': (context) => Formscreen(),
      },
    );
  }
}
