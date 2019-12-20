import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fresto_apps/utils/constants.dart';

class MerchantTrackClientScreen extends StatefulWidget {
  @override
  _MerchantTrackClientScreenState createState() =>
      _MerchantTrackClientScreenState();
}

class _MerchantTrackClientScreenState extends State<MerchantTrackClientScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("John Doe Location"),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: CachedNetworkImageProvider(kDummyMap),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
