import 'package:flutter/material.dart';
import 'package:fresto_apps/components/order_card.dart';

class OrderTimelineScreen extends StatefulWidget {
  const OrderTimelineScreen({Key key}) : super(key: key);

  @override
  _OrderTimelineScreenState createState() => _OrderTimelineScreenState();
}

class _OrderTimelineScreenState extends State<OrderTimelineScreen> {
  Widget _appBar() {
    return SliverAppBar(
      title: Text("Orders"),
      floating: true,
    );
  }

  Widget _contentSection() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, int) {
          return OrderCard();
        },
        childCount: 1,
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
