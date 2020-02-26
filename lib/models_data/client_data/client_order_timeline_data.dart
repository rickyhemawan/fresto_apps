import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fresto_apps/apis/merchant_api.dart';
import 'package:fresto_apps/apis/order_api.dart';
import 'package:fresto_apps/components/order_card.dart';
import 'package:fresto_apps/models/merchant.dart';
import 'package:fresto_apps/models/order.dart';

class ClientOrderTimelineData extends ChangeNotifier {
  List<Merchant> merchants;
  String userUid;

  Widget streamOrders() {
    if (userUid == null) return SizedBox();
    return StreamBuilder<QuerySnapshot>(
      stream: OrderAPI.listenOrder(clientUid: userUid),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return SizedBox();
        List<DocumentSnapshot> documents = snapshot.data.documents;
        List<Order> orders = ordersFromSnapshots(documents);
        print(documents);
        if (snapshot.hasData && this.merchants == null) {
          getMerchantsFromDatabase();
          return Container(
            margin: EdgeInsets.only(top: 80.0),
            alignment: Alignment.center,
            child: CircularProgressIndicator(),
          );
        }
        return ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: orders.length,
          itemBuilder: (context, index) {
            Merchant merchant =
                findMerchantByUid(orders[index].merchantUid) ?? Merchant();
            return OrderCard(order: orders[index], merchant: merchant);
          },
        );
      },
    );
  }

  void getMerchantsFromDatabase() async {
    if (merchants == null) merchants = [];
    merchants = await MerchantAPI.getMerchantsFromDatabase();
    notifyListeners();
  }

  Merchant findMerchantByUid(String uid) {
    return merchants.firstWhere((merchant) => merchant.userUid == uid);
  }

  List<Order> ordersFromSnapshots(List<DocumentSnapshot> documents) {
    List<Order> orders = [];
    documents.forEach((snapshot) {
      orders.add(Order.fromJson(snapshot.data));
    });
    print("orders => ${orders[0].menus[0]}");
    return orders;
  }

  void updateUserUid() async {
    await FirebaseAuth.instance
        .currentUser()
        .then((user) => this.userUid = user.uid);
    notifyListeners();
  }

  void setMerchants(List<Merchant> merchants) {
    this.merchants = merchants;
    notifyListeners();
  }
}
