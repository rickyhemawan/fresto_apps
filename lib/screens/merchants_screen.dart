import 'package:flutter/material.dart';
import 'package:fresto_apps/components/merchant_card.dart';

class MerchantsScreen extends StatefulWidget {
  const MerchantsScreen({Key key}) : super(key: key);

  @override
  _MerchantsScreenState createState() => _MerchantsScreenState();
}

class _MerchantsScreenState extends State<MerchantsScreen> {
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
    return CustomScrollView(
      slivers: <Widget>[
        _appBar(),
        _contentSection(),
      ],
    );
  }
}
