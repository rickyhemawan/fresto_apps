import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fresto_apps/components/text_and_image_progress_animation.dart';
import 'package:fresto_apps/utils/constants.dart';

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
              child: ClipRRect(
                borderRadius: BorderRadius.circular(3.0),
                child: CachedNetworkImage(
                  imageUrl: kDummyMerchantImage,
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
                    kDummyMerchantName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                  ),
                  Text(
                    "Upcoming Reservation, 31 December 2019 at 7:00 PM",
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
    );
  }
}
