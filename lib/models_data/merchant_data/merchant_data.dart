import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fresto_apps/apis/cloud_messaging_api.dart';
import 'package:fresto_apps/apis/collection_names.dart';
import 'package:fresto_apps/apis/merchant_api.dart';
import 'package:fresto_apps/models/merchant.dart';
import 'package:fresto_apps/models_data/base_data/merchant_base_data.dart';

class MerchantData extends MerchantBaseData {
  MerchantData();

  bool isLoading = false;
  bool isConfigureExecuted = false;
  Merchant baseFetchedValue;

  void loadCurrentMerchantData({BuildContext context}) async {
    await this.auth.currentUser().then((FirebaseUser user) => this.user = user);
    if (user == null) return;
    baseFetchedValue =
        await MerchantAPI.getCurrentMerchant(userUid: this.user.uid);
    setMerchant(merchant: Merchant.fromJson(baseFetchedValue.toJson()));

    notifyListeners();
    if (context == null) return;
    if (isConfigureExecuted) return;
    print("this subscribe should execute");
    await subscribeFCM(context);
  }

  Future<String> updateCurrentMerchant() async {
    if (this.user == null) {
      return "Failed to Update";
    }
    if (isMerchantValueSame()) return "Theres nothing to update";
    isLoading = true;
    notifyListeners();
    String result = await MerchantAPI.updateMerchantFromDatabase(
      updatedMerchant: this.merchant,
      firebaseUser: this.user,
    );
    if (result == null) {
      baseFetchedValue = Merchant.fromJson(this.merchant.toJson());
      notifyListeners();
    }
    isLoading = false;
    notifyListeners();
    return result;
  }

  Future<void> subscribeFCM(BuildContext context) async {
    setConfigureExecuted(true);
    String msg = await CloudMessagingAPI.configure(
      userUid: baseFetchedValue.userUid,
      collectionName: kMerchantCollection,
      context: context,
    );
    if (msg != null) Fluttertoast.showToast(msg: msg);
  }

  void unsubscribeFCM() async {
    setConfigureExecuted(false);
    String msg = await CloudMessagingAPI.removeTokenFromUser(
        collectionName: kMerchantCollection, userUid: baseFetchedValue.userUid);
    if (msg != null) Fluttertoast.showToast(msg: msg);
  }

  void setConfigureExecuted(bool val) {
    isConfigureExecuted = val;
    notifyListeners();
  }

  bool isMerchantValueSame() => this.merchant == this.baseFetchedValue;
}
