import 'package:fresto_apps/models/helper/menu_helper.dart';

class OrderStatus {
  static const kWaitingMerchantConfirmation = "WAITING_MERCHANT_CONFIRMATION";
  static const kWaitingPayment = "WAITING_PAYMENT";
  static const kOnProgress = "ON_PROGRESS";
  static const kCancelled = "CANCELLED";
  static const kDone = "DONE";
}

class PaymentStatus {
  static const kNotPaid = "NOT_PAID";
  static const kPaidHalf = "PAID_HALF";
  static const kPaidFull = "PAID_FULLY";
}

class Order {
  String orderUid;
  String merchantUid;
  String userUid;
  List<MenuHelper> menus;
  List<String> orderStatus;
  String paymentStatus;
  double total;
  DateTime orderDate;

  String get lastOrderStatus => orderStatus.last;
  bool get isOrderConfirmed => lastOrderStatus == OrderStatus.kWaitingPayment;
}
