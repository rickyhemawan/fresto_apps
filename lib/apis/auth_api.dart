import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class AuthAPI {
  static const ERROR_WEAK_PASSWORD = "ERROR_WEAK_PASSWORD";
  static const ERROR_INVALID_EMAIL = "ERROR_INVALID_EMAIL";
  static const ERROR_EMAIL_ALREADY_IN_USE = "ERROR_EMAIL_ALREADY_IN_USE";

  static Future<String> createNewUser(
      {@required String email, @required String password}) async {
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    try {
      await firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      return null;
    } catch (signUpError) {
      if (signUpError is PlatformException) {
        if (signUpError.code == ERROR_WEAK_PASSWORD)
          return "The password is too weak";
        if (signUpError.code == ERROR_INVALID_EMAIL)
          return "The email is invalid";
        if (signUpError.code == ERROR_EMAIL_ALREADY_IN_USE)
          return "This email has already been used";
      }
      return signUpError.toString();
    }
  }

  static Future<String> getCurrentUserUid() async {
    return await FirebaseAuth.instance.currentUser().then((user) {
      return user.uid;
    }, onError: (err) {
      print(err);
      return null;
    });
  }
}
