import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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
  required Color buttonColor,
  required Color iconColor,
}) {
  return ElevatedButton(
    onPressed: () {},
    style: ElevatedButton.styleFrom(
      backgroundColor: buttonColor, // Use buttonColor parameter
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
            : Icon(icon, color: iconColor, size: 35), // Use iconColor parameter
  );
}

Widget buildSignupLoginButton(
  BuildContext context,
  double screenWidth,
  double screenHeight,
  String displaytext,
  VoidCallback onPressed, {
  required Color color,
  required Color textColor,
  required FontWeight fontWeight,
}) {
  return ElevatedButton(
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(
      backgroundColor: color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      minimumSize: Size(screenWidth * 0.8, screenHeight * 0.06),
    ),
    child: Text(
      displaytext,
      style: TextStyle(
        fontFamily: 'Inter',
        fontWeight: fontWeight,
        fontSize: 20,
        color: textColor,
      ),
    ),
  );
}

Widget buildSocialButtons(
  BuildContext context,
  double screenWidth, {
  required Color buttonColor,
  required Color iconColor,
}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      _buildSocialButton(
        context,
        'assets/images/google.png',

        buttonColor: buttonColor,
        iconColor: iconColor,
      ),
      SizedBox(width: screenWidth * 0.05),
      _buildSocialButton(
        context,
        'assets/images/facebook.png',

        buttonColor: buttonColor,
        iconColor: iconColor,
      ),
    ],
  );
}

Widget profileBox(
  double sizeWidth,
  double sizeHeight,
  String profilename,
  String svgstring,
) {
  return Padding(
    padding: EdgeInsets.all(sizeWidth / 40),
    child: Column(
      children: [
        Container(
          width: sizeWidth / 4.5, // Ensure fixed width for circle
          height: sizeWidth / 4.5, // Ensure fixed height for circle
          decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(color: Colors.black, width: 1.2),
            // boxShadow: [
            //   BoxShadow(
            //     color: Color.fromRGBO(0, 0, 0, 0.15),
            //     blurRadius: sizeHeight / 200,
            //     offset: Offset(0, 3.5),
            //   ),
            // ],
            shape: BoxShape.circle,
          ),
          child: ClipOval(
            child: SvgPicture.string(
              svgstring,
              width: sizeWidth / 7,
              height: sizeWidth / 7,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Text(
          profilename,
          style: GoogleFonts.inter(
            color: Colors.black,
            fontSize: sizeWidth / 33,
          ),
        ),
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
        return profileBox(
          sizeWidth,
          sizeHeight,
          profiles[index].userName,
          profiles[index].profileImageString!,
        );
      },
    ),
  );
}

class ToggleButtonComponent extends StatelessWidget {
  final List<bool> isSelected;
  final List<String> labels;
  final Function(int) onPressed;
  final double? fontSize;
  final double? padding;

  const ToggleButtonComponent({
    Key? key,
    required this.isSelected,
    required this.labels,
    required this.onPressed,
    this.fontSize,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ToggleButtons(
      constraints: BoxConstraints(
        minWidth: MediaQuery.of(context).size.width / 6,
      ),
      color: Colors.white,
      selectedColor: Colors.white,
      fillColor: Color.fromRGBO(99, 0, 126, 1),
      renderBorder: true,
      borderWidth: 1,
      borderColor: Colors.white,
      selectedBorderColor: Colors.white,
      borderRadius: BorderRadius.circular(15.0),
      onPressed: onPressed,
      isSelected: isSelected,
      children:
          labels
              .map(
                (label) => Container(
                  padding: EdgeInsets.all(
                    padding ??
                        MediaQuery.of(context).size.width *
                            MediaQuery.of(context).size.height *
                            0.00004,
                  ),
                  child: Text(
                    label,
                    style: GoogleFonts.inter(
                      fontSize:
                          fontSize ?? MediaQuery.of(context).size.height / 65,
                    ),
                  ),
                ),
              )
              .toList(),
    );
  }
}

Widget profileFields(
  double sizeHeight,
  double sizeWidth,
  String labelString,
  IconData iconString,
  String fieldValue,
) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: EdgeInsets.only(
          top: sizeHeight / 120,
          right: sizeWidth / 10,
          left: sizeWidth / 10,
        ),
        child: Text(
          labelString,
          style: GoogleFonts.inter(
            color: Colors.white,
            fontSize: sizeHeight / 80,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      Container(
        alignment: Alignment.center,
        margin: EdgeInsets.symmetric(
          vertical: sizeHeight / 120,
          horizontal: sizeWidth / 10,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: sizeWidth / 22,
          vertical: sizeHeight / 65,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Color.fromRGBO(171, 171, 171, 1)),
        ),
        child: Row(
          children: [
            Icon(
              iconString,
              color: Color.fromRGBO(171, 171, 171, 1),
              size: sizeHeight / 40,
            ),
            SizedBox(width: sizeWidth / 25),
            Text(
              fieldValue,
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: sizeHeight / 66,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

Widget logoutbutton(double sizeHeight, double sizeWidth) {
  return Container(
    margin: EdgeInsets.symmetric(
      vertical: sizeHeight / 60,
      horizontal: sizeWidth / 10,
    ),
    padding: EdgeInsets.symmetric(
      horizontal: sizeWidth / 20,
      vertical: sizeHeight / 60,
    ),
    alignment: Alignment.center,
    decoration: BoxDecoration(
      border: Border.all(color: Color.fromRGBO(140, 58, 207, 1)),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Text(
      "LOGOUT",
      style: GoogleFonts.inter(
        color: Colors.white,
        fontWeight: FontWeight.w800,
        fontSize: sizeHeight / 50,
      ),
    ),
  );
}
