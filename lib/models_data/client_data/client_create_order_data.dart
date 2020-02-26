import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:fresto_apps/apis/order_api.dart';
import 'package:fresto_apps/models/helper/menu_helper.dart';
import 'package:fresto_apps/models/menu.dart';
import 'package:fresto_apps/models/merchant.dart';
import 'package:fresto_apps/models_data/base_data/order_base_data.dart';

class ClientCreateOrderData extends OrderBaseData {
  Merchant merchant;
  ClientCreateOrderData() {
    this.minimumDate = DateTime.now().add(Duration(days: 1));
    this.maximumDate = DateTime.now().add(Duration(days: 30));
  }

  DateTime minimumDate;
  DateTime maximumDate;
  bool isLoading = false;

  void setMerchant(Merchant merchant) {
    createOrderInstance();
    this.order.merchantUid = merchant.userUid;
    this.merchant = merchant;
    setDateBasedOnMerchant(merchant);
    notifyListeners();
  }

  void setLoading(bool val) {
    isLoading = val;
    notifyListeners();
  }

  void setDateBasedOnMerchant(Merchant merchant) {
    DateTime tempDate = DateTime.now();
    this.minimumDate = DateTime(
      tempDate.year,
      tempDate.month,
      tempDate.day,
      merchant.openHour,
    ).add(Duration(days: 1));
    this.maximumDate = DateTime(
      tempDate.year,
      tempDate.month,
      tempDate.day,
      merchant.closeHour,
    ).add(Duration(days: 30));
    notifyListeners();
  }

  // TODO : On tap url launcher (Address)

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
        double.parse((_calculateProductsTotal() * 1.1).toStringAsFixed(2));
    String res = await OrderAPI.createOrder(order: this.order);
    if (res == null) clearMerchant();
    return res;
  }

  String getReservationDate() {
    if (this.order == null) return "Date not settled yet";
    if (this.order.orderDate == null) return "Date not settled yet";
    return this.order.formattedTime;
  }

  void clearMerchant() {
    this.order.merchantUid = null;
    this.order.menus = [];
    notifyListeners();
  }

  String addMenu({@required Menu menu, @required Merchant merchant}) {
    if (menu == null) return null;
    if (merchant == null) return null;

    if (this.order.merchantUid != null) {
      if (this.order.merchantUid != merchant.userUid) {
        return "Please Cancel the previous order before creating a new one";
      }
    } else {
      setMerchant(merchant);
    }

    MenuHelper helper = MenuHelper.fromMenu(menu);
    for (int i = 0; i < this.order.menus.length; i++) {
      if (this.order.menus[i] == helper) {
        this.order.menus[i].quantity++;
        notifyListeners();
        return null;
      }
    }
    helper.quantity = 1;
    this.order.menus.add(helper);
    notifyListeners();
    return null;
  }

  void removeMenu({@required Menu menu}) {
    if (menu == null) return;
    MenuHelper helper = MenuHelper.fromMenu(menu);
    for (int i = 0; i < this.order.menus.length; i++) {
      if (this.order.menus[i] == helper) {
        this.order.menus[i].quantity--;
        if (this.order.menus[i].quantity <= 0) this.order.menus.removeAt(i);
        notifyListeners();
      }
    }
    if (this.order.menus.length == 0) {
      clearMerchant();
    }
  }

  int getMenuQuantity({@required Menu menu}) {
    if (menu == null) return 0;
    MenuHelper helper = MenuHelper.fromMenu(menu);
    for (int i = 0; i < this.order.menus.length; i++) {
      if (this.order.menus[i] == helper) return this.order.menus[i].quantity;
    }
    return 0;
  }

  bool isMenuEmpty() {
    if (this.order == null) return true;
    if (this.order.menus == null) return true;
    return this.order.menus.length == 0;
  }

  int getTotalItems() {
    if (this.order == null) return 0;
    if (this.order.menus == null) return 0;
    int total = 0;
    this.order.menus.forEach((e) => total += e.quantity);
    return total;
  }

  double _calculateProductsTotal() {
    if (this.order == null) return 0;
    if (this.order.menus == null) return 0;
    double total = 0;
    this.order.menus.forEach((e) => total += e.subTotal);
    return total;
  }

  String getProductTotal() {
    return "Rp ${_calculateProductsTotal().toStringAsFixed(2)}";
  }

  String getTax() {
    return "Rp ${(_calculateProductsTotal() / 10).toStringAsFixed(2)}";
  }

  String getGrandTotalString() {
    return "Rp ${(_calculateProductsTotal() * 1.1).toStringAsFixed(2)}";
  }
}
