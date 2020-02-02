import 'package:flutter/material.dart';
import 'package:fresto_apps/components/food_card.dart';
import 'package:fresto_apps/models_data/merchant_data/merchant_data.dart';
import 'package:fresto_apps/models_data/merchant_data/merchant_modify_menu_data.dart';
import 'package:fresto_apps/utils/constants.dart';
import 'package:provider/provider.dart';

class MerchantMenuListScreen extends StatefulWidget {
  const MerchantMenuListScreen({Key key}) : super(key: key);

  @override
  _MerchantMenuListScreenState createState() => _MerchantMenuListScreenState();
}

class _MerchantMenuListScreenState extends State<MerchantMenuListScreen> {
  Widget _menuSection(MerchantData merchantData) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) =>
            FoodCardWithEdit(menu: merchantData.getMenus()[index]),
        childCount: merchantData.getMenus().length,
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
    return Consumer<MerchantData>(
      builder: (context, merchantData, child) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: CustomScrollView(
              slivers: <Widget>[
                _appBar(context),
                _menuSection(merchantData),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Provider.of<MerchantModifyMenuData>(context).resetMenuValue();
              Navigator.pushNamed(context, kMerchantAddSingleMenuScreenRoute);
            },
            child: Icon(Icons.add),
          ),
        );
      },
    );
  }
}
