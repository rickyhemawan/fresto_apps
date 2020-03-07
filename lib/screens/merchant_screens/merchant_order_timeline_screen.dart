import 'package:flutter/material.dart';
import 'package:fresto_apps/models/merchant.dart';
import 'package:fresto_apps/models_data/merchant_data/merchant_data.dart';
import 'package:fresto_apps/models_data/merchant_data/merchant_order_timeline_data.dart';
import 'package:provider/provider.dart';

class MerchantOrderTimelineScreen extends StatefulWidget {
  const MerchantOrderTimelineScreen({Key key}) : super(key: key);
  @override
  _MerchantOrderTimelineScreenState createState() =>
      _MerchantOrderTimelineScreenState();
}

class _MerchantOrderTimelineScreenState
    extends State<MerchantOrderTimelineScreen> {
  Widget _appBar(BuildContext context) {
    return SliverAppBar(
      title: Text("Orders"),
      floating: true,
    );
  }

  Widget _contentSection(
      MerchantOrderTimelineData timelineData, BuildContext context) {
    Merchant merchant =
        Provider.of<MerchantData>(context).merchant ?? Merchant();
    return SliverToBoxAdapter(
      child: timelineData.streamOrders(
        merchant,
        Theme.of(context).textTheme.title.copyWith(
              color: Colors.white,
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MerchantOrderTimelineData>(
      builder: (context, timelineData, child) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: CustomScrollView(
              slivers: <Widget>[
                _appBar(context),
                _contentSection(timelineData, context)
              ],
            ),
          ),
        );
      },
    );
  }
}

// Today Reservation
// Upcoming Reservation
// Past Reservation
