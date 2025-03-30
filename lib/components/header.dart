import 'package:flutter/material.dart';

Widget buildHeader(double screenHeight, double screenWidth) {
    return Padding(
      padding: EdgeInsets.only(top: screenHeight * 0.03, left: screenWidth * 0.04),
      child: RichText(
        text: const TextSpan(
          style: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w800, // Extra bold
            fontSize: 35,
          ),
          children: [
            TextSpan(
              text: 'Hello',
              style: TextStyle(color: Color(0xFF000000)), // Black
            ),
            TextSpan(
              text: '!',
              style: TextStyle(color: Color(0xFFAA69E3)), // Purple
            ),
          ],
        ),
      ),
    );
  }