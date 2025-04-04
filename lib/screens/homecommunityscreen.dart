import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
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
  List<Profile> profiles = [];

  @override
  void initState() {
    super.initState();
    fetchUserName();
    fetchProfiles();
  }

  void fetchProfiles() async {
    print("Fetching user data in HomeCommunityScreen...");

    // Fetch the logged-in user's username
    String userId = readStorage('username');
    Map<String, dynamic>? userData = await getUserDetails(userId);

    if (userData != null) {
      setState(() {
        username = userData['name'] ?? 'Guest';
      });

      print("Fetching profiles using getProfilesByNames...");

      String userId = readStorage('username');
      Map<String, dynamic>? userDataFirebase = await getUserInformation(userId);
      print("User Data: $userDataFirebase");
      const url = 'https://b90d-117-219-22-193.ngrok-free.app/recommend';

      final body = {
        'username': username,
        'age': userDataFirebase?['age'] ?? 25,
        'job': userDataFirebase?['job'] ?? "Engineer",
        'sex': userDataFirebase?['sex'] ?? 'f',
        'language': userDataFirebase?['language'] ?? 'en',
        'interests': userDataFirebase?['interests'] ?? 'football',
        'other_interests': userDataFirebase?['other_interests'] ?? 'swimming',
      };
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(body),
      );

      // Parse the response body to extract the recommended users
      final responseData = json.decode(response.body);
      List<String> recommendedUsers = List<String>.from(
        responseData['recommended_users'],
      );

      // Call the function from crud.dart to fetch profiles
      List<Profile> fetchedProfiles = await getProfilesByNames(
        recommendedUsers,
      );

      setState(() {
        profiles = fetchedProfiles;
      });

      print("Profiles fetched: ${profiles.length}");
    } else {
      setState(() {
        username = 'Guest';
      });
      print("User not found!");
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
      bottomNavigationBar: gbottomnavbar(context, _selectedIndex),
    );
  }
}
