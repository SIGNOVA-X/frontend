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

Widget buildInputField(
  String placeholder, {
  required TextEditingController controller,
  bool isPassword = false,
  required Color borderColor,
  required Color placeholderColor,
  required Color focusedPlaceholderColor,
  required Color textColor,
  required FontWeight fontWeight,
  required Color focusedbackgroundColor,
  required Color unfocusedbackgroundColor,
}) {
  return StatefulBuilder(
    builder: (BuildContext context, StateSetter setState) {
      bool isObscured = isPassword; // Track password visibility

      return Focus(
        child: Builder(
          builder: (context) {
            final hasFocus = Focus.of(context).hasFocus;
            return TextField(
              controller: controller,
              obscureText: isObscured,
              style: TextStyle(
                color: textColor,
                fontWeight: fontWeight,
              ),
              decoration: InputDecoration(
                hintText: placeholder,
                hintStyle: TextStyle(
                  color: hasFocus
                      ? const Color(0xFF474747).withOpacity(0.5)
                      : placeholderColor,
                  fontWeight: fontWeight,
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: borderColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: borderColor),
                ),
                filled: true,
                fillColor: hasFocus ? Colors.white : Colors.transparent,
                suffixIcon: isPassword
                    ? IconButton(
                        icon: Icon(
                          isObscured ? Icons.visibility_off : Icons.visibility,
                          color:isObscured ?  const Color(0xFF474747) : Colors.red,
                        ),
                        onPressed: () {
                          setState(() {
                            isObscured = !isObscured; // Toggle visibility
                          });
                        },
                      )
                    : null,
              ),
            );
          },
        ),
      );
    },
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

