import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fresto_apps/components/fab_with_notifications.dart';
import 'package:fresto_apps/components/food_card.dart';
import 'package:fresto_apps/utils/constants.dart';

class MerchantDetailScreen extends StatefulWidget {
  @override
  _MerchantDetailScreenState createState() => _MerchantDetailScreenState();
}

class _MerchantDetailScreenState extends State<MerchantDetailScreen> {
  Widget _appBar(BuildContext context) {
    return SliverAppBar(
      title: Text("Merchant Details"),
      expandedHeight: 200,
      flexibleSpace: FlexibleSpaceBar(
        background: CachedNetworkImage(
          imageUrl: kDummyMerchantImage,
          fit: BoxFit.cover,
        ),
      ),
      pinned: true,
    );
  }

  Widget _statusSection() {
    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.all(8.0),
        margin: EdgeInsets.symmetric(
          horizontal: 8.0,
        ),
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Text(
                kDummyMerchantOpenStatus,
                textAlign: TextAlign.justify,
              ),
            ),
            Expanded(
              flex: 0,
              child: SizedBox(width: 16.0),
            ),
            Expanded(
              flex: 0,
              child: Container(
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(3.0)),
                    border: Border.all(
                      color: Colors.green,
                    )),
                child: Text(
                  "Open",
                  style: TextStyle(
                    color: Colors.green,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _addressSection() {
    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.all(8.0),
        margin: EdgeInsets.symmetric(
          horizontal: 8.0,
        ),
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Text(
                kDummyMerchantAddress,
                textAlign: TextAlign.justify,
              ),
            ),
            Expanded(
              flex: 0,
              child: SizedBox(width: 8.0),
            ),
            Expanded(
              flex: 0,
              child: IconButton(
                icon: Icon(
                  Icons.location_searching,
                  size: 24.0,
                  color: Colors.orange,
                ),
                onPressed: () {
                  Fluttertoast.showToast(
                    msg: "Opening Google Map",
                    gravity: ToastGravity.CENTER,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _descriptionSection() {
    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.all(8.0),
        margin: EdgeInsets.symmetric(
          horizontal: 8.0,
        ),
        child: Text(
          kDummyDescription,
          textAlign: TextAlign.justify,
        ),
      ),
    );
  }

  Widget _menuSection() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, int) {
          return FoodCardWithOrder();
        },
        childCount: 8,
      ),
    );
  }

  Widget _sectionTitle(String title, {EdgeInsetsGeometry margin}) {
    return SliverToBoxAdapter(
      child: Container(
        margin: margin ?? EdgeInsets.fromLTRB(16.0, 16.0, 8.0, 4.0),
        child: Text(
          title,
          style: Theme.of(context).textTheme.title,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: CustomScrollView(
          slivers: <Widget>[
            _appBar(context),
            _sectionTitle(kDummyMerchantName),
            _statusSection(),
            _sectionTitle("Address"),
            _addressSection(),
            _sectionTitle("Description"),
            _descriptionSection(),
            _sectionTitle("Menu"),
            _menuSection(),
          ],
        ),
      ),
      floatingActionButton: FABWithNotifications(),
    );
  }
}
