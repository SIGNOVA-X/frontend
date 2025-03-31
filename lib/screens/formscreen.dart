import 'package:flutter/material.dart';
import 'package:signova/components/crud.dart';
import 'package:signova/components/header.dart';
import 'package:signova/components/input.dart';
import 'package:signova/components/snackbar.dart';

class Formscreen extends StatefulWidget {
  const Formscreen({super.key});

  @override
  State<Formscreen> createState() => _FormscreenState();
}

class _FormscreenState extends State<Formscreen> {
  // Define TextEditingControllers for each input field
  final TextEditingController genderController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController professionController = TextEditingController();
  final TextEditingController hobbiesController = TextEditingController();
  final TextEditingController travelController = TextEditingController();
  final TextEditingController petController = TextEditingController();
  final TextEditingController favoritePersonController = TextEditingController();

  @override
  void dispose() {
    // Dispose controllers to free up resources
    genderController.dispose();
    ageController.dispose();
    phoneController.dispose();
    professionController.dispose();
    hobbiesController.dispose();
    travelController.dispose();
    petController.dispose();
    favoritePersonController.dispose();
    super.dispose();
  }

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
                  child: buildForm(screenHeight, screenWidth, context, genderController, ageController, phoneController, professionController, hobbiesController, travelController, petController, favoritePersonController),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget buildForm(screenHeight, screenWidth, context, TextEditingController genderController, TextEditingController ageController, TextEditingController phoneController, TextEditingController professionController, TextEditingController hobbiesController, TextEditingController travelController, TextEditingController petController, TextEditingController favoritePersonController) {
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
        controller: genderController,
      ),
      buildQuestionWithInput(
        question: '2. How young are you?',
        placeholder: 'Ex - 25',
        questionFontSize: questionFontSize,
        spacing: spacing,
        controller: ageController,
      ),
      buildQuestionWithInput(
        question: '3. What’s your phone number?',
        placeholder: 'Ex - +1234567890',
        questionFontSize: questionFontSize,
        spacing: spacing,
        controller: phoneController,
      ),
      buildQuestionWithInput(
        question: '4. What’s your profession?',
        placeholder: 'Ex - Engineer',
        questionFontSize: questionFontSize,
        spacing: spacing,
        controller: professionController,
      ),
      buildQuestionWithInput(
        question: '5. What are your hobbies?',
        placeholder: 'Ex - Reading, Traveling',
        questionFontSize: questionFontSize,
        spacing: spacing,
        controller: hobbiesController,
      ),
      buildQuestionWithInput(
        question: '6. Where do you dream of traveling?',
        placeholder: 'Ex - Paris',
        questionFontSize: questionFontSize,
        spacing: spacing,
        controller: travelController,
      ),
      buildQuestionWithInput(
        question: '7. What’s your favorite pet?',
        placeholder: 'Ex - Dog',
        questionFontSize: questionFontSize,
        spacing: spacing,
        controller: petController,
      ),
      buildQuestionWithInput(
        question: '8. What’s the number of your favourite person?',
        placeholder: 'Ex - +1234567890 (BFF’s number)',
        questionFontSize: questionFontSize,
        spacing: spacing,
        controller: favoritePersonController,
      ),
       Center(
         child: ElevatedButton(
                              onPressed: () async {
                                if (genderController.text.isEmpty ||
                                    ageController.text.isEmpty ||
                                    phoneController.text.isEmpty ||
                                    professionController.text.isEmpty ||
                                    hobbiesController.text.isEmpty ||
                                    travelController.text.isEmpty ||
                                    petController.text.isEmpty ||
                                    favoritePersonController.text.isEmpty) {
                                  showCustomSnackBar(context, 'Please fill all the fields');
                                  return;
                                }

                                final formData = {
                                  'gender': genderController.text,
                                  'age': ageController.text,
                                  'phone': phoneController.text,
                                  'profession': professionController.text,
                                  'hobbies': hobbiesController.text,
                                  'travel': travelController.text,
                                  'pet': petController.text,
                                  'favoritePerson': favoritePersonController.text,
                                };

                               await storeFormData(formData); // Replace 'userId' with the actual user ID
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

Widget buildQuestionWithInput({
  required String question,
  required String placeholder,
  required double questionFontSize,
  required double spacing,
  required TextEditingController controller, // Add controller parameter
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        question,
        style: TextStyle(
          fontFamily: 'Inter',
          fontWeight: FontWeight.w600,
          fontSize: questionFontSize,
        ),
      ),
      SizedBox(height: spacing),
      TextField(
        controller: controller, // Assign the controller to the TextField
        decoration: InputDecoration(
          hintText: placeholder,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ),
      SizedBox(height: spacing),
    ],
  );
}

