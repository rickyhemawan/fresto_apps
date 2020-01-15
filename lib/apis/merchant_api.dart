import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:fresto_apps/models/merchant.dart';
import 'package:fresto_apps/utils/constants.dart';

import 'collection_names.dart';

class MerchantAPI {
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
    try {
      final merchantUser = await auth.createUserWithEmailAndPassword(
        email: merchant.email,
        password: password,
      );
      if (merchantUser.user == null) return kErrorCreateUserFailed;
      await firestore
          .collection(kMerchantCollection)
          .document()
          .setData(merchant.toJson());
    } catch (e) {
      return e.toString();
    }
    return null;
  }
}
