import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:fresto_apps/apis/collection_names.dart';
import 'package:fresto_apps/models/menu.dart';
import 'package:fresto_apps/models/merchant.dart';
import 'package:fresto_apps/utils/constants.dart';

class MerchantAPI {
  static const ERROR_WEAK_PASSWORD = "ERROR_WEAK_PASSWORD";
  static const ERROR_INVALID_EMAIL = "ERROR_INVALID_EMAIL";
  static const ERROR_EMAIL_ALREADY_IN_USE = "ERROR_EMAIL_ALREADY_IN_USE";

  static Future<String> addNewMerchantToDatabase(
      {@required Merchant merchant,
      @required String password,
      @required String confirmPassword}) async {
    // Validates
    if (merchant.email.isEmpty) return kErrorEmptyEmail;
    bool emailValidator = RegExp(kEmailRegex).hasMatch(merchant.email);
    if (!emailValidator) return kErrorNotValidEmailAddress;
    if (password.isEmpty) return kErrorEmptyPassword;
    if (confirmPassword.isEmpty) return kErrorEmptyConfirmPassword;
    if (confirmPassword != password) return kErrorPasswordNotMatch;

    // Executes Firebase methods
    final Firestore firestore = Firestore.instance;
    final FirebaseAuth auth = FirebaseAuth.instance;
    await auth
        .createUserWithEmailAndPassword(
            email: merchant.email, password: password)
        .then((authResult) async {
      if (authResult is AuthResult) {
        FirebaseUser user = authResult.user;
        await firestore
            .collection(kMerchantCollection)
            .document(user.uid)
            .setData(merchant.toJson())
            .catchError((err) {
          auth.signOut();
          return err.toString();
        });
        auth.signOut();
        return null;
      }
    }, onError: (signUpError) {
      auth.signOut();
      if (signUpError is PlatformException) {
        if (signUpError.code == ERROR_WEAK_PASSWORD)
          return "The password is too weak";
        if (signUpError.code == ERROR_INVALID_EMAIL)
          return "The email is invalid";
        if (signUpError.code == ERROR_EMAIL_ALREADY_IN_USE)
          return "This email has already been used";
      }
      return signUpError.toString();
    });
    return null;
  }

  static Future<List<Merchant>> getMerchantsFromDatabase() async {
    List<Merchant> merchants = [];
    await Firestore.instance
        .collection(kMerchantCollection)
        .getDocuments()
        .then((QuerySnapshot qs) {
      qs.documents.forEach((d) => merchants.add(Merchant.fromJson(d.data)));
    });
    return merchants;
  }

  static Future<String> updateMerchantFromDatabase(
      {@required Merchant updatedMerchant, FirebaseUser firebaseUser}) async {
    final Firestore firestore = Firestore.instance;
    final defaultPassword = "fresto1234";
    FirebaseUser user;

    // Admin update merchant
    if (firebaseUser == null) {
      try {
        final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
        AuthResult authResult = await firebaseAuth.signInWithEmailAndPassword(
          email: updatedMerchant.email,
          password: defaultPassword,
        );
        user = authResult.user;
        await firebaseAuth.signOut();
      } catch (e) {
        return e.toString();
      }
    } else {
      user = firebaseUser;
    }

    try {
      await firestore
          .collection(kMerchantCollection)
          .document(user.uid)
          .setData(updatedMerchant.toJson());
    } catch (e) {
      return e.toString();
    }

    return null;
  }

  static Future<Merchant> getCurrentMerchant({String userUid}) async {
    Merchant merchant;
    await Firestore.instance
        .collection(kMerchantCollection)
        .document(userUid)
        .get()
        .then((DocumentSnapshot ds) => merchant = Merchant.fromJson(ds.data));
    return merchant;
  }

  static Future<String> addMenusToMerchant(
      {@required Merchant merchant, @required List<Menu> menus}) async {
    if (merchant == null) return kNullMerchantName;
    if (merchant.userUid == null) return kNullMerchantName;
    if (menus == null) return kNullMenus;
    if (menus == []) return kNullMenus;
    try {
      await Firestore.instance
          .collection(kMerchantCollection)
          .document(merchant.userUid)
          .updateData({
        "menus": merchant.encodeMenusToJson(menus),
      });
    } catch (e) {
      print(e.toString());
      return kErrorFailedToUpdateMenus;
    }
    return null;
  }
}
