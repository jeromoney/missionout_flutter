import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Used to store email locally while user checks email
/// Saves them from re-entering email.
class EmailSecureStore {
  EmailSecureStore({@required this.flutterSecureStorage})
      : assert(flutterSecureStorage != null);
  final FlutterSecureStorage flutterSecureStorage;

  static const String storageUserEmailAddressKey = "userEmailKey";

  Future<void> setEmail(String email) async {
    await flutterSecureStorage.write(
        key: storageUserEmailAddressKey, value: email);
  }

  Future<void> clearEmail() async {
    await flutterSecureStorage.delete(key: storageUserEmailAddressKey);
  }

  Future<String> getEmail() async {
    return await flutterSecureStorage.read(key: storageUserEmailAddressKey);
  }
}
