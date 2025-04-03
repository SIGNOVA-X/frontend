import 'package:cloud_firestore/cloud_firestore.dart';

class Profile {
  final String userId;
  final String userName;
  final String? profileImageString;

  Profile({
    required this.userId,
    required this.userName,
    required this.profileImageString,
  });
}
