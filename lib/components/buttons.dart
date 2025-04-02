import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:signova/model/profile.dart';

Widget circleButton(sizeHeight, sizeWidth, imagestring, bordercheck) {
  return Container(
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: Colors.transparent,
      border:
          bordercheck ? Border.all(color: Colors.grey, width: 1.0) : Border(),
      // borderRadius: BorderRadius.circular(12),
    ),
    child: Padding(
      padding: EdgeInsets.all(sizeHeight * sizeWidth / 300000),
      child: Image.asset(
        imagestring,
        fit: BoxFit.fill,
        height: sizeHeight / 13,
        width: sizeWidth / 2,
      ),
    ),
  );
}

Widget communityprofileimage(sizeHeight, sizeWidth, imagestring) {
  return Container(
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: Colors.transparent,
      // borderRadius: BorderRadius.circular(12),
    ),
    child: Padding(
      padding: EdgeInsets.all(sizeHeight / 300),
      child: Image.asset(
        imagestring,
        fit: BoxFit.fill,
        height: sizeHeight / 14,
        width: sizeWidth / 6,
      ),
    ),
  );
}

Widget communitymessages(sizeHeight, sizeWidth) {
  return Container(
    constraints: BoxConstraints(
      minHeight: sizeHeight / 9,
      minWidth: sizeWidth / 12,
    ),
    margin: EdgeInsets.all(sizeWidth / 45),
    padding: EdgeInsets.all(sizeHeight / 45),
    decoration: BoxDecoration(
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Color.fromRGBO(0, 0, 0, 0.2),
          blurRadius: sizeHeight / 200,
          offset: Offset(0, 2.5),
        ),
      ],
    ),
    child: Column(
      children: [
        Row(
          children: [
            communityprofileimage(
              sizeHeight,
              sizeWidth,
              'assets/images/profile.png',
            ),
            SizedBox(width: sizeWidth / 35),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "@marcelo20",
                  style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                ),
                Text(
                  "20 minutes ago",
                  style: GoogleFonts.inter(color: Color.fromRGBO(0, 0, 0, 0.5)),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: sizeHeight / 50),
        Text(
          "Nothing better than riding a bike with friends 😇 🥰",
          style: GoogleFonts.inter(),
        ),
        SizedBox(height: sizeHeight / 50),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              spacing: sizeWidth / 45,
              children: [
                Icon(Clarity.heart_line, color: Colors.black),
                Text("256"),
                Icon(Icons.comment_outlined, color: Colors.black),
                Text("5"),
              ],
            ),
            Row(
              spacing: sizeWidth / 45,
              children: [
                Icon(Icons.share, color: Colors.black),
                Icon(Bootstrap.bookmark, color: Colors.black),
              ],
            ),
          ],
        ),
      ],
    ),
  );
}

Widget _buildSocialButton(
  BuildContext context,
  String assetPath, {
  IconData? icon,
}) {
  return ElevatedButton(
    onPressed: () {},
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(
        0xFF474747,
      ).withOpacity(0.5), // Button color with 50% opacity
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0), // Rounded rectangle
      ),
      minimumSize: Size(
        MediaQuery.of(context).size.width * 0.4,
        MediaQuery.of(context).size.height * 0.05,
      ), // Dynamic button size
    ),
    child:
        assetPath.isNotEmpty
            ? Image.asset(assetPath, height: 24, width: 24) // Google image
            : Icon(icon, color: Colors.white, size: 35), // Facebook icon
  );
}

Widget buildSignupLoginButton(
  BuildContext context,
  double screenWidth,
  double screenHeight,
  String displaytext,
  VoidCallback onPressed,
) {
  return ElevatedButton(
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFFAA69E3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      minimumSize: Size(screenWidth * 0.8, screenHeight * 0.06),
    ),
    child: Text(
      displaytext,
      style: TextStyle(
        fontFamily: 'Inter',
        fontWeight: FontWeight.w700,
        fontSize: 20,
        color: Color(0xFFFFFFFF),
      ),
    ),
  );
}

Widget buildSocialButtons(BuildContext context, double screenWidth) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      _buildSocialButton(context, 'assets/images/google.png'),
      SizedBox(width: screenWidth * 0.02),
      _buildSocialButton(context, '', icon: Icons.facebook),
    ],
  );
}

Widget profileBox(double sizeWidth, double sizeHeight, String profilename) {
  return Padding(
    padding: EdgeInsets.all(sizeWidth / 30),
    child: Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(color: Colors.black, width: 1.2),
            boxShadow: [
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.15),
                blurRadius: sizeHeight / 200,
                offset: Offset(0, 3.5),
              ),
            ],
            shape: BoxShape.circle,
          ),
          child: communityprofileimage(
            sizeHeight,
            sizeWidth,
            'assets/images/profile.png',
          ),
        ),
        Text("marcelo", style: GoogleFonts.inter(color: Colors.black)),
      ],
    ),
  );
}

Widget profileScroll(
  double sizeWidth,
  double sizeHeight,
  List<Profile> profiles,
) {
  log(profiles.toString());
  if (profiles.isEmpty) {
    return Center(
      child: Text("No profiles available"), // Handle empty state
    );
  }
  return Container(
    height: sizeHeight / 7,
    width: sizeWidth / 30,
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: profiles.length,
      itemBuilder: (context, index) {
        return profileBox(sizeWidth, sizeHeight, profiles[index].userName);
      },
    ),
  );
}
