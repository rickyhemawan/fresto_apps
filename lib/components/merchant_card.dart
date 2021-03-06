import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fresto_apps/components/text_and_image_progress_animation.dart';
import 'package:fresto_apps/models/merchant.dart';
import 'package:fresto_apps/models_data/client_data/client_merchant_data.dart';
import 'package:fresto_apps/utils/constants.dart';
import 'package:provider/provider.dart';

class LoadingMerchantCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        height: 240.0,
        padding: EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: TextAndImageProgressAnimation(),
            ),
            Expanded(
              flex: 0,
              child: TextAndImageProgressAnimation(
                height: 15.0,
                width: 120.0,
              ),
            ),
            Expanded(
              flex: 0,
              child: TextAndImageProgressAnimation(
                height: 15.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MerchantCard extends StatelessWidget {
  final Merchant merchant;
  final Function onTap;

  MerchantCard({this.merchant, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (onTap != null) {
          onTap();
          return;
        }
        Provider.of<ClientMerchantData>(context)
            .setMerchant(merchant: merchant);
        Navigator.pushNamed(context, kMerchantDetailScreenRoute);
      },
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(3.0),
              child: CachedNetworkImage(
                height: 180.0,
                imageUrl: merchant.imageUrl ?? kDummyMerchantImage,
                fit: BoxFit.fill,
              ),
            ),
            Container(
              padding: EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    merchant.merchantName ?? kDummyMerchantName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    merchant.locationName ?? kDummyMerchantAddress,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
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
