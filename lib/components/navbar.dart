import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:toastification/toastification.dart';

Widget gbottomnavbar(
  BuildContext context,
  int selectedIndex,
  Function(int) onTabChange,
) {
  return GNav(
    gap: 2,
    activeColor: selectedIndex == 1 ? Colors.black : Colors.white,
    color: Color.fromRGBO(140, 58, 207, 1),
    tabBackgroundColor:
        selectedIndex == 1 ? Colors.grey : Color.fromRGBO(140, 58, 207, 1),

    padding: EdgeInsets.all(12),
    selectedIndex: selectedIndex,
    onTabChange: (index) {
      onTabChange(index);
    },
    tabs: [
      GButton(icon: Icons.group, text: "Community"),
      GButton(
        icon: Icons.video_call_outlined,
        text: "Meet",
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
      GButton(icon: Iconsax.microphone_bold, text: "Communicate"),
      GButton(icon: AntDesign.smile_outline, text: "Chatbot"),
      GButton(icon: Iconsax.profile_circle_outline, text: "Profile"),
    ],
  );
}
