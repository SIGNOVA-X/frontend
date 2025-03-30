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
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: screenHeight * 0.8, // Limit to 80% of screen height
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(
                     // Reduced to 5% of screen height
                    left: screenWidth * 0.05, // 5% of screen width
                    right: screenWidth * 0.05, // 5% of screen width
                  ),
                  child: buildForm(screenHeight, screenWidth,context),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget buildForm(screenHeight, screenWidth,context) {
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
      buildQuestionWithInput(
        question: '8. What’s the number of your favourite person?',
        placeholder: 'Ex - +1234567890 (BFF’s number)',
        questionFontSize: questionFontSize,
        spacing: spacing,
      ),
       Center(
         child: ElevatedButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/home-community');
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFAA69E3),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                minimumSize: Size(screenWidth * 0.8, screenHeight * 0.06),
                              ),
                              child: const Text(
                                'Submit',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 20,
                                  color: Color(0xFFFFFFFF),
                                ),
                              ),
                            ),
       ),
    ],
  );
}

