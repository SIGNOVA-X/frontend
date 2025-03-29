import 'package:flutter/material.dart';
import 'package:signova/components/header.dart';
import 'package:signova/components/input.dart';

class Formscreen extends StatefulWidget {
  const Formscreen({super.key});

  @override
  State<Formscreen> createState() => _FormscreenState();
}

class _FormscreenState extends State<Formscreen> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          buildHeader(screenHeight, screenWidth),
          Align(
            alignment: Alignment.center,
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(
                  top: screenHeight * 0.1, // 10% of screen height
                  left: screenWidth * 0.05, // 5% of screen width
                  right: screenWidth * 0.05, // 5% of screen width
                ),
                child: buildForm(screenHeight, screenWidth),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget buildForm(screenHeight, screenWidth) {
  final double questionFontSize = screenWidth * 0.05; // 5% of screen width
  final double spacing = screenHeight * 0.02; // 2% of screen height

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Center(
        child: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'FO',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w800, // Extra Bold
                  fontSize: screenWidth * 0.1, // 10% of screen width
                  color: Color(0xFF000000), // Black color for the first letter
                ),
              ),
              TextSpan(
                text: 'RM',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w800, // Extra Bold
                  fontSize: screenWidth * 0.1, // 10% of screen width
                  color: Color(0xFFAA69E3), // Purple color for the rest
                ),
              ),
            ],
          ),
        ),
      ),
      SizedBox(height: spacing),
      buildQuestionWithInput(
        question: '1. What’s your gender identity?',
        placeholder: 'Ex - Male/Female/Other',
        questionFontSize: questionFontSize,
        spacing: spacing,
      ),
      buildQuestionWithInput(
        question: '2. How young are you?',
        placeholder: 'Ex - 25',
        questionFontSize: questionFontSize,
        spacing: spacing,
      ),
      buildQuestionWithInput(
        question: '3. What’s your phone number?',
        placeholder: 'Ex - +1234567890',
        questionFontSize: questionFontSize,
        spacing: spacing,
      ),
      buildQuestionWithInput(
        question: '4. What’s your profession?',
        placeholder: 'Ex - Engineer',
        questionFontSize: questionFontSize,
        spacing: spacing,
      ),
      buildQuestionWithInput(
        question: '5. What are your hobbies?',
        placeholder: 'Ex - Reading, Traveling',
        questionFontSize: questionFontSize,
        spacing: spacing,
      ),
      buildQuestionWithInput(
        question: '6. Where do you dream of traveling?',
        placeholder: 'Ex - Paris',
        questionFontSize: questionFontSize,
        spacing: spacing,
      ),
      buildQuestionWithInput(
        question: '7. What’s your favorite pet?',
        placeholder: 'Ex - Dog',
        questionFontSize: questionFontSize,
        spacing: spacing,
      ),
    ],
  );
}

Widget buildQuestionWithInput({
  required String question,
  required String placeholder,
  required double questionFontSize,
  required double spacing,
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
      buildInputField(placeholder),
      SizedBox(height: spacing),
    ],
  );
}