import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fresto_apps/components/text_and_image_progress_animation.dart';
import 'package:fresto_apps/models/client.dart';
import 'package:fresto_apps/models/merchant.dart';
import 'package:fresto_apps/models/order.dart';
import 'package:fresto_apps/models_data/update_order_data.dart';
import 'package:fresto_apps/utils/constants.dart';
import 'package:provider/provider.dart';

class LoadingOrderCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
              flex: 0,
              child: TextAndImageProgressAnimation(
                height: 72.0,
                width: 72.0,
              ),
            ),
            Expanded(
              flex: 0,
              child: SizedBox(
                width: 8.0,
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextAndImageProgressAnimation(
                    height: 15.0,
                    width: 80.0,
                  ),
                  TextAndImageProgressAnimation(
                    height: 15.0,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OrderCard extends StatelessWidget {
  final Order order;
  final Merchant merchant;

  OrderCard({@required this.order, @required this.merchant});

  @override
  Widget build(BuildContext context) {
    Color getColor() {
      switch (this.order.orderDay) {
        case OrderDay.today:
          return Colors.green;
        case OrderDay.upcoming:
          return Colors.orange;
        case OrderDay.past:
          return Colors.grey;
      }
      return Colors.black;
    }

    String getLabel() {
      switch (this.order.orderDay) {
        case OrderDay.today:
          return "Today Reservation";
        case OrderDay.upcoming:
          return "Upcoming Reservation";
        case OrderDay.past:
          return "Past Reservation";
      }
      return null;
    }

    return InkWell(
      onTap: () {
        Provider.of<UpdateOrderData>(context).setOrderData(
          merchant: this.merchant,
          order: this.order,
        );
        Provider.of<UpdateOrderData>(context).setAccessedByMerchant(false);
        Provider.of<UpdateOrderData>(context).setClient(null);
        Provider.of<UpdateOrderData>(context).onDownPaymentSelected(null);
        Navigator.pushNamed(context, kOrderScreenRoute);
      },
      child: Card(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 0,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(3.0),
                  child: CachedNetworkImage(
                    imageUrl: merchant.imageUrl ?? kDummyMerchantImage,
                    height: 72.0,
                    width: 72.0,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Expanded(
                flex: 0,
                child: SizedBox(
                  width: 8.0,
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      merchant.merchantName ?? kDummyMerchantName,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                    ),
                    order.orderDayPoint < 3
                        ? Text(
                            "Order Status: ${order.formattedOrderStatus}",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: getColor(),
                            ),
                          )
                        : SizedBox(),
                    Text(
                      "${getLabel()}, ${order.formattedTime}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: getColor(),
                      ),
                    ),
                    SizedBox(height: 4.0),
                    Container(
                      width: double.infinity,
                      alignment: Alignment.centerRight,
                      child: Text(
                        "Tap to see reservation details",
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MerchantOrderCard extends StatelessWidget {
  final Order order;
  final Client client;
  final Merchant merchant;

  MerchantOrderCard({this.order, this.client, this.merchant});

  @override
  Widget build(BuildContext context) {
    Color textColor;
    switch (this.order.orderDay) {
      case OrderDay.today:
        textColor = Colors.orange;
        break;
      case OrderDay.upcoming:
        textColor = Colors.green;
        break;
      case OrderDay.past:
        textColor = Colors.grey;
        break;
    }
    return InkWell(
      onTap: () {
        Provider.of<UpdateOrderData>(context).setOrderData(
          order: order,
          merchant: merchant,
          client: client,
        );
        Provider.of<UpdateOrderData>(context).setAccessedByMerchant(true);
        Navigator.pushNamed(context, kOrderScreenRoute);
      },
      child: Card(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "Order Status: ${order.formattedOrderStatus}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
              ),
              Text(
                "Customer Name: ${client.fullName}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
              ),
              Text(
                order.formattedTime,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              Text(
                "Total: Rp ${order.total}",
              ),
              SizedBox(height: 4.0),
              Container(
                width: double.infinity,
                alignment: Alignment.centerRight,
                child: Text(
                  "Tap to see More",
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
