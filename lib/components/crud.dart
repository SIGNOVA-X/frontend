import 'package:cloud_firestore/cloud_firestore.dart';
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
  final doc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
  return doc.exists;
}

Future<bool> validateUserCredentials(String userId, String password) async {
  final doc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
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

Future<void> storeFormData( Map<String, dynamic> formData) async {
  String userId = readStorage('username');
  final doc = await FirebaseFirestore.instance.collection('information').doc(userId).get();
  if (doc.exists) {
    print("User already exists in information collection: $userId. Form data not stored.");
    return;
  }
  await FirebaseFirestore.instance.collection('information').doc(userId).set(
    formData,
    SetOptions(merge: true), // Ensures real-time updates and merging of data
  );
  print("Form data stored for user: $userId");
}

void writeStorage(String key, String value) {
  GetStorage.init();
  final storage = GetStorage();
  storage.write(key, value);
  print("Stored $key: $value");
}

String readStorage(String key) {
  GetStorage.init();
  final storage = GetStorage();
  String value = storage.read(key);
  print("Value for $key: $value");
  return value;
}
