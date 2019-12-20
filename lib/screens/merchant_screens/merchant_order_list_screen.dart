import 'package:flutter/material.dart';
import 'package:fresto_apps/components/order_card.dart';
import 'package:fresto_apps/utils/constants.dart';

class MerchantOrderListScreen extends StatefulWidget {
  const MerchantOrderListScreen({Key key}) : super(key: key);
  @override
  _MerchantOrderListScreenState createState() =>
      _MerchantOrderListScreenState();
}

class _MerchantOrderListScreenState extends State<MerchantOrderListScreen> {
  Widget _appBar(BuildContext context) {
    return SliverAppBar(
      title: Text("Orders"),
      floating: true,
    );
  }

  Widget _todayOrderSection() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, int) {
          return MerchantOrderCard();
        },
        childCount: 1,
      ),
    );
  }

  Widget _upcomingOrderSection() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, int) {
          return MerchantOrderCard(orderDay: OrderDay.upcoming);
        },
        childCount: 3,
      ),
    );
  }

  Widget _historyOrderSection() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, int) {
          return MerchantOrderCard(orderDay: OrderDay.past);
        },
        childCount: 5,
      ),
    );
  }

  Widget _sectionTitle(String title, {EdgeInsetsGeometry margin, Color color}) {
    return SliverToBoxAdapter(
      child: Container(
        color: color ?? Colors.green,
        margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
        padding: margin ?? EdgeInsets.fromLTRB(16.0, 16.0, 8.0, 4.0),
        child: Text(
          title,
          style: Theme.of(context).textTheme.title.copyWith(
                color: Colors.white,
              ),
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
            _sectionTitle("Today Reservation", color: Colors.orange),
            _todayOrderSection(),
            _sectionTitle("Upcoming Reservation"),
            _upcomingOrderSection(),
            _sectionTitle("Past Reservation", color: Colors.grey),
            _historyOrderSection(),
          ],
        ),
      ),
    );
  }
}
