import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:fresto_apps/apis/client_api.dart';
import 'package:fresto_apps/models/client.dart';
import 'package:fresto_apps/utils/constants.dart';

class CurrentUserData extends ChangeNotifier {
  // Async Views Properties
  bool loadingStatus = false;

  // Login and Register Form Variables
  String email = "";
  String password = "";
  String confirmPassword = "";
  String phoneNumber = "";
  String fullName = "";

  CurrentUserData({auth}) {
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

  void validator({bool isLogin = true}) {
    if (email.isEmpty) throw "Email cannot be empty";
    bool emailValidator = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
    if (!emailValidator) throw "Not a valid email address";
    if (password.isEmpty) throw "Password cannot be empty";
    if (isLogin) return;

    if (confirmPassword.isEmpty) throw "Confirm password cannot be empty";
    if (confirmPassword != password) throw "Password doesnt match";
    if (phoneNumber.isEmpty) throw "Phone Number cannot be empty";
    if (fullName.isEmpty) throw "Full Name cannot be empty";
  }

  // check whether user is authenticated or not
  Future<bool> isUserAuthenticated() async {
    if (auth.currentUser() == null) return false;
    _user = await auth.currentUser();
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
    // TODO: delete this dummy when done
    if (giveAccessToMerchant()) {
      _navigator.pushNamedAndRemoveUntil(kMerchantMainScreenRoute, _next);
      return;
    }
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
    auth.signOut();
    _user = null;
    printUserDetails();
    if (context == null) return;
    Navigator.of(context).pushNamedAndRemoveUntil(kLoginScreen, _next);
  }

  // Login, return message string, and null for success
  Future<String> loginUser() async {
    // TODO: delete this dummy when done
    if (giveAccessToMerchant()) return null;

    enableLoading();
    try {
      validator();
    } catch (e) {
      disableLoading();
      return e;
    }
    try {
      final createUser = await auth.signInWithEmailAndPassword(
        email: this.email,
        password: this.password,
      );
      if (createUser.user == null) {
        disableLoading();
        return "User is not available";
      }
      _user = createUser.user;
    } catch (e) {
      print(e);
      disableLoading();
      return "Wrong Email or Password";
    }
    disableLoading();
    return null;
  }

  // Register, return message string, and null for success
  Future<String> registerUser() async {
    enableLoading();
    try {
      validator(isLogin: false);
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
        return "Cannot Create this User";
      }
      ClientAPI.addNewUserToDatabase(Client(
        email: this.email,
        fullName: this.fullName,
        phoneNumber: this.phoneNumber,
        userUid: createUser.user.uid,
      ));
    } catch (e) {
      print(e);
      disableLoading();
      return "Email is already in use";
    }
    disableLoading();
    return null;
  }

  //--------------------------------------------
  // Dummy Testing Functions (Delete This Later)
  //--------------------------------------------

  final dummyMerchantEmail = "merchant@dummy.com";
  final dummyMerchantPassword = "1234";

  bool giveAccessToMerchant() {
    if (this.email != dummyMerchantEmail) return false;
    return this.password == dummyMerchantPassword;
  }
}
