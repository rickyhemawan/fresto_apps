import 'package:firebase_auth/firebase_auth.dart';
import 'package:fresto_apps/apis/order_api.dart';
import 'package:fresto_apps/models_data/base_data/order_base_data.dart';

class ClientCreateOrderData extends OrderBaseData {
  bool isLoading = false;

  ClientCreateOrderData() {
    this.minimumDate = DateTime.now().add(Duration(days: 1));
    this.maximumDate = DateTime.now().add(Duration(days: 30));
  }

  void setLoading(bool val) {
    isLoading = val;
    notifyListeners();
  }

  Future<String> submitOrder() async {
    String userUid;
    await FirebaseAuth.instance.currentUser().then((user) {
      userUid = user.uid;
    }, onError: (err) {
      return err;
    });
    this.order.userUid = userUid;
    this.order.merchantUid = this.merchant.userUid;
    this.order.total =
        double.parse((calculateProductsTotal() * 1.1).toStringAsFixed(2));
    String res = await OrderAPI.createOrder(order: this.order);
    if (res == null) clearMerchant();
    return res;
  }
}
