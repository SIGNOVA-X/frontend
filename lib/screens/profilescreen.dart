import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttermoji/fluttermojiCircleAvatar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:signova/components/buttons.dart';
import 'package:signova/components/crud.dart';
import 'package:signova/components/navbar.dart';
import 'package:signova/screens/landingscreen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _selectedIndex = 4;
  String? username = "Guest";
  String? useremail = "guest@gmail.com";
  String? userphoneno = "+01 234 567 89";
  String? emergency_contact = "+91 1234567890";
  String? avatarJson;
  String? userpassword = "**";
  String? userbio;

  @override
  void initState() {
    super.initState();
    fetchUser();
  }

  void fetchUser() async {
    log(readStorage('username'));
    String? userId = readStorage('username');
    var emergency = readStorage('emergency_contact');
    log(emergency);
    if (userId.isEmpty) {
      log("User ID is null or empty!");
      return;
    }
    log("Fetching user details for ID: $userId");
    Map<String, dynamic>? userData = await getUserDetails(userId);
    Map<String, dynamic>? formData = await getFormData();
    if (userData != null && formData != null) {
      log("Name: ${userData['name']}");
      String pass = userData['password'] ?? '**';
      pass = "*" * pass.length;
      log("password:$pass");
      setState(() {
        username = userData['name'] ?? 'Guest';
        useremail = userId;
        userpassword = pass;
        emergency_contact = formData['emergency_contact'];
        userphoneno = formData['phone'] ?? "+01 234 567 89";
        avatarJson = userData['avatar'] ?? "assests/images/profile.png";
        userbio =
            formData['bio'] ??
            "Hi I am a professional photographer and love to visit new places.";
      });
    } else {
      setState(() {
        username = 'Guest';
        useremail = "guest@gmail.com";
        userphoneno = "+01 234 567 89";
        avatarJson = "assests/images/profile.png";
        userpassword = "**";
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
                  padding: EdgeInsets.only(top: sizeHeight / 8),
                  child: Container(
                    height: sizeHeight / 10,
                    width: sizeWidth / 1.5,
                    alignment: Alignment.center,
                    child: Text(
                      (userbio != null && userbio!.length > 50)
                          ? '${userbio!.substring(0, 55)}...'
                          : (userbio ?? ''),
                      textAlign: TextAlign.center,
                      style: GoogleFonts.lifeSavers(
                        color: Colors.black,
                        fontWeight: FontWeight.w900,
                        fontSize: sizeWidth / 25,
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Text(
                          "1k",
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Followers",
                          style: GoogleFonts.inter(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        avatarJson != null
                            ? FluttermojiCircleAvatar(
                              backgroundColor: Colors.grey[200]!,
                              radius: sizeWidth / 8,
                            )
                            : circleButton(
                              sizeHeight * 2,
                              sizeWidth * 2,
                              'assets/images/profile.png',
                              false,
                            ),
                        SizedBox(height: sizeHeight / 200),
                        Text(
                          username ?? "guest",
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: sizeWidth / 20,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          "233",
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Following",
                          style: GoogleFonts.inter(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/customize-profile',
                      arguments: {'redirectToHome': false},
                    );
                  },
                  child: Container(
                    width: sizeWidth / 4,
                    height: sizeHeight / 30,
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(top: sizeHeight / 120),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      "Edit Profile",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: sizeWidth / 36,
                      ),
                    ),
                  ),
                ),
                profileFields(
                  sizeHeight,
                  sizeWidth,
                  "Email",
                  Icons.email_outlined,
                  useremail!,
                ),
                profileFields(
                  sizeHeight,
                  sizeWidth,
                  "Phone Number",
                  Icons.phone,
                  userphoneno!,
                ),
                profileFields(
                  sizeHeight,
                  sizeWidth,
                  "Emergency Contact",
                  Icons.do_disturb_on_outlined,
                  emergency_contact!,
                ),
                profileFields(
                  sizeHeight,
                  sizeWidth,
                  "Password",
                  TeenyIcons.password,
                  userpassword!,
                ),
                GestureDetector(
                  onTap: () {
                    writeStorage('username', '');
                    writeStorage('emergency_contact', '');

                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder:
                            (BuildContext context) => const LandingScreen(),
                      ),
                      (route) => false,
                    );
                  },
                  child: logoutbutton(sizeHeight, sizeWidth),
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
