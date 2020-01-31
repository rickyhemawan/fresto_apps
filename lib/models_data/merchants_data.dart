import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:fresto_apps/apis/merchant_api.dart';
import 'package:fresto_apps/models/merchant.dart';

class MerchantsData extends ChangeNotifier {
  List<Merchant> merchants;
  Firestore firestore;
  bool isLoading = false;

  MerchantsData() {
    merchants = [];
    firestore = Firestore.instance;
  }

  List<Merchant> getMerchants() {
    return this.merchants;
  }

  List<Map<String, dynamic>> getMenusWithMerchantMap() {
    List<Map<String, dynamic>> maps = [];
    this.merchants.forEach((merchant) {
      merchant.menus.forEach((menu) {
        maps.add({"Merchant": merchant, "Menu": menu});
      });
    });
    return maps;
  }

  List<Map<String, dynamic>> getShuffledMenusWithMerchantMap() {
    List<Map<String, dynamic>> x = getMenusWithMerchantMap();
    x.shuffle();
    return x;
  }

  List<Map<String, dynamic>> getSomeMenusWithMerchantMap() {
    return getMenusWithMerchantMap().take(5);
  }

  void fetchMerchantsFromDatabase() async {
    merchants = [];
    isLoading = true;
    notifyListeners();
    merchants = await MerchantAPI.getMerchantsFromDatabase();
    isLoading = false;
    notifyListeners();
    merchants.forEach((f) => print(f.merchantName));
  }
}
