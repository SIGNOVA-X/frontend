import 'dart:developer';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttermoji/fluttermojiController.dart';
import 'package:get_storage/get_storage.dart';

Future<void> addUser(String userId, String name, String password) async {
  writeStorage('username', userId);

  await FirebaseFirestore.instance.collection('users').doc(userId).set({
    'name': name,
    'password': password,
  });
  print("User added: $userId");
}

Future<bool> checkUserExists(String userId) async {
  final doc =
      await FirebaseFirestore.instance.collection('users').doc(userId).get();
  return doc.exists;
}

Future<Map<String, dynamic>?> getUserDetails(String userId) async {
  bool check = await checkUserExists(userId);
  if (check) {
    final doc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    return doc.data(); // Returns a Map<String, dynamic> of the document fields
  } else {
    return null; // Return null if the document doesn't exist
  }
}

Future<bool> validateUserCredentials(String userId, String password) async {
  final doc =
      await FirebaseFirestore.instance.collection('users').doc(userId).get();
  if (!doc.exists) {
    print("User does not exist: $userId");
    return false;
  }
  final data = doc.data();
  if (data != null && data['password'] == password) {
    print("Credentials validated for user: $userId");
    return true;
  }
  print("Invalid credentials for user: $userId");
  return false;
}

Future<void> storeFormData(Map<String, dynamic> formData) async {
  String userId = readStorage('username');
  final doc =
      await FirebaseFirestore.instance
          .collection('information')
          .doc(userId)
          .get();
  if (doc.exists) {
    print(
      "User already exists in information collection: $userId. Form data not stored.",
    );
    return;
  }
  await FirebaseFirestore.instance
      .collection('information')
      .doc(userId)
      .set(
        formData,
        SetOptions(
          merge: true,
        ), // Ensures real-time updates and merging of data
      );
  print("Form data stored for user: $userId");
}

Future<Map<String, dynamic>?> getFormData() async {
  String userId = readStorage('username');
  final doc =
      await FirebaseFirestore.instance
          .collection('information')
          .doc(userId)
          .get();

  if (doc.exists) {
    print("Form data retrieved for user: $userId");
    return doc.data(); // Returns the form data as a Map
  } else {
    print("No form data found for user: $userId");
    return null;
  }
}

void writeStorage(String key, String value) {
  final storage = GetStorage();
  storage.write(key, value);
  print("Stored $key: $value");
}

String readStorage(String key) {
  final storage = GetStorage();
  String value = storage.read(key);
  print("Value for $key: $value");
  return value;
}

Future<String?> updateUsersWithUser(String userid) async {
  try {
    // Get existing FluttermojiController instance
    final FluttermojiController controller = Get.find<FluttermojiController>();
    String fluttermojiJson = controller.getFluttermojiFromOptions();

    log("📢 Avatar JSON: $fluttermojiJson");

    if (fluttermojiJson.isEmpty) {
      log("⚠️ Avatar data is empty! Not saving to Firebase.");
      return null;
    }

    await FirebaseFirestore.instance.collection('users').doc(userid).update({
      'avatar': fluttermojiJson,
    });

    log("✅ Avatar saved successfully to Firebase!");
    return fluttermojiJson;
  } catch (e) {
    log("❌ Error saving avatar: $e");
    return null;
  }
}
