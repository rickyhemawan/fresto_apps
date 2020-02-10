import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fresto_apps/components/text_and_image_progress_animation.dart';
import 'package:fresto_apps/models/menu.dart';
import 'package:fresto_apps/models/merchant.dart';
import 'package:fresto_apps/models_data/client_data/client_merchant_data.dart';
import 'package:fresto_apps/utils/constants.dart';
import 'package:provider/provider.dart';

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
  final Merchant merchant;
  final Menu menu;

  HomeVerticalCard({this.merchant, this.menu});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: cardWidth,
      child: GestureDetector(
        onTap: () {
          Provider.of<ClientMerchantData>(context)
              .setMerchant(merchant: this.merchant);
          Navigator.pushNamed(context, kMerchantDetailScreenRoute);
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
                    menu.name ?? kDummyFoodName,
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
                    merchant.merchantName ?? kDummyMerchantName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(3.0),
                    child: CachedNetworkImage(
                      imageUrl: menu.imageUrl ?? kDummyFoodImage,
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
