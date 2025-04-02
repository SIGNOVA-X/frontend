// Import the material package for InputDecoration
import 'package:flutter/material.dart';

InputDecoration _inputBoxDecoration(String hintText) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(
        fontFamily: 'Inter',
        fontWeight: FontWeight.w700, // Bold
        fontSize: 15,
        color: Color(0xFF474747).withOpacity(0.5), // Placeholder color with 50% opacity
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0), // Rounded rectangle
        borderSide: BorderSide(
          color: Color(0xFFDEA2FF), // Border color
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide(
          color: Color(0xFFDEA2FF),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide(
          color: Color(0xFFDEA2FF),
        ),
      ),
    );
    }

Widget buildInputField(String hintText, {bool isPassword = false, required TextEditingController controller}) {
    return TextField(
      obscureText: isPassword,
      controller: controller, // Use the controller for real-time updates
      decoration: _inputBoxDecoration(hintText),
      style: const TextStyle(
        fontFamily: 'Inter',
        fontWeight: FontWeight.w500, // Medium
        fontSize: 15,
        color: Colors.black, // Input text color
      ),
    );
}

Widget buildQuestionWithInput({
  required String question,
  required String placeholder,
  required double questionFontSize,
  required double spacing,
  required TextEditingController controller, // Pass controller to access value
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        question,
        style: TextStyle(
          fontFamily: 'Inter',
          fontWeight: FontWeight.bold, // Bold
          fontSize: questionFontSize,
          color: Color(0xFF000000), // Black color
        ),
      ),
      SizedBox(height: spacing * 0.5),
      TextField(
        controller: controller, // Use controller for input
        decoration: _inputBoxDecoration(placeholder),
        style: const TextStyle(
          fontFamily: 'Inter',
          fontWeight: FontWeight.w500, // Medium
          fontSize: 15,
          color: Colors.black, // Input text color
        ),
      ),
      SizedBox(height: spacing),
    ],
  );
}

