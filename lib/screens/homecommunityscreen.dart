import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:signova/components/buttons.dart';
import 'package:signova/components/crud.dart';
import 'package:signova/components/navbar.dart';
import 'package:signova/model/profile.dart';

class HomeCommunityScreen extends StatefulWidget {
  const HomeCommunityScreen({super.key});

  @override
  State<HomeCommunityScreen> createState() => _HomeCommunityScreenState();
}

class _HomeCommunityScreenState extends State<HomeCommunityScreen> {
  String? username;
  final List<bool> isSelected = [true, false];
  int _selectedIndex = 0;
  final List<Profile> profiles = [
    Profile(
      userId: 'jacqueline.gooding@gmail.com',
      userName: "Jacqueline Gooding",
      profileImageString: '',
    ),
    Profile(
      userId: 'willie.reeves@gmail.com',
      userName: "Willie Reeves",
      profileImageString: 'assets/images/profile.png',
    ),
    Profile(
      userId: 'leila.moore@gmail.com',
      userName: "Leila Moore",
      profileImageString: 'assets/images/profile.png',
    ),
    Profile(
      userId: 'hallie.hessler@gmail.com',
      userName: "Hallie Hessler",
      profileImageString: 'assets/images/profile.png',
    ),
  ];

  @override
  void initState() {
    super.initState();
    fetchUserName();
    fetchProfiles();
  }

  void fetchProfiles() async {
    log("Fetching user data in HomeCommunityScreen...");

    // Fetch the logged-in user's username
    String userId = readStorage('username');
    Map<String, dynamic>? userData = await getUserDetails(userId);

    if (userData != null) {
      // log("User Data: $userData");

      setState(() {
        username = userData['name'] ?? 'Guest';
      });

      log("Updating profiles with fetched avatars...");

      // Fetch and update each profile with the correct avatar
      for (int i = 0; i < profiles.length; i++) {
        Map<String, dynamic>? profileData = await getUserDetails(
          profiles[i].userId,
        );

        if (profileData != null) {
          log("yester");
          log(profileData['name']);
          log(profileData['avatar'] ?? '');
          setState(() {
            profiles[i] = Profile(
              userId: profiles[i].userId,
              userName: profileData['name'] ?? profiles[i].userName,
              profileImageString:
                  profileData['avatar'] ?? '', // Store SVG string
            );
          });

          log(
            "Updated profile ${profiles[i].userId} with avatar: ${profiles[i].profileImageString}",
          );
        }
      }
    } else {
      setState(() {
        username = 'Guest';
      });
      log("User not found!");
    }
  }

  void fetchUserName() async {
    log(profiles.toString());
    log("inside fetchusername function home community");
    log(readStorage('username'));
    String userId = readStorage('username');
    Map<String, dynamic>? userData = await getUserDetails(userId);
    if (userData != null) {
      log("User Data: $userData");
      log("Name: ${userData['name']}");
      setState(() {
        username = userData['name'] ?? 'Guest';
      });
    } else {
      setState(() {
        username = 'Jane';
      });
      log("User not found!");
    }
  }

  void _onTabChange(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // Navigate based on selected index
    switch (index) {
      case 0:
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/communication');
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/chatbot');
        break;
      case 4:
        Navigator.pushReplacementNamed(context, '/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    double sizeHeight = MediaQuery.of(context).size.height;
    double sizeWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Row(
          children: [
            Text(
              "Welcome",
              style: GoogleFonts.inter(
                color: Colors.black,
                fontSize: sizeWidth / 23,
                letterSpacing: 0.4,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(width: sizeWidth / 90),
            Text(
              '$username!',
              style: GoogleFonts.inter(
                color: Color.fromRGBO(140, 58, 207, 1),
                fontSize: sizeWidth / 23,
                letterSpacing: 0.4,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Center(
            child: ToggleButtons(
              constraints: BoxConstraints(minWidth: sizeWidth * 0.4),
              color: Colors.black,
              selectedColor: Colors.white,
              fillColor: Color.fromRGBO(140, 58, 207, 1),
              // borderColor: Colors.black,
              // selectedBorderColor: Color.fromRGBO(88, 41, 122, 1.0),
              borderWidth: 3,
              borderRadius: BorderRadius.circular(20.0),
              onPressed: (int index) {
                setState(() {
                  isSelected[index] = true;
                  isSelected[(index - 1).abs()] = false;
                });
              },
              isSelected: isSelected,
              children: [
                Padding(
                  padding: EdgeInsets.all(sizeWidth * sizeHeight * 0.00002),
                  child: Text("Recommended", style: GoogleFonts.inter()),
                ),
                Padding(
                  padding: EdgeInsets.all(sizeWidth * sizeHeight * 0.00002),
                  child: Text("New", style: GoogleFonts.inter()),
                ),
              ],
            ),
          ),
          Container(
            height: sizeHeight / 1.4,
            width: sizeWidth,
            // padding: EdgeInsets.only(left: sizeWidth / 12, top: sizeHeight / 8),
            margin: EdgeInsets.all(sizeWidth / 85),
            child: ListView(
              padding: EdgeInsets.only(
                right: sizeWidth / 30,
                left: sizeWidth / 30,
                top: sizeHeight / 40,
                bottom: sizeHeight / 40,
              ),
              children: [
                profileScroll(sizeWidth, sizeHeight, profiles),
                SizedBox(height: sizeHeight / 55),
                communitymessages(sizeHeight, sizeWidth),
                SizedBox(height: sizeHeight / 55),
                communitymessages(sizeHeight, sizeWidth),
                SizedBox(height: sizeHeight / 55),
                communitymessages(sizeHeight, sizeWidth),
                SizedBox(height: sizeHeight / 55),
                communitymessages(sizeHeight, sizeWidth),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(sizeWidth * sizeHeight * 0.00002),
        child: gbottomnavbar(context, _selectedIndex, _onTabChange),
      ),
    );
  }
}
