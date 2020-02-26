import 'package:flutter/foundation.dart';
import 'package:fresto_apps/models/helper/menu_helper.dart';
import 'package:fresto_apps/models/order.dart';

abstract class OrderBaseData extends ChangeNotifier {
  Order order;

  OrderBaseData() {
    createOrderInstance();
  }

  void resetOrder() {
    this.order = null;
    notifyListeners();
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
}
