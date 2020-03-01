import 'package:flutter/foundation.dart';
import 'package:fresto_apps/models/helper/menu_helper.dart';
import 'package:fresto_apps/models/menu.dart';
import 'package:fresto_apps/models/merchant.dart';
import 'package:fresto_apps/models/order.dart';

abstract class OrderBaseData extends ChangeNotifier {
  Order order;
  Merchant merchant;

  DateTime minimumDate;
  DateTime maximumDate;

  OrderBaseData() {
    createOrderInstance();
  }

  void createOrderInstance() {
    if (this.order == null) {
      this.order = Order();
      this.order.menus = [];
      this.order.orderStatus = [];
      this.order.orderStatus.add(OrderStatus.kWaitingMerchantConfirmation);
      notifyListeners();
    }
  }

  void resetOrder() {
    this.order = null;
    notifyListeners();
  }

  void clearMerchant() {
    this.order.merchantUid = null;
    this.order.menus = [];
    notifyListeners();
  }

  void setMerchant(Merchant merchant) {
    createOrderInstance();
    this.order.merchantUid = merchant.userUid;
    this.merchant = merchant;
    setDateBasedOnMerchant(merchant);
    notifyListeners();
  }

  void setOrder(Order order) {
    createOrderInstance();
    this.order = order;
    notifyListeners();
  }

  void setOrderData({Merchant merchant, Order order}) {
    if (merchant != null) setMerchant(merchant);
    if (order != null) setOrder(order);
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

  void setMerchantUid(String uid) {
    createOrderInstance();
    this.order.merchantUid = uid;
    notifyListeners();
  }

  void setUserUid(String uid) {
    createOrderInstance();
    this.order.userUid = uid;
    notifyListeners();
  }

  void setMenus(List<MenuHelper> menus) {
    createOrderInstance();
    this.order.menus = menus;
    notifyListeners();
  }

  void updateOrderStatus({@required String orderStatus}) {
    if (orderStatus == null) return;
    createOrderInstance();
    this.order.orderStatus.add(orderStatus);
    notifyListeners();
  }

  void updatePaymentStatus({@required String paymentStatus}) {
    createOrderInstance();
    this.order.paymentStatus = paymentStatus;
    notifyListeners();
  }

  void setDate(DateTime dateTime) {
    createOrderInstance();
    this.order.orderDate = dateTime;
    notifyListeners();
  }

  String getReservationDate() {
    if (this.order == null) return "Date not settled yet";
    if (this.order.orderDate == null) return "Date not settled yet";
    return this.order.formattedTime;
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

  double calculateProductsTotal() {
    if (this.order == null) return 0;
    if (this.order.menus == null) return 0;
    double total = 0;
    this.order.menus.forEach((e) => total += e.subTotal);
    return total;
  }

  String getProductTotal() {
    return "Rp ${calculateProductsTotal().toStringAsFixed(2)}";
  }

  String getTax() {
    return "Rp ${(calculateProductsTotal() / 10).toStringAsFixed(2)}";
  }

  String getGrandTotalString() {
    return "Rp ${(calculateProductsTotal() * 1.1).toStringAsFixed(2)}";
  }
}
