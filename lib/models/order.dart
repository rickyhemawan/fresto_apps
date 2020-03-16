import 'package:fresto_apps/models/helper/menu_helper.dart';
import 'package:fresto_apps/utils/constants.dart';
import 'package:intl/intl.dart';

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
  String paymentUid;
  String paymentMethod;

  Order();

  Order.fromJson(Map<String, dynamic> json) {
    this.orderUid = json["uid"];
    this.merchantUid = json["merchantUid"];
    this.userUid = json["userUid"];
    this.menus = decodeMenusFromJson(json["menus"]);
    this.orderStatus = decodeOrderStatusFromJson(json["orderStatus"]);
    this.paymentStatus = json["paymentStatus"];
    this.total = json["total"];
    this.orderDate = DateTime.parse(json["orderDate"].toString());
    this.paymentUid = json["paymentUid"];
    this.paymentMethod = json["paymentMethod"];
  }

  Map<String, dynamic> toJson() => {
        "uid": this.orderUid,
        "merchantUid": this.merchantUid,
        "userUid": this.userUid,
        "menus": encodeMenusToJson(this.menus),
        "orderStatus": this.orderStatus,
        "paymentStatus": this.paymentStatus,
        "total": this.total,
        "orderDate": this.orderDate.toIso8601String(),
        "paymentUid": this.paymentUid,
        "paymentMethod": this.paymentMethod,
      };

  List<MenuHelper> decodeMenusFromJson(List<dynamic> dynamics) {
    List<MenuHelper> tempMenus = [];
    if (dynamics == null) return tempMenus;
    dynamics.forEach((e) {
      print("decodedFromJson => ${e.toString()}");
      Map<String, dynamic> casted =
          Map.castFrom<dynamic, dynamic, String, dynamic>(e);
      tempMenus.add(MenuHelper.fromJson(casted));
    });
    return tempMenus;
  }

  List<String> decodeOrderStatusFromJson(List<dynamic> dynamics) {
    List<String> tempStatus = [];
    if (dynamics == null) return tempStatus;
    dynamics.forEach((e) => tempStatus.add(e.toString()));
    return tempStatus;
  }

  List encodeMenusToJson(List<MenuHelper> list) {
    List jsonList = List();
    list.map((item) => jsonList.add(item.toJson())).toList();
    return jsonList;
  }

  String get lastOrderStatus => orderStatus.last;
  bool get isOrderConfirmed => lastOrderStatus == OrderStatus.kWaitingPayment;
  String get formattedTime {
    DateFormat dateFormat = DateFormat("d MMMM 'at' KK:mm a");
    return dateFormat.format(this.orderDate);
  }

  bool get isEligibleToCancel {
    return lastOrderStatus == OrderStatus.kWaitingMerchantConfirmation ||
        lastOrderStatus == OrderStatus.kWaitingPayment;
  }

  bool get isEligibleToComplete {
    return this.orderDate.isBefore(DateTime.now());
  }

  String get formattedOrderStatus {
    if (lastOrderStatus == OrderStatus.kWaitingMerchantConfirmation)
      return "Waiting restaurant approval";
    if (lastOrderStatus == OrderStatus.kWaitingPayment)
      return "Waiting Down Payment";
    if (lastOrderStatus == OrderStatus.kCancelled) return "Order is Cancelled";
    if (lastOrderStatus == OrderStatus.kDone)
      return "Order is finished, Thank You";
    if (lastOrderStatus == OrderStatus.kOnProgress) return "On progress";
    return "No Status";
  }

  String get formattedPaymentStatus {
    if (paymentStatus == PaymentStatus.kNotPaid) return "Not Paid";
    if (paymentStatus == PaymentStatus.kPaidHalf) return "Paid Half";
    if (paymentStatus == PaymentStatus.kPaidFull) return "Paid Fully";
    return "No Status";
  }

  OrderDay get orderDay {
    if (this.orderDate == null) return null;
    if (this.lastOrderStatus == OrderStatus.kDone) return OrderDay.past;
    if (this.lastOrderStatus == OrderStatus.kCancelled) return OrderDay.past;
    final DateTime todayDate = DateTime.now();
    Duration difference = this.orderDate.difference(todayDate);

    if (todayDate.isAfter(this.orderDate)) return OrderDay.past;
    if (difference < Duration(hours: 24)) return OrderDay.today;
    return OrderDay.upcoming;
  }

  String get formattedPaymentMethod =>
      "${this.paymentMethod[0].toUpperCase()}${this.paymentMethod.substring(1)}";

  int get orderDayPoint {
    switch (orderDay) {
      case OrderDay.today:
        return 1;
        break;
      case OrderDay.upcoming:
        return 2;
        break;
      case OrderDay.past:
        return 3;
        break;
    }
    return 0;
  }

  @override
  String toString() {
    return 'Order{orderUid: $orderUid, merchantUid: $merchantUid, userUid: $userUid, menus: $menus, orderStatus: $orderStatus, paymentStatus: $paymentStatus, total: $total, orderDate: $orderDate}';
  }
}
