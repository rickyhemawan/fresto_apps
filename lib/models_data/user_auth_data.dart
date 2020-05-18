import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:fresto_apps/apis/client_api.dart';
import 'package:fresto_apps/apis/device_tracking_api.dart';
import 'package:fresto_apps/models/client.dart';
import 'package:fresto_apps/utils/constants.dart';

class UserAuthData extends ChangeNotifier {
  // Async Views Properties
  bool loadingStatus = false;

  // Login and Register Form Variables
  String email = "";
  String password = "";
  String confirmPassword = "";
  String phoneNumber = "";
  String fullName = "";

  UserAuthData({auth}) {
    this.auth = auth ?? FirebaseAuth.instance;
  }

  FirebaseAuth auth;
  final _next = (Route<dynamic> route) => false;
  FirebaseUser _user;

  //--------------------------
  // On text changed functions
  //--------------------------

  void setEmail(String email) {
    this.email = email;
    notifyListeners();
  }

  void setPassword(String password) {
    this.password = password;
    notifyListeners();
  }

  void setConfirmPassword(String confirmPassword) {
    this.confirmPassword = confirmPassword;
    notifyListeners();
  }

  void setPhoneNumber(String phoneNumber) {
    this.phoneNumber = phoneNumber;
    notifyListeners();
  }

  void setFullName(String fullName) {
    this.fullName = fullName;
    notifyListeners();
  }

  void setUser(FirebaseUser user) {
    this._user = user;
    notifyListeners();
  }

  void resetAllInputValue() {
    this.email = "";
    this.password = "";
    this.confirmPassword = "";
    this.phoneNumber = "";
    this.fullName = "";
    notifyListeners();
  }

  void enableLoading() {
    this.loadingStatus = true;
    notifyListeners();
  }

  void disableLoading() {
    this.loadingStatus = false;
    notifyListeners();
  }

  //-------------------------------------------------
  // Standard validator for login or registering user
  //-------------------------------------------------

  void validator({bool isLoginScreen = true}) {
    if (email.isEmpty) throw kErrorEmptyEmail;
    bool emailValidator = RegExp(kEmailRegex).hasMatch(email);
    if (!emailValidator) throw kErrorNotValidEmailAddress;
    if (password.isEmpty) throw kErrorEmptyPassword;
    if (isLoginScreen) return;

    if (confirmPassword.isEmpty) throw kErrorEmptyConfirmPassword;
    if (confirmPassword != password) throw kErrorPasswordNotMatch;
    if (phoneNumber.isEmpty) throw kErrorEmptyPhoneNumber;
    if (fullName.isEmpty) throw kErrorEmptyFullName;
  }

  // check whether user is authenticated or not
  Future<bool> isUserAuthenticated() async {
    _user = await auth.currentUser();
    notifyListeners();
    if (_user == null) return false;
    return true;
  }

  // check logged In User Details
  void printUserDetails() async {
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
    printUserDetails();
    if (giveDirectAccessToAdmin()) {
      _navigator.pushNamedAndRemoveUntil(kAdminMainScreenRoute, _next);
      return;
    }
    if (await isUserAuthenticated()) {
      if (_user.email.contains("@fresto.com")) {
        _navigator.pushNamedAndRemoveUntil(kMerchantMainScreenRoute, _next);
        return;
      }
      _navigator.pushNamedAndRemoveUntil(kMainScreenRoute, _next);
      return;
    }
    _navigator.pushNamedAndRemoveUntil(kLoginScreenRoute, _next);
  }

  //----------------------------------
  // Login/Logout & Register Functions
  //----------------------------------

  // Logout and redirect to Login Page
  void signOutUser(BuildContext context) {
    auth.signOut();
    _user = null;
    printUserDetails();
    if (context == null) return;
    DeviceTrackingAPI().stopTracking();
    Navigator.of(context).pushNamedAndRemoveUntil(kLoginScreenRoute, _next);
  }

  // Login, return message string, and null for success
  Future<String> loginUser() async {
    if (giveDirectAccessToAdmin()) return null;

    enableLoading();
    try {
      validator();
    } catch (e) {
      disableLoading();
      return e;
    }
    try {
      final signInUser = await auth.signInWithEmailAndPassword(
        email: this.email,
        password: this.password,
      );
      if (signInUser.user == null) {
        disableLoading();
        return kErrorUserNotRegistered;
      }
      _user = signInUser.user;
    } catch (e) {
      print(e);
      disableLoading();
      return kErrorWrongEmailOrPassword;
    }
    disableLoading();
    return null;
  }

  // Register, return message string, and null for success
  Future<String> registerUser() async {
    enableLoading();
    try {
      validator(isLoginScreen: false);
    } catch (e) {
      disableLoading();
      return e;
    }
    try {
      final createUser = await auth.createUserWithEmailAndPassword(
        email: this.email,
        password: this.password,
      );
      if (createUser.user == null) {
        disableLoading();
        return kErrorCreateUserFailed;
      }
      await ClientAPI.addNewClientToDatabase(Client(
        email: this.email,
        fullName: this.fullName,
        phoneNumber: this.phoneNumber,
        userUid: createUser.user.uid,
      ));
    } catch (e) {
      print(e);
      disableLoading();
      return kErrorFailedRegistration;
    }
    disableLoading();
    return null;
  }

  //------------
  // Admin Login
  //------------

  final String adminEmail = "admin@admin.com";
  final String adminPassword = "admin1234";

  bool giveDirectAccessToAdmin() {
    if (this.email.trim() == adminEmail.trim() &&
        this.password.trim() == adminPassword.trim()) return true;
    return false;
  }
}
