import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:signova/components/navbar.dart';

class CommunicationScreen extends StatefulWidget {
  const CommunicationScreen({super.key});
  @override
  State<CommunicationScreen> createState() => _CommunicationScreenState();
}

class _CommunicationScreenState extends State<CommunicationScreen> {
  final List<bool> isSelectedLeft = [true, false];
  final List<bool> isSelectedRight = [true, false];
  int _selectedIndex = 2;
  void _onTabChange(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // Navigate based on selected index
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/home-community');
        break;
      case 2:
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/chatbot');
        break;
      case 4:
        Navigator.pushReplacementNamed(context, '/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    double sizeWidth = MediaQuery.of(context).size.width;
    double sizeHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(backgroundColor: Colors.transparent),
      body: Row(
        children: [
          Container(
            height: sizeHeight,
            width: sizeWidth / 2,
            decoration: BoxDecoration(
              border: Border.symmetric(
                vertical: BorderSide(color: Colors.black, width: 1.2),
                horizontal: BorderSide.none,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: sizeHeight / 10),
                ToggleButtons(
                  constraints: BoxConstraints(minWidth: sizeWidth / 6),
                  selectedColor: Colors.white,
                  fillColor: Color.fromRGBO(140, 58, 207, 1),
                  borderWidth: 2,
                  borderRadius: BorderRadius.circular(15.0),
                  onPressed: (int index) {
                    setState(() {
                      isSelectedRight[index] = true;
                      isSelectedRight[(index - 1).abs()] = false;
                    });
                  },
                  isSelected: isSelectedRight,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(sizeWidth * sizeHeight * 0.00002),
                      child: Text(
                        "Text",
                        style: GoogleFonts.inter(fontSize: sizeHeight / 65),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(sizeWidth * sizeHeight * 0.00002),
                      child: Text(
                        "Audio",
                        style: GoogleFonts.inter(fontSize: sizeHeight / 65),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: sizeHeight / 1.6),
                Icon(
                  Icons.play_circle_fill,
                  size: sizeHeight / 12,
                  color: Color.fromRGBO(140, 58, 207, 1),
                ),
              ],
            ),
          ),
          SizedBox(
            height: sizeHeight,
            width: sizeWidth / 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: sizeHeight / 10),
                ToggleButtons(
                  constraints: BoxConstraints(minWidth: sizeWidth / 6),
                  selectedColor: Colors.white,
                  fillColor: Color.fromRGBO(140, 58, 207, 1),
                  borderWidth: 2,
                  borderRadius: BorderRadius.circular(15.0),
                  onPressed: (int index) {
                    setState(() {
                      isSelectedLeft[index] = true;
                      isSelectedLeft[(index - 1).abs()] = false;
                    });
                  },
                  isSelected: isSelectedLeft,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(sizeWidth * sizeHeight * 0.00002),
                      child: Text(
                        "Text",
                        style: GoogleFonts.inter(fontSize: sizeHeight / 65),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(sizeWidth * sizeHeight * 0.00002),
                      child: Text(
                        "Avatar",
                        style: GoogleFonts.inter(fontSize: sizeHeight / 65),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: sizeHeight / 1.6),
                Icon(
                  Iconsax.microphone_bold,
                  size: sizeHeight / 12,
                  color: Color.fromRGBO(140, 58, 207, 1),
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
