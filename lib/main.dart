import 'dart:async';
import 'dart:developer';

// import 'package:another_telephony/telephony.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shake_detector/shake_detector.dart';
import 'package:signova/screens/chatbotscreen.dart';
import 'package:signova/screens/communicationscreen.dart';
import 'package:signova/screens/homecommunityscreen.dart';
import 'package:signova/screens/landingscreen.dart';
import 'package:signova/screens/loginscreen.dart';
import 'package:signova/screens/profilescreen.dart';
import 'package:signova/screens/signupscreen.dart';
import 'package:signova/screens/formscreen.dart';
import 'package:signova/screens/splashscreen.dart';
import 'package:telephony_sms/telephony_sms.dart';
import 'package:toastification/toastification.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

late List<CameraDescription> _cameras;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await dotenv.load(fileName: ".env");
  _cameras = await availableCameras();
  await GetStorage.init();
  runApp(ToastificationWrapper(child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final String message = "Emergency! Please help!";
  final String phoneNumber = "+917842226345";
  // final List<String> emergencyContacts = [
  //   "+917842226345",
  // ]; //check this after

  // Location variables
  Position? _currentPosition;
  late ShakeDetector detector;
  int shakeCount = 0;
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  //! shake detector
  void _initializeShakeDetector() async {
    log("inside shake detector function");
    detector = ShakeDetector.autoStart(
      shakeCountResetTime: 1000,
      minimumShakeCount: 2,
      shakeThresholdGravity: 2.7,
      onShake: () {
        shakeCount++;
        log("shake detected!: $shakeCount");
        if (shakeCount >= 2) {
          log("here");
          WidgetsBinding.instance.addPostFrameCallback((_) {
            log("here for toast");
            final currentContext = navigatorKey.currentContext;
            log(currentContext.toString());
            if (navigatorKey.currentContext != null) {
              toastification.show(
                context: navigatorKey.currentContext!,
                title: Text("Shake detected 2 times"),
                autoCloseDuration: Duration(seconds: 3),
                backgroundColor: Colors.white,
                type: ToastificationType.info,
              );
              sendEmergencySMS();
            } else {
              log("some error in context");
            }
          });
        }
      },
    );
  }

  //! Function to send an emergency SMS
  Future<void> sendEmergencySMS() async {
    if (_currentPosition == null) {
      log("Location not available. Cannot send SMS.");
      return;
    }
    log("reached in sendemergencysms function");
    String locationMessage =
        "Emergency! My current location is: https://www.google.com/maps/search/?api=1&query=${_currentPosition!.latitude},${_currentPosition!.longitude}";
    log(locationMessage);
    try {
      final TelephonySMS telephony = TelephonySMS();
      log(telephony.toString());
      // Request SMS permission
      await telephony.requestPermission();
      // Send SMS without using return value
      telephony.sendSMS(
        phone: phoneNumber, // Recipient's phone number
        message: locationMessage,
      );
      log("SMS Sent: $locationMessage");
    } catch (error) {
      log("Error sending SMS: $error");
    }
  }

  //! Get the current location
  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;
    log("reached here");
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      log('Location services are disabled');
    }

    permission = await Geolocator.checkPermission();
    log("hellloooo");
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        log("Location permission denied");
      }
    }

    if (permission == LocationPermission.deniedForever) {
      log('Location permissions are permanently denied');
    }

    Position position = await Geolocator.getCurrentPosition();
    log("latitude : ${position.latitude.toString()}");
    log("latitude : ${position.longitude.toString()}");

    setState(() {
      _currentPosition = position;
    });

    // initialize shake +  SMS function
    _initializeShakeDetector();
  }

  @override
  void dispose() {
    detector.stopListening();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
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
        '/communication': (context) => CommunicationScreen(_cameras),
        '/profile': (context) => ProfileScreen(),
        '/chatbot': (context) => ChatbotScreen(),
        '/form': (context) => Formscreen(),
      },
    );
  }
}
