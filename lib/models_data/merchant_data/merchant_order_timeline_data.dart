import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fresto_apps/apis/auth_api.dart';
import 'package:fresto_apps/apis/client_api.dart';
import 'package:fresto_apps/apis/order_api.dart';
import 'package:fresto_apps/components/order_card.dart';
import 'package:fresto_apps/models/client.dart';
import 'package:fresto_apps/models/merchant.dart';
import 'package:fresto_apps/models/order.dart';
import 'package:fresto_apps/utils/constants.dart';

class MerchantOrderTimelineData extends ChangeNotifier {
  List<Client> clients;
  String merchantUid;

  // Im sorry my future self, I'm currently bored and stressed out doing this,
  // So I felt that I need to rush things over to get this app
  // done ASAP so I put my view inside the provider data
  // which is bad for the good practice ideology. Sorry :(

  Widget _sectionTitle(String title,
      {EdgeInsetsGeometry margin, Color color, TextStyle textStyle}) {
    return Container(
      color: color ?? Colors.green,
      margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      padding: margin ?? EdgeInsets.fromLTRB(16.0, 16.0, 8.0, 4.0),
      child: Text(
        title,
        style: textStyle,
      ),
    );
  }

  Widget _listViewBuilder(List<Order> orders, Merchant merchant) {
    if (orders.isEmpty)
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: Text("Order is Empty"),
      );
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        Order tempOrder = orders[index];
        if (clients == null) return Center(child: CircularProgressIndicator());
        Client client = findClientByUid(tempOrder.userUid) ?? Client();
        return MerchantOrderCard(
          order: tempOrder,
          client: client,
          merchant: merchant,
        );
      },
    );
  }

  Widget streamOrders(Merchant merchant, TextStyle textStyle) {
    if (merchantUid == null) return SizedBox();
    return StreamBuilder<QuerySnapshot>(
      stream: OrderAPI.listenOrder(merchantUid: this.merchantUid),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return SizedBox();
        List<DocumentSnapshot> documents = snapshot.data.documents;
        List<Order> orders = ordersFromSnapshots(documents);
        print(documents);
        if (snapshot.hasData && this.clients == null) {
          getClientsFromDatabase();
          return Container(
            margin: EdgeInsets.only(top: 80.0),
            alignment: Alignment.center,
            child: CircularProgressIndicator(),
          );
        }
        List<Order> todayOrders = [];
        List<Order> upcomingOrders = [];
        List<Order> pastOrders = [];

        todayOrders
            .addAll(orders.where((order) => order.orderDay == OrderDay.today));
        upcomingOrders.addAll(
            orders.where((order) => order.orderDay == OrderDay.upcoming));
        pastOrders
            .addAll(orders.where((order) => order.orderDay == OrderDay.past));

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _sectionTitle("Today Reservation",
                color: Colors.orange, textStyle: textStyle),
            _listViewBuilder(todayOrders, merchant),
            _sectionTitle("Upcoming Reservation", textStyle: textStyle),
            _listViewBuilder(upcomingOrders, merchant),
            _sectionTitle("Past Reservation",
                color: Colors.grey, textStyle: textStyle),
            _listViewBuilder(pastOrders, merchant),
          ],
        );
      },
    );
  }

  Client findClientByUid(String uid) {
    print("clients.length => ${clients.length}");
    return this
        .clients
        .firstWhere((client) => client.userUid == uid, orElse: () => Client());
  }

  List<Order> ordersFromSnapshots(List<DocumentSnapshot> documents) {
    List<Order> orders = [];
    documents.forEach((snapshot) {
      orders.add(Order.fromJson(snapshot.data));
    });
    print("orders => ${orders[0].menus[0]}");
    return orders;
  }

  void getClientsFromDatabase() async {
    if (clients == null) clients = [];
    clients = await ClientAPI.getClientsFromDatabase();
    notifyListeners();
  }

  void updateMerchantUid() async {
    this.merchantUid = await AuthAPI.getCurrentUserUid();
    notifyListeners();
  }

  void setMerchants(List<Client> clients) {
    this.clients = clients;
    notifyListeners();
  }
}
