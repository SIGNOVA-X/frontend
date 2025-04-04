import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:toastification/toastification.dart';

Widget gbottomnavbar(BuildContext context, int selectedIndex) {
  return GNav(
    mainAxisAlignment: MainAxisAlignment.center,
    activeColor: selectedIndex == 1 ? Colors.black : Colors.white,
    backgroundColor: Colors.black,
    color: Colors.white,
    tabBackgroundColor:
        selectedIndex == 1 ? Colors.grey : Color.fromRGBO(51, 51, 51, 1),
    tabBorderRadius: 400,
    padding: EdgeInsets.symmetric(
      vertical: MediaQuery.of(context).size.height / 62,
      horizontal: MediaQuery.of(context).size.width / 20,
    ),
    selectedIndex: selectedIndex,
    tabs: [
      GButton(
        icon: Icons.group,
        onPressed: () {
          Navigator.pushReplacementNamed(context, '/home-community');
        },
      ),
      GButton(
        icon: Icons.video_call_outlined,
        iconColor:
            selectedIndex == 1
                ? Colors.black
                : Colors.grey, // Make it look disabled
        textColor: selectedIndex == 1 ? Colors.black : Colors.grey,
        onPressed: () {
          toastification.show(
            context: context,
            title: Text("This feature is currently under progress!"),
            alignment: Alignment.topCenter,
            style: ToastificationStyle.fillColored,
            primaryColor: Color.fromRGBO(0, 0, 0, 1),
            backgroundColor: Colors.white,
            autoCloseDuration: Duration(seconds: 2),
          );
        },
      ),
      GButton(
        icon:
            Iconsax.microphone_bold, // Set to null since we’ll use custom icon
        leading: Container(
          padding: EdgeInsets.all(MediaQuery.of(context).size.height / 100),
          decoration: BoxDecoration(
            color: Color.fromRGBO(140, 58, 207, 1),
            shape: BoxShape.circle,
          ),
          child: Icon(Iconsax.microphone_bold, color: Colors.white),
        ),
        onPressed: () {
          Navigator.pushReplacementNamed(context, '/communication');
        },
      ),

      GButton(
        icon: Iconsax.message_2_bold,
        onPressed: () {
          Navigator.pushReplacementNamed(context, '/chatbot');
        },
      ),
      GButton(
        icon: Iconsax.profile_circle_outline,
        onPressed: () {
          Navigator.pushReplacementNamed(context, '/profile');
        },
      ),
    ],
  );
}
