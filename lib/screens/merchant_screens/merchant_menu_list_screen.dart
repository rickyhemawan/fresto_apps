import 'package:flutter/material.dart';
import 'package:fresto_apps/components/food_card.dart';
import 'package:fresto_apps/utils/constants.dart';

class MerchantMenuListScreen extends StatefulWidget {
  const MerchantMenuListScreen({Key key}) : super(key: key);

  @override
  _MerchantMenuListScreenState createState() => _MerchantMenuListScreenState();
}

class _MerchantMenuListScreenState extends State<MerchantMenuListScreen> {
  Widget _menuSection() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, int) {
          return FoodCardWithEdit();
        },
        childCount: 8,
      ),
    );
  }

  Widget _appBar(BuildContext context) {
    return SliverAppBar(
      title: Text("Menu"),
      floating: true,
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
            _menuSection(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            Navigator.pushNamed(context, kMerchantAddSingleMenuScreenRoute),
        child: Icon(Icons.add),
      ),
    );
  }
}
