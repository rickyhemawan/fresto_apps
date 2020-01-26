import 'package:flutter/material.dart';
import 'package:fresto_apps/components/merchant_card.dart';
import 'package:fresto_apps/models_data/merchants_data.dart';
import 'package:provider/provider.dart';

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
        (context, index) {
          return MerchantCard(
            merchant: Provider.of<MerchantsData>(context).getMerchants()[index],
          );
        },
        childCount: Provider.of<MerchantsData>(context).getMerchants().length,
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
