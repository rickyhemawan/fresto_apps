import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:fresto_apps/apis/collection_names.dart';
import 'package:fresto_apps/models/merchant.dart';
import 'package:fresto_apps/utils/constants.dart';

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
    }, onError: (err) {
      auth.signOut();
      return err.toString();
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
}
