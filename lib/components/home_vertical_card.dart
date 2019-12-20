import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fresto_apps/components/text_and_image_progress_animation.dart';
import 'package:fresto_apps/utils/constants.dart';

class LoadingHomeVerticalCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: cardWidth,
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                flex: 0,
                child: TextAndImageProgressAnimation(
                  height: 15.0,
                ),
              ),
              Expanded(
                flex: 0,
                child: TextAndImageProgressAnimation(
                  height: 15.0,
                ),
              ),
              Expanded(
                flex: 1,
                child: TextAndImageProgressAnimation(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HomeVerticalCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: cardWidth,
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, kMerchantDetailScreenRoute);
          Fluttertoast.showToast(
            msg: "Vertical Card Tapped!",
            gravity: ToastGravity.CENTER,
          );
        },
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(
                  flex: 0,
                  child: Text(
                    kDummyFoodName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Expanded(
                  flex: 0,
                  child: Text(
                    kDummyMerchantName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(3.0),
                    child: CachedNetworkImage(
                      imageUrl: kDummyFoodImage,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
