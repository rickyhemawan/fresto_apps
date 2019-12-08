import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:fresto_apps/apis/client_api.dart';
import 'package:fresto_apps/models/client.dart';
import 'package:fresto_apps/utils/constants.dart';

class CurrentUserData extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _next = (Route<dynamic> route) => false;
  FirebaseUser _user;

  // check whether user is authenticated or not
  Future<bool> isUserAuthenticated() async {
    if (_auth.currentUser() == null) return false;
    _user = await _auth.currentUser();
    if (_user == null) return false;
    return true;
  }

  // check logged In User Details
  void userDetails() async {
    if (await isUserAuthenticated()) {
      print("Logged in Email => ${_user.email}");
      return;
    }
    print("user is null bro");
  }

  //------------------------------
  //  Redirect Functions
  //------------------------------

  void nextPage(context) async {
    final _navigator = Navigator.of(context);
    userDetails();
    if (await isUserAuthenticated()) {
      _navigator.pushNamedAndRemoveUntil(kMainScreenRoute, _next);
      return;
    }
    _navigator.pushNamedAndRemoveUntil(kLoginScreen, _next);
  }

  //----------------------------------
  // Login/Logout & Register Functions
  //----------------------------------

  // Logout and redirect to Login Page
  void signOutUser(context) {
    _auth.signOut();
    _user = null;
    userDetails();
    if (context == null) return;
    Navigator.of(context).pushNamedAndRemoveUntil(kLoginScreen, _next);
  }

  // Login, return message string, and null for success
  Future<String> authUser(LoginData data) async {
    try {
      final createUser = await _auth.signInWithEmailAndPassword(
        email: data.name,
        password: data.password,
      );
      if (createUser.user == null) return "User is not available";
      _user = createUser.user;
    } catch (e) {
      print(e);
      return "Wrong Email or Password";
    }
    return null;
  }

  // Register, return message string, and null for success
  Future<String> registerUser(LoginData data) async {
    try {
      final createUser = await _auth.createUserWithEmailAndPassword(
        email: data.name,
        password: data.password,
      );
      if (createUser.user == null) return "Cannot Create this User";
      ClientAPI.addNewUserToDatabase(Client(
        email: data.name,
        userUid: createUser.user.uid,
      ));
    } catch (e) {
      print(e);
      return "Email is already in use";
    }
    return null;
  }

  // TODO forget password
  Future<String> recoverPassword(String name) {
    return null;
  }
}
