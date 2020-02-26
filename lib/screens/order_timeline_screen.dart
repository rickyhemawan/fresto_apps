import 'package:flutter/material.dart';
import 'package:fresto_apps/models_data/client_data/client_order_timeline_data.dart';
import 'package:provider/provider.dart';

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

  Widget _contentSection(ClientOrderTimelineData timelineData) {
    return SliverToBoxAdapter(
      child: timelineData.streamOrders(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ClientOrderTimelineData>(
      builder: (context, timelineData, child) {
        return CustomScrollView(
          slivers: <Widget>[
            _appBar(),
            _contentSection(timelineData),
          ],
        );
      },
    );
  }
}
