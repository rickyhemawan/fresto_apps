import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fresto_apps/models/helper/menu_helper.dart';
import 'package:fresto_apps/models/menu.dart';
import 'package:fresto_apps/models/merchant.dart';
import 'package:fresto_apps/models_data/base_data/order_base_data.dart';

class ClientOrderData extends OrderBaseData {
  Merchant merchant;
  ClientOrderData();

  DateTime minimumDate = DateTime.now().add(Duration(days: 1));
  DateTime maximumDate = DateTime.now().add(Duration(days: 30));

  void setMerchant(Merchant merchant) {
    this.order.merchantUid = merchant.userUid;
    this.merchant = merchant;
    notifyListeners();
  }

  // TODO : Order API
  // TODO : On tap url launcher (Address)
  // TODO : Future<String> submit button

  String getReservationDate() {
    // TODO : Setter and getter for date
    return "Date not settled yet";
  }

  void clearMerchant() {
    this.merchant = null;
    this.order.merchantUid = null;
    this.order.menus = [];
    notifyListeners();
  }

  void addMenu({@required Menu menu, @required Merchant merchant}) {
    if (menu == null) return;
    if (merchant == null) return;

    if (this.order.merchantUid != null) {
      if (this.order.merchantUid != merchant.userUid) {
        Fluttertoast.showToast(
            msg: "Please Cancel the previous order before creating a new one");
        return;
      }
    } else {
      setMerchant(merchant);
    }

    MenuHelper helper = MenuHelper.fromMenu(menu);
    for (int i = 0; i < this.order.menus.length; i++) {
      if (this.order.menus[i] == helper) {
        this.order.menus[i].quantity++;
        notifyListeners();
        return;
      }
    }
    helper.quantity = 1;
    this.order.menus.add(helper);
    notifyListeners();
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

  String getGrandTotal() {
    return "Rp ${(_calculateProductsTotal() * 1.1).toStringAsFixed(2)}";
  }
}
