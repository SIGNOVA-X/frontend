import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:signova/components/crud.dart';
import 'package:signova/components/input.dart';
import 'package:signova/components/buttons.dart';
import 'package:signova/components/snackbar.dart';
import 'package:signova/model/drag_handler.dart'; // Import DragHandler

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController createPasswordController =
      TextEditingController();
  final TextEditingController confirmPasswordController =
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
    fullNameController.dispose();
    emailController.dispose();
    createPasswordController.dispose();
    confirmPasswordController.dispose();
    _animationController.dispose();
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
            child: Stack(
              children: [
                GestureDetector(
                  onTap: () => FocusScope.of(context).unfocus(),
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
                            image: AssetImage(
                              'assets/images/blur_background.png',
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // Content remains outside the GestureDetector
                Positioned.fill(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16.0, 40.0, 16.0, 2),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Join Us Today!',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w400,
                            fontSize: 25,
                            color: const Color(0xFFFFFFFF).withOpacity(0.5),
                          ),
                        ),
                        Text(
                          'Sign Up',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w700,
                            fontSize: 60,
                            color: const Color(0xFF000000),
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.02),
                        Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Input fields
                              buildInputField(
                                'Enter your full name',
                                controller: fullNameController,
                                borderColor: const Color(0xFFDEA2FF),
                                placeholderColor: const Color(0xFFFFFFFF),
                                focusedPlaceholderColor: const Color(
                                  0xFF474747,
                                ).withOpacity(0.5),
                                textColor: const Color(0xFF000000),
                                fontWeight: FontWeight.w700,
                                focusedbackgroundColor: Colors.transparent,
                                unfocusedbackgroundColor: const Color(
                                  0xFFD9D9D9,
                                ),
                              ),
                              SizedBox(height: screenHeight * 0.02),
                              buildInputField(
                                'Enter your email',
                                controller: emailController,
                                borderColor: const Color(0xFFDEA2FF),
                                placeholderColor: const Color(0xFFFFFFFF),
                                focusedPlaceholderColor: const Color(
                                  0xFF474747,
                                ).withOpacity(0.5),
                                textColor: const Color(0xFF000000),
                                fontWeight: FontWeight.w700,
                                focusedbackgroundColor: Colors.transparent,
                                unfocusedbackgroundColor: const Color(
                                  0xFFD9D9D9,
                                ),
                              ),
                              SizedBox(height: screenHeight * 0.02),
                              buildInputField(
                                'Create a password',
                                isPassword: true,
                                controller: createPasswordController,
                                borderColor: const Color(0xFFDEA2FF),
                                placeholderColor: const Color(0xFFFFFFFF),
                                focusedPlaceholderColor: const Color(
                                  0xFF474747,
                                ).withOpacity(0.5),
                                textColor: const Color(0xFF000000),
                                fontWeight: FontWeight.w700,
                                focusedbackgroundColor: Colors.transparent,
                                unfocusedbackgroundColor: const Color(
                                  0xFFD9D9D9,
                                ),
                              ),
                              SizedBox(height: screenHeight * 0.02),
                              buildInputField(
                                'Confirm your password',
                                isPassword: true,
                                controller: confirmPasswordController,
                                borderColor: const Color(0xFFDEA2FF),
                                placeholderColor: const Color(0xFFFFFFFF),
                                focusedPlaceholderColor: const Color(
                                  0xFF474747,
                                ).withOpacity(0.5),
                                textColor: const Color(0xFF000000),
                                fontWeight: FontWeight.w700,
                                focusedbackgroundColor: Colors.transparent,
                                unfocusedbackgroundColor: const Color(
                                  0xFFD9D9D9,
                                ),
                              ),
                              SizedBox(height: screenHeight * 0.02),
                              // Sign Up button
                              buildSignupLoginButton(
                                context,
                                screenWidth,
                                screenHeight,
                                'Sign Up',
                                () async {
                                  if (fullNameController.text.isEmpty ||
                                      emailController.text.isEmpty ||
                                      createPasswordController.text.isEmpty ||
                                      confirmPasswordController.text.isEmpty) {
                                    showCustomSnackBar(
                                      context,
                                      'Please fill in all fields',
                                    );
                                    return;
                                  }

                                  // Email validation
                                  if (!RegExp(
                                    r'^[^@]+@[^@]+\.(com|in)$',
                                  ).hasMatch(emailController.text)) {
                                    showCustomSnackBar(
                                      context,
                                      'Please enter a valid email address',
                                    );
                                    return;
                                  }

                                  if (createPasswordController.text !=
                                      confirmPasswordController.text) {
                                    showCustomSnackBar(
                                      context,
                                      'Passwords do not match',
                                    );
                                    return;
                                  }

                                  if (await checkUserExists(
                                    emailController.text,
                                  )) {
                                    showCustomSnackBar(
                                      context,
                                      'User already exists',
                                    );
                                    return;
                                  }
                                  // Call the addUser function with the provided details
                                  await addUser(
                                    emailController.text,
                                    fullNameController.text,
                                    createPasswordController.text,
                                  );
                                  writeStorage(
                                    'username',
                                    emailController.text,
                                  );
                                  Navigator.pushNamed(context, '/form');
                                },
                                color: const Color(0xFFAA69E3),
                                textColor: const Color(0xFFFFFFFF),
                                fontWeight: FontWeight.w700,
                              ),
                              SizedBox(height: screenHeight * 0.02),
                              const Text(
                                'Sign up with socials',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w400,
                                  fontSize: 11,
                                  color: Color(0xB3FFFFFF),
                                ),
                              ),
                              SizedBox(height: screenHeight * 0.01),
                              // Social buttons
                              buildSocialButtons(
                                context,
                                screenWidth,
                                buttonColor: const Color(
                                  0xFF474747,
                                ).withOpacity(0.5),
                                iconColor: const Color(0xFFFFFFFF),
                              ),
                              SizedBox(height: screenHeight * 0.01),
                              const Text(
                                'By signing up, you agree to our [Terms of Service] and [Privacy Policy].',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w400,
                                  fontSize: 10,
                                  color: Color(0xB3FFFFFF), // 70% opacity
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
