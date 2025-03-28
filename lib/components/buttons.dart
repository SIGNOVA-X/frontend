import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';

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
            communityprofileimage(sizeHeight, sizeWidth, 'assets/profile.png'),
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
