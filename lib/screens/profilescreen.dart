import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttermoji/fluttermojiCircleAvatar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:signova/components/buttons.dart';
import 'package:signova/components/crud.dart';
import 'package:signova/components/navbar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _selectedIndex = 4;
  String? username;
  String? useremail;
  String? userphoneno;
  String? avatarJson;

  @override
  void initState() {
    super.initState();
    fetchUser();
  }

  void fetchUser() async {
    log(readStorage('username'));
    String? userId = readStorage('username');
    if (userId.isEmpty) {
      log("User ID is null or empty!");
      setState(() {
        username = 'Guest';
        useremail = "guest@gmail.com";
        userphoneno = "+01 234 567 89";
      });
      return; // Stop execution if userId is invalid
    }
    log("Fetching user details for ID: $userId");
    Map<String, dynamic>? userData = await getUserDetails(userId);
    Map<String, dynamic>? formData = await getFormData();
    if (userData != null && formData != null) {
      log("User Data: $userData");
      log("Name: ${userData['name']}");
      setState(() {
        username = userData['name'] ?? 'Guest';
        useremail = userId;
        userphoneno = formData['phone'] ?? "+01 234 567 89";
        avatarJson = userData['avatar'] ?? "assests/images/profile.png";
      });
    } else {
      setState(() {
        username = 'Guest';
        useremail = "guest@gmail.com";
        userphoneno = "+01 234 567 89";
        avatarJson = "assests/images/profile.png";
      });
      log("User or form data not found!");
    }
  }

  @override
  Widget build(BuildContext context) {
    double sizeHeight = MediaQuery.of(context).size.height;
    double sizeWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        actions: [
          SizedBox(width: sizeWidth / 12),
          Container(
            height: sizeHeight / 20,
            width: sizeWidth / 4,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'My Posts',
              style: GoogleFonts.inter(color: Colors.white),
            ),
          ),
          SizedBox(width: sizeWidth / 12),
        ],
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromRGBO(111, 47, 185, 1),
              Color.fromRGBO(0, 0, 0, 1),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              child: ClipPath(
                clipper: BottomRoundedClipper(),
                child: Container(
                  height: sizeHeight / 3.5,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    image: DecorationImage(
                      image: AssetImage('assets/images/profile_bg.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    top: sizeWidth / 2.5,
                    right: sizeWidth / 3,
                    left: sizeWidth / 3,
                    bottom: sizeHeight / 90,
                  ),
                  child:
                      avatarJson != null
                          ? FluttermojiCircleAvatar(
                            backgroundColor: Colors.grey[200]!,
                            radius: sizeWidth / 6,
                          )
                          : circleButton(
                            sizeHeight * 2,
                            sizeWidth * 2,
                            'assets/images/profile.png',
                            false,
                          ),
                ),
                Text(
                  username ?? "guest",
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: sizeWidth / 16,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Text("${useremail} | "), Text("$userphoneno")],
                ),

                Container(
                  margin: EdgeInsets.only(
                    top: sizeHeight / 50,
                    right: sizeWidth / 20,
                    left: sizeWidth / 20,
                    bottom: sizeHeight / 70,
                  ),
                  padding: EdgeInsets.all(sizeHeight / 50),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, 0.1),
                        blurRadius: sizeWidth / 200,
                        offset: Offset(0, 2.5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/customize-profile',
                            arguments: {'redirectToHome': false},
                          );
                        },
                        child: Row(
                          children: [
                            Icon((MingCute.profile_line)),
                            SizedBox(width: sizeWidth / 14),
                            Text("Edit profile information"),
                          ],
                        ),
                      ),
                      SizedBox(height: sizeHeight / 120),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon((Clarity.bell_line)),
                          Text("Notifications"),
                          SizedBox(width: sizeWidth / 4),
                          Text(
                            "ON",
                            style: GoogleFonts.inter(
                              color: Color.fromRGBO(21, 115, 254, 1.0),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: sizeHeight / 120),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon((Icons.translate_outlined)),
                          Text("Language"),
                          SizedBox(width: sizeWidth / 4),
                          Text(
                            "English",
                            style: GoogleFonts.inter(
                              color: Color.fromRGBO(21, 115, 254, 1.0),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    top: sizeHeight / 50,
                    right: sizeWidth / 20,
                    left: sizeWidth / 20,
                    bottom: sizeHeight / 70,
                  ),
                  padding: EdgeInsets.all(sizeHeight / 50),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, 0.1),
                        blurRadius: sizeWidth / 200,
                        offset: Offset(0, 2.5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon((Icons.contact_support_outlined)),
                          SizedBox(width: sizeWidth / 14),
                          Text("Emergency Contact"),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    top: sizeHeight / 50,
                    right: sizeWidth / 20,
                    left: sizeWidth / 20,
                    bottom: sizeHeight / 180,
                  ),
                  padding: EdgeInsets.all(sizeHeight / 50),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, 0.1),
                        blurRadius: sizeWidth / 200,
                        offset: Offset(0, 2.5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon((Icons.support_agent_outlined)),
                          SizedBox(width: sizeWidth / 14),
                          Text("Help & Support"),
                        ],
                      ),
                      SizedBox(height: sizeHeight / 120),
                      Row(
                        children: [
                          Icon((Icons.contact_support)),
                          SizedBox(width: sizeWidth / 14),
                          Text("Contact us"),
                        ],
                      ),
                      SizedBox(height: sizeHeight / 120),

                      Row(
                        children: [
                          Icon((Icons.lock_clock_outlined)),
                          SizedBox(width: sizeWidth / 14),
                          Text("Privacy Policy"),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: gbottomnavbar(context, _selectedIndex),
    );
  }
}

class BottomRoundedClipper extends CustomClipper<Path> {
  final double borderRadius;

  BottomRoundedClipper({this.borderRadius = 40.0});

  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(0, size.height - borderRadius);
    path.quadraticBezierTo(0, size.height, borderRadius, size.height);
    path.lineTo(size.width - borderRadius, size.height);
    path.quadraticBezierTo(
      size.width,
      size.height,
      size.width,
      size.height - borderRadius,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

// class TopCircleClipper extends CustomClipper<Path> {
//   @override
//   Path getClip(Size size) {
//     Path path = Path();
//     path.lineTo(0, size.height - 100);
//     path.quadraticBezierTo(
//       size.width / 2,
//       size.height,
//       size.width,
//       size.height - 100,
//     );
//     path.lineTo(size.width, 0);
//     path.close();
//     return path;
//   }

//   @override
//   bool shouldReclip(CustomClipper<Path> oldClipper) => false;
// }
