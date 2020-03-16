import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fresto_apps/apis/collection_names.dart';
import 'package:fresto_apps/models/helper/payment_info.dart';
import 'package:fresto_apps/models/order.dart';
import 'package:uuid/uuid.dart';

class OrderAPI {
  static Future<String> createOrder({@required Order order}) async {
    if (order == null) return "Order is null";
    if (order.merchantUid == null)
      return "Merchant is not capable of handling new request";
    if (order.userUid == null) return "Auth Failed";
    if (order.orderDate == null) return "Please set the reservation date first";
    if (order.menus.isEmpty) return "Please add menu(s) before proceeding";

    String uid = Uuid().v4().toString();
    order.orderUid = uid;
    if (order.paymentStatus == null)
      order.paymentStatus = PaymentStatus.kNotPaid;

    try {
      await Firestore.instance
          .collection(kOrderCollection)
          .document(order.orderUid)
          .setData(order.toJson());
      return null;
    } catch (e) {
      print(e);
      return "Error creating order";
    }
  }

  static Stream listenOrder({String clientUid, String merchantUid}) {
    final Firestore firestore = Firestore.instance;
    if (merchantUid != null) {
      return firestore
          .collection(kOrderCollection)
          .where("merchantUid", isEqualTo: merchantUid)
          .snapshots();
    }
    if (clientUid != null) {
      return firestore
          .collection(kOrderCollection)
          .where("userUid", isEqualTo: clientUid)
          .snapshots();
    }
    return null;
  }

  static Future<String> updateOrderStatusAndPayment(
      {@required String status,
      @required Order order,
      PaymentInfo paymentInfo,
      String paymentStatus}) async {
    if (status == null) return "Order Status must not be empty";
    if (order == null) return "Order must not be empty";
    if (paymentInfo != null && paymentStatus == null)
      return "Please select a down payment first";

    // Creating new updated order status
    List<String> tempStatus = [];
    tempStatus.addAll(order.orderStatus);
    tempStatus.add(status);

    // Creating Query for firebase
    Map<String, dynamic> requestBody = {
      "orderStatus": tempStatus,
    };

    if (paymentInfo != null && paymentStatus != null) {
      requestBody.addAll({
        "paymentStatus": paymentStatus,
        "paymentUid": paymentInfo.transactionId,
        "paymentMethod": paymentInfo.paymentType,
      });
    }

    try {
      await Firestore.instance
          .collection(kOrderCollection)
          .document(order.orderUid)
          .updateData(requestBody);
    } catch (e) {
      print(e);
      return "Error updating status";
    }

    return null;
  }
}
