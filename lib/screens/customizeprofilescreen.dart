import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:fluttermoji/fluttermoji.dart';
import 'package:get/get.dart';
import 'package:signova/components/crud.dart';
import 'package:toastification/toastification.dart';

class CustomizeProfileScreen extends StatefulWidget {
  final bool redirectToHome; // Parameter to decide navigation
  const CustomizeProfileScreen({Key? key, required this.redirectToHome})
    : super(key: key);

  @override
  _CustomizeProfileScreenState createState() => _CustomizeProfileScreenState();
}

class _CustomizeProfileScreenState extends State<CustomizeProfileScreen> {
  String? userid;

  @override
  void initState() {
    super.initState();
    Get.put(FluttermojiController());
    fetchUserId();
  }

  void fetchUserId() async {
    log(readStorage('username'));
    String? userId = readStorage('username');

    log(userId);
    if (userId.isEmpty) {
      log("User ID is null or empty!");
      return;
    }
    setState(() {
      userid = userId;
    });
    log(" user id : $userid!");
  }

  @override
  Widget build(BuildContext context) {
    double sizeWidth = MediaQuery.of(context).size.width;
    double sizeHeight = MediaQuery.of(context).size.height;
    final Map<String, dynamic>? args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    final bool redirectToHome =
        args?['redirectToHome'] ?? true; // Default to true

    Future<void> saveAvatar() async {
      if (userid == null) {
        log("Username is not set");
        return;
      }
      log("Saving avatar for $userid");
      String? avatar = await updateUsersWithUser(userid!);
      log("Avatar saved!");
      toastification.show(
        context: context,
        title: Text("Avatar successfully created"),
        description: Text("You can see your profile!"),
        type: ToastificationType.success,
        autoCloseDuration: Duration(seconds: 2),
      );
      log("yelloooo");
      log(redirectToHome.toString());

      if (redirectToHome) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/home-community',
          (route) => false,
        );
      } else {
        Navigator.pop(context); // Return to Profile Screen
      }
    }

    return Scaffold(
      appBar: AppBar(title: Text("Customize Avatar")),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: sizeHeight / 35),
                child: FluttermojiCircleAvatar(
                  radius: 100,
                  backgroundColor: Colors.grey[200],
                ),
              ),
              SizedBox(
                width: sizeWidth * 0.85,
                child: Row(
                  children: [
                    Text(
                      "Customize:",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Spacer(),
                    FluttermojiSaveWidget(onTap: saveAvatar),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 30,
                ),
                child: FluttermojiCustomizer(
                  scaffoldWidth: sizeWidth * 0.85,
                  autosave: false,
                  theme: FluttermojiThemeData(
                    boxDecoration: BoxDecoration(boxShadow: [BoxShadow()]),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
