import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
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
      var ngrokurl = dotenv.env['NGROK_URL']!;
      var url = '$ngrokurl/recommend';

      final body = {
        'username': username,
        'age': userDataFirebase?['age'] ?? 25,
        'job': userDataFirebase?['job'] ?? "Engineer",
        'sex': userDataFirebase?['sex'] ?? 'f',
        'language': userDataFirebase?['language'] ?? 'en',
        'interests': userDataFirebase?['interests'] ?? 'football',
        'other_interests': userDataFirebase?['other_interests'] ?? 'swimming',
      };
      log("hellooo");
      log(body.toString());
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
      log("hereeee");
      log(recommendedUsers.toString());
      // Call the function from crud.dart to fetch profiles
      List<Profile> fetchedProfiles = await getProfilesByNames(
        recommendedUsers,
      );
      log("hiiiii");
      log(fetchedProfiles.toString());
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
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: sizeHeight / 4,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/community_top_bg.png'),
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/community_bg.png'),
                  fit: BoxFit.cover,
                  opacity: 0.8,
                ),
              ),
            ),
          ),
          Column(
            children: [
              SizedBox(height: sizeHeight / 15),
              Row(
                children: [
                  SizedBox(width: sizeWidth / 35),
                  Text(
                    "Welcome",
                    style: GoogleFonts.lifeSavers(
                      color: Colors.black,
                      fontSize: sizeWidth / 13,
                      letterSpacing: 0.4,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  SizedBox(width: sizeWidth / 25),
                  Text(
                    '$username!',
                    style: GoogleFonts.lifeSavers(
                      color: Colors.white,
                      fontSize: sizeWidth / 13,
                      letterSpacing: 0.4,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              Center(
                child: Container(
                  height: sizeHeight / 1.34,
                  width: sizeWidth,
                  margin: EdgeInsets.symmetric(
                    vertical: sizeWidth / 45,
                    horizontal: sizeWidth / 35,
                  ),
                  child: ScrollConfiguration(
                    behavior: NoGlowScrollBehavior(),
                    child: ListView(
                      physics: BouncingScrollPhysics(),
                      padding: EdgeInsets.only(
                        right: sizeWidth / 30,
                        left: sizeWidth / 30,
                        top: sizeHeight / 90,
                        bottom: sizeHeight / 90,
                      ),
                      children: [
                        SizedBox(height: sizeHeight / 55),
                        Container(
                          margin: EdgeInsets.only(left: sizeWidth / 40),
                          child: Text(
                            "Suggestions",
                            style: GoogleFonts.inter(
                              color: Color.fromRGBO(225, 225, 225, 0.9),
                            ),
                          ),
                        ),
                        SizedBox(height: sizeHeight / 55),
                        profileScroll(sizeWidth, sizeHeight, profiles),
                        SizedBox(height: sizeHeight / 55),
                        // communitymessages(sizeHeight, sizeWidth),
                        GlassArticleCard(
                          sizeHeight: MediaQuery.of(context).size.height,
                          sizeWidth: MediaQuery.of(context).size.width,
                        ),
                        SizedBox(height: sizeHeight / 55),
                        // communitymessages(sizeHeight, sizeWidth),
                        GlassArticleCard(
                          sizeHeight: MediaQuery.of(context).size.height,
                          sizeWidth: MediaQuery.of(context).size.width,
                        ),
                        SizedBox(height: sizeHeight / 55),
                        // communitymessages(sizeHeight, sizeWidth),
                        GlassArticleCard(
                          sizeHeight: MediaQuery.of(context).size.height,
                          sizeWidth: MediaQuery.of(context).size.width,
                        ),
                        SizedBox(height: sizeHeight / 55),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      // ),
      bottomNavigationBar: gbottomnavbar(context, _selectedIndex),
    );
  }
}

class NoGlowScrollBehavior extends ScrollBehavior {
  Widget buildViewportChrome(
    BuildContext context,
    Widget child,
    AxisDirection axisDirection,
  ) {
    return child;
  }
}
