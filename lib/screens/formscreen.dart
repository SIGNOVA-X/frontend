import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:signova/components/crud.dart';
import 'package:signova/components/header.dart';
import 'package:signova/components/input.dart';
import 'package:signova/components/snackbar.dart';
import 'package:signova/model/drag_handler.dart'; // Import DragHandler

class Formscreen extends StatefulWidget {
  const Formscreen({super.key});

  @override
  State<Formscreen> createState() => _FormscreenState();
}

class _FormscreenState extends State<Formscreen>
    with SingleTickerProviderStateMixin {
  // Define TextEditingControllers for each input field
  final TextEditingController bioController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController professionController = TextEditingController();
  final TextEditingController interestController = TextEditingController();
  final TextEditingController otherinterestsController =
      TextEditingController();
  final TextEditingController languageController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController emergencyNumberController =
      TextEditingController();

  late DragHandler dragHandler;
  double _blurHeight =
      0.8 *
      WidgetsBinding.instance.window.physicalSize.height /
      WidgetsBinding.instance.window.devicePixelRatio;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    dragHandler = DragHandler(
      initialHeightFactor: 0.8,
      maxHeightFactor: 1.0,
    ); // Initialize DragHandler
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = Tween<double>(
      begin: _blurHeight,
      end: _blurHeight,
    ).animate(_animationController);
  }

  void _onVerticalDragUpdate(DragUpdateDetails details) {
    setState(() {
      _blurHeight = dragHandler.handleDragUpdate(
        details: details,
        context: context,
        currentHeight: _blurHeight,
      );
    });
  }

  void _onVerticalDragEnd(DragEndDetails details) {
    _animation = dragHandler.handleDragEnd(
      animationController: _animationController,
      context: context,
      currentHeight: _blurHeight,
    )..addListener(() {
      setState(() {
        _blurHeight = _animation.value;
      });
    });
    _animationController.forward(from: 0.0);
  }

  @override
  void dispose() {
    // Dispose controllers to free up resources
    genderController.dispose();
    ageController.dispose();
    bioController.dispose();
    professionController.dispose();
    otherinterestsController.dispose();
    languageController.dispose();
    interestController.dispose();
    phoneNumberController.dispose();
    emergencyNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/signup_background.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: GestureDetector(
              onVerticalDragUpdate: _onVerticalDragUpdate,
              onVerticalDragEnd: _onVerticalDragEnd,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: _blurHeight,
                curve: Curves.easeOut,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(50.0),
                    topRight: Radius.circular(50.0),
                  ),
                  child: Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/blur_background.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(
                        16.0,
                        64.0,
                        16.0,
                        16.0,
                      ), // Increased top padding
                      child: SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        child: buildForm(
                          screenHeight,
                          screenWidth,
                          context,
                          genderController,
                          ageController,
                          bioController,
                          professionController,
                          otherinterestsController,
                          languageController,
                          interestController,
                          phoneNumberController,
                          emergencyNumberController,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget buildForm(
  screenHeight,
  screenWidth,
  context,
  TextEditingController genderController,
  TextEditingController ageController,
  TextEditingController bioController,
  TextEditingController professionController,
  TextEditingController otherinterestsController,
  TextEditingController languageController,
  TextEditingController interestController,
  TextEditingController phoneNumberController,
  TextEditingController emergencyNumberController,
) {
  final double questionFontSize = screenWidth * 0.08; // 5% of screen width
  final double spacing = screenHeight * 0.02; // 2% of screen height

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Center(
        child: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Tell us about yourself!',
                style: GoogleFonts.lifeSavers(
                  fontSize: questionFontSize,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF000000),
                ),
              ),
            ],
          ),
        ),
      ),
      SizedBox(height: spacing),
      buildInputField(
        'Bio',
        isPassword: false,
        controller: bioController,
        borderColor: const Color(0xFFDEA2FF),
        placeholderColor: const Color(0xFFFFFFFF),
        focusedPlaceholderColor: const Color(0xFF474747).withOpacity(0.5),
        textColor: const Color(0xFF000000),
        fontWeight: FontWeight.w700,
        focusedbackgroundColor: Colors.transparent,
        unfocusedbackgroundColor: const Color(0xFFD9D9D9),
      ),
      SizedBox(height: screenHeight * 0.02),
      buildInputField(
        'Age',
        isPassword: false,
        controller: ageController,
        borderColor: const Color(0xFFDEA2FF),
        placeholderColor: const Color(0xFFFFFFFF),
        focusedPlaceholderColor: const Color(0xFF474747).withOpacity(0.5),
        textColor: const Color(0xFF000000),
        fontWeight: FontWeight.w700,
        focusedbackgroundColor: Colors.transparent,
        unfocusedbackgroundColor: const Color(0xFFD9D9D9),
      ),
      SizedBox(height: screenHeight * 0.02),
      buildInputField(
        'Gender',
        isPassword: false,
        controller: genderController,
        borderColor: const Color(0xFFDEA2FF),
        placeholderColor: const Color(0xFFFFFFFF),
        focusedPlaceholderColor: const Color(0xFF474747).withOpacity(0.5),
        textColor: const Color(0xFF000000),
        fontWeight: FontWeight.w700,
        focusedbackgroundColor: Colors.transparent,
        unfocusedbackgroundColor: const Color(0xFFD9D9D9),
      ),
      SizedBox(height: screenHeight * 0.02),
      buildInputField(
        'Profession',
        isPassword: false,
        controller: professionController,
        borderColor: const Color(0xFFDEA2FF),
        placeholderColor: const Color(0xFFFFFFFF),
        focusedPlaceholderColor: const Color(0xFF474747).withOpacity(0.5),
        textColor: const Color(0xFF000000),
        fontWeight: FontWeight.w700,
        focusedbackgroundColor: Colors.transparent,
        unfocusedbackgroundColor: const Color(0xFFD9D9D9),
      ),
      SizedBox(height: screenHeight * 0.02),
      buildInputField(
        'Interests',
        isPassword: false,
        controller: interestController,
        borderColor: const Color(0xFFDEA2FF),
        placeholderColor: const Color(0xFFFFFFFF),
        focusedPlaceholderColor: const Color(0xFF474747).withOpacity(0.5),
        textColor: const Color(0xFF000000),
        fontWeight: FontWeight.w700,
        focusedbackgroundColor: Colors.transparent,
        unfocusedbackgroundColor: const Color(0xFFD9D9D9),
      ),
      SizedBox(height: screenHeight * 0.02),
      buildInputField(
        'Other_interests',
        isPassword: false,
        controller: otherinterestsController,
        borderColor: const Color(0xFFDEA2FF),
        placeholderColor: const Color(0xFFFFFFFF),
        focusedPlaceholderColor: const Color(0xFF474747).withOpacity(0.5),
        textColor: const Color(0xFF000000),
        fontWeight: FontWeight.w700,
        focusedbackgroundColor: Colors.transparent,
        unfocusedbackgroundColor: const Color(0xFFD9D9D9),
      ),
      SizedBox(height: screenHeight * 0.02),
      buildInputField(
        'Language',
        isPassword: false,
        controller: languageController,
        borderColor: const Color(0xFFDEA2FF),
        placeholderColor: const Color(0xFFFFFFFF),
        focusedPlaceholderColor: const Color(0xFF474747).withOpacity(0.5),
        textColor: const Color(0xFF000000),
        fontWeight: FontWeight.w700,
        focusedbackgroundColor: Colors.transparent,
        unfocusedbackgroundColor: const Color(0xFFD9D9D9),
      ),
      SizedBox(height: screenHeight * 0.02),
      buildInputField(
        'Your Phone Number (+91...)',
        isPassword: false,
        controller: phoneNumberController,
        borderColor: const Color(0xFFDEA2FF),
        placeholderColor: const Color(0xFFFFFFFF),
        focusedPlaceholderColor: const Color(0xFF474747).withOpacity(0.5),
        textColor: const Color(0xFF000000),
        fontWeight: FontWeight.w700,
        focusedbackgroundColor: Colors.transparent,
        unfocusedbackgroundColor: const Color(0xFFD9D9D9),
      ),
      SizedBox(height: screenHeight * 0.02),
      buildInputField(
        'Emergency Contact Number(+91...)',
        isPassword: false,
        controller: emergencyNumberController,
        borderColor: const Color(0xFFDEA2FF),
        placeholderColor: const Color(0xFFFFFFFF),
        focusedPlaceholderColor: const Color(0xFF474747).withOpacity(0.5),
        textColor: const Color(0xFF000000),
        fontWeight: FontWeight.w700,
        focusedbackgroundColor: Colors.transparent,
        unfocusedbackgroundColor: const Color(0xFFD9D9D9),
      ),
      SizedBox(height: screenHeight * 0.02),
      Center(
        child: ElevatedButton(
          onPressed: () async {
            if (genderController.text.isEmpty ||
                ageController.text.isEmpty ||
                languageController.text.isEmpty ||
                professionController.text.isEmpty ||
                interestController.text.isEmpty ||
                otherinterestsController.text.isEmpty ||
                genderController.text.isEmpty ||
                emergencyNumberController.text.isEmpty ||
                phoneNumberController.text.isEmpty) {
              showCustomSnackBar(context, 'Please fill all the fields');
              return;
            }

            final formData = {
              'gender': genderController.text,
              'age': ageController.text,
              'language': languageController.text,
              'profession': professionController.text,
              'interest': interestController.text,
              'other_interests': otherinterestsController.text,
              'bio': bioController.text,
              'phone': phoneNumberController.text,
              'emergency_contact': emergencyNumberController.text,
            };

            await storeFormData(
              formData,
            ); // Replace 'userId' with the actual user ID

            writeStorage('emergency_contact', emergencyNumberController.text);

            Navigator.pushNamed(
              context,
              '/customize-profile',
              arguments: {'redirectToHome': false},
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF000000),
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
