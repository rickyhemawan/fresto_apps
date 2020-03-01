import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fresto_apps/components/text_and_image_progress_animation.dart';
import 'package:fresto_apps/models/merchant.dart';
import 'package:fresto_apps/models/order.dart';
import 'package:fresto_apps/models_data/client_data/client_update_order_data.dart';
import 'package:fresto_apps/screens/merchant_screens/merchant_order_details_screen.dart';
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
    return InkWell(
      onTap: () {
        Provider.of<ClientUpdateOrderData>(context).setOrderData(
          merchant: this.merchant,
          order: this.order,
        );
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
                    Text(
                      "Upcoming Reservation, ${order.formattedTime}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
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
  final OrderDay orderDay;

  MerchantOrderCard({this.orderDay = OrderDay.today});

  @override
  Widget build(BuildContext context) {
    Color textColor;
    switch (orderDay) {
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
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MerchantOrderDetailsScreen(
            orderDay: this.orderDay,
          ),
        ),
      ),
      child: Card(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "Customer Name: $kDummyCustomerName",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
              ),
              Text(
                "31 December 2019 at 7:00 PM",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              Text(
                "Total: $kDummyFoodPrice",
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
