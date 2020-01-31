import 'package:firebase_auth/firebase_auth.dart';
import 'package:fresto_apps/apis/merchant_api.dart';
import 'package:fresto_apps/models_data/base_data/merchant_base_data.dart';

class MerchantData extends MerchantBaseData {
  MerchantData();

  bool isLoading = false;

  void updateCurrentMerchantData() async {
    await this.auth.currentUser().then((FirebaseUser user) => this.user = user);
    if (user == null) return;
    setMerchant(
        merchant: await MerchantAPI.getCurrentMerchant(userUid: this.user.uid));
  }
}
