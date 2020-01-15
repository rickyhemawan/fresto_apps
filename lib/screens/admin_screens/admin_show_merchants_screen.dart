import 'package:flutter/material.dart';
import 'package:fresto_apps/components/merchant_card.dart';

class AdminShowMerchantsScreen extends StatefulWidget {
  @override
  _AdminShowMerchantsScreenState createState() =>
      _AdminShowMerchantsScreenState();
}

class _AdminShowMerchantsScreenState extends State<AdminShowMerchantsScreen> {
  Widget _appBar() {
    return SliverAppBar(
      title: Text("Merchants"),
      floating: true,
    );
  }

  Widget _contentSection() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, int) {
          return MerchantCard();
        },
        childCount: 8,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          _appBar(),
          _contentSection(),
        ],
      ),
    );
  }
}
