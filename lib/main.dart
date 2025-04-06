import 'dart:async';
import 'dart:developer';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shake_detector/shake_detector.dart';
import 'package:signova/components/crud.dart';
import 'package:signova/screens/chatbotscreen.dart';
import 'package:signova/screens/communicationscreen.dart';
import 'package:signova/screens/customizeprofilescreen.dart';
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

  // Location variables
  Position? _currentPosition;
  late ShakeDetector detector;
  int shakeCount = 0;
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    writeStorage('emergency_contact', '+917842226345');
    _getCurrentLocation();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeShakeDetector();
    });
  }

  //! shake detector
  void _initializeShakeDetector() async {
    log("inside shake detector function");
    detector = ShakeDetector.autoStart(
      shakeCountResetTime: 1000,
      minimumShakeCount: 2,
      shakeThresholdGravity: 1.5,
      onShake: () {
        shakeCount++;
        log("shake detected!: $shakeCount");
        if (shakeCount >= 2) {
          log("here");
          WidgetsBinding.instance.addPostFrameCallback((_) async {
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
              await sendEmergencySMS();
              shakeCount = 0;
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
    String emergencyNumber = readStorage('emergency_contact');
    log(emergencyNumber);
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
        phone: emergencyNumber, // Recipient's phone number
        message: locationMessage,
      );
      log("SMS Sent: $locationMessage");
      toastification.show(
        context: navigatorKey.currentContext!,
        title: Text("SMS sent to emergency contact!"),
        autoCloseDuration: Duration(seconds: 3),
        backgroundColor: Colors.white,
        type: ToastificationType.info,
      );
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
    // _initializeShakeDetector();
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
      title: 'SignovaX',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      onGenerateRoute: (settings) {
        Widget page;
        switch (settings.name) {
          case '/splash':
            page = SplashScreen();
            break;
          case '/':
            page = LandingScreen();
            break;
          case '/login':
            page = LoginScreen();
            break;
          case '/signup':
            page = SignupScreen();
            break;
          case '/home-community':
            page = HomeCommunityScreen();
            break;
          case '/communication':
            page = CommunicationScreen(_cameras);
            break;
          case '/profile':
            page = ProfileScreen();
            break;
          case '/chatbot':
            page = ChatbotScreen();
            break;
          case '/form':
            page = Formscreen();
            break;
          case '/customize-profile':
            final args = settings.arguments as Map<String, dynamic>?;
            page = CustomizeProfileScreen(
              redirectToHome: args?['redirectToHome'] ?? true,
            );
            break;
          default:
            throw Exception('Unknown route: ${settings.name}');
        }

        return createTransitionRoute(page);
      },
      initialRoute: '/splash',
    );
  }

  Route createTransitionRoute(Widget page) {
    return PageRouteBuilder(
      transitionDuration: Duration(milliseconds: 900),
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curve = CurvedAnimation(
          parent: animation,
          curve: Curves.easeInOutBack,
        );
        return FadeTransition(
          opacity: curve,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: Offset(0.2, 0.0),
              end: Offset.zero,
            ).animate(curve),
            child: child,
          ),
        );
      },
    );
  }
}
