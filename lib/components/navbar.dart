import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

Widget bottomnavbar(context) {
  return BottomNavigationBar(
    onTap: (index) {
      if (index == 0) {
        Navigator.pushNamed(context, '/home-community');
      } else if (index == 1) {
        Navigator.pushNamed(context, '/');
      } else if (index == 2) {
        Navigator.pushNamed(context, '/communication');
      } else if (index == 3) {
        Navigator.pushNamed(context, '/chatbot');
      } else if (index == 4) {
        Navigator.pushNamed(context, '/profile');
      }
    },
    backgroundColor: Colors.white,
    selectedItemColor: Color.fromRGBO(88, 41, 122, 1.0),
    selectedIconTheme: IconThemeData(color: Color.fromRGBO(88, 41, 122, 1.0)),
    showSelectedLabels: true,
    showUnselectedLabels: false,
    items: [
      BottomNavigationBarItem(
        icon: Icon(Icons.group, color: Colors.black),
        label: "community",
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.video_call_outlined, color: Colors.black),
        label: "meet",
      ),
      BottomNavigationBarItem(
        icon: Icon(Iconsax.microphone_bold, color: Colors.black),
        label: "communication",
      ),
      BottomNavigationBarItem(
        icon: Icon(AntDesign.smile_outline, color: Colors.black),
        label: "chatbot",
      ),
      BottomNavigationBarItem(
        icon: Icon(Iconsax.profile_add_outline, color: Colors.black),
        label: "profile",
      ),
    ],
  );
}
