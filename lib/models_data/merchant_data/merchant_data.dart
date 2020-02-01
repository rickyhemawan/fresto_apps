import 'package:firebase_auth/firebase_auth.dart';
import 'package:fresto_apps/apis/merchant_api.dart';
import 'package:fresto_apps/models/merchant.dart';
import 'package:fresto_apps/models_data/base_data/merchant_base_data.dart';

class MerchantData extends MerchantBaseData {
  MerchantData();

  bool isLoading = false;
  Merchant baseFetchedValue;

  void loadCurrentMerchantData() async {
    await this.auth.currentUser().then((FirebaseUser user) => this.user = user);
    if (user == null) return;
    baseFetchedValue =
        await MerchantAPI.getCurrentMerchant(userUid: this.user.uid);
    setMerchant(merchant: Merchant.fromJson(baseFetchedValue.toJson()));
    notifyListeners();
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

  bool isMerchantValueSame() => this.merchant == this.baseFetchedValue;
}
