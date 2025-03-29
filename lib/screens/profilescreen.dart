import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:signova/components/buttons.dart';
import 'package:signova/components/navbar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _selectedIndex = 4;
  void _onTabChange(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Navigate based on selected index
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/home-community');
        break;
      case 1:
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/communication');
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/chatbot');
        break;
      case 4:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    double sizeHeight = MediaQuery.of(context).size.height;
    double sizeWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        actions: [
          Icon(Clarity.bell_line, color: Colors.white),
          SizedBox(width: sizeWidth / 2),
          Icon(Icons.history, color: Colors.white),
          SizedBox(width: sizeWidth / 12),
          Icon(Bootstrap.three_dots_vertical, color: Colors.white),
          SizedBox(width: sizeWidth / 20),
        ],
        backgroundColor: Color.fromRGBO(140, 58, 207, 1),
      ),
      body: Stack(
        children: [
          Positioned(
            child: ClipPath(
              clipper: TopCircleClipper(),
              child: Container(
                height: sizeHeight / 3.5,
                width: double.infinity,
                color: Color.fromRGBO(140, 58, 207, 1),
              ),
            ),
          ),
          Positioned(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    top: sizeWidth / 4.5,
                    right: sizeWidth / 3,
                    left: sizeWidth / 3,
                    bottom: sizeHeight / 90,
                  ),
                  child: circleButton(
                    sizeHeight * 2,
                    sizeWidth * 2,
                    'assets/images/profile.png',
                    false,
                  ),
                ),
                Text(
                  "Jane Doe",
                  style: GoogleFonts.inter(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: sizeWidth / 16,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("youremail@gmail.com | "),
                    Text("+01 234 567 89"),
                  ],
                ),

                Container(
                  margin: EdgeInsets.only(
                    top: sizeHeight / 50,
                    right: sizeWidth / 20,
                    left: sizeWidth / 20,
                    bottom: sizeHeight / 70,
                  ),
                  padding: EdgeInsets.all(sizeHeight / 50),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, 0.1),
                        blurRadius: sizeWidth / 200,
                        offset: Offset(0, 2.5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon((MingCute.profile_line)),
                          SizedBox(width: sizeWidth / 14),
                          Text("Edit profile information"),
                        ],
                      ),
                      SizedBox(height: sizeHeight / 120),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon((Clarity.bell_line)),
                          Text("Notifications"),
                          SizedBox(width: sizeWidth / 4),
                          Text(
                            "ON",
                            style: GoogleFonts.inter(
                              color: Color.fromRGBO(21, 115, 254, 1.0),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: sizeHeight / 120),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon((Icons.translate_outlined)),
                          Text("Language"),
                          SizedBox(width: sizeWidth / 4),
                          Text(
                            "English",
                            style: GoogleFonts.inter(
                              color: Color.fromRGBO(21, 115, 254, 1.0),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    top: sizeHeight / 50,
                    right: sizeWidth / 20,
                    left: sizeWidth / 20,
                    bottom: sizeHeight / 70,
                  ),
                  padding: EdgeInsets.all(sizeHeight / 50),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, 0.1),
                        blurRadius: sizeWidth / 200,
                        offset: Offset(0, 2.5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon((Icons.contact_support_outlined)),
                          SizedBox(width: sizeWidth / 14),
                          Text("Emergency Contact"),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    top: sizeHeight / 50,
                    right: sizeWidth / 20,
                    left: sizeWidth / 20,
                    bottom: sizeHeight / 180,
                  ),
                  padding: EdgeInsets.all(sizeHeight / 50),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, 0.1),
                        blurRadius: sizeWidth / 200,
                        offset: Offset(0, 2.5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon((Icons.support_agent_outlined)),
                          SizedBox(width: sizeWidth / 14),
                          Text("Help & Support"),
                        ],
                      ),
                      SizedBox(height: sizeHeight / 120),
                      Row(
                        children: [
                          Icon((Icons.contact_support)),
                          SizedBox(width: sizeWidth / 14),
                          Text("Contact us"),
                        ],
                      ),
                      SizedBox(height: sizeHeight / 120),

                      Row(
                        children: [
                          Icon((Icons.lock_clock_outlined)),
                          SizedBox(width: sizeWidth / 14),
                          Text("Privacy Policy"),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(sizeWidth * sizeHeight * 0.00002),
        child: gbottomnavbar(context, _selectedIndex, _onTabChange),
      ),
    );
  }
}

class TopCircleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 100);
    path.quadraticBezierTo(
      size.width / 2,
      size.height,
      size.width,
      size.height - 100,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
