import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fresto_apps/components/fab_with_notifications.dart';
import 'package:fresto_apps/components/food_card.dart';
import 'package:fresto_apps/models/menu.dart';
import 'package:fresto_apps/models_data/client_data/client_merchant_data.dart';
import 'package:fresto_apps/models_data/client_data/client_order_data.dart';
import 'package:provider/provider.dart';

class MerchantDetailScreen extends StatefulWidget {
  @override
  _MerchantDetailScreenState createState() => _MerchantDetailScreenState();
}

class _MerchantDetailScreenState extends State<MerchantDetailScreen> {
  Widget _appBar(BuildContext context, ClientMerchantData merchantData) {
    return SliverAppBar(
      title: Text("Merchant Details"),
      expandedHeight: 200,
      flexibleSpace: FlexibleSpaceBar(
        background: merchantData.getMerchantImage(),
      ),
      pinned: true,
    );
  }

  Widget _statusSection(ClientMerchantData merchantData) {
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
                merchantData.getMerchantOperatingHour(),
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
                    color: merchantData.isMerchantOpen()
                        ? Colors.green
                        : Colors.red,
                  ),
                ),
                child: Text(
                  merchantData.isMerchantOpen() ? "Open" : "Close",
                  style: TextStyle(
                    color: merchantData.isMerchantOpen()
                        ? Colors.green
                        : Colors.red,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _addressSection(ClientMerchantData merchantData) {
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
                merchantData.getMerchantAddress(),
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

  Widget _descriptionSection(ClientMerchantData merchantData) {
    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.all(8.0),
        margin: EdgeInsets.symmetric(
          horizontal: 8.0,
        ),
        child: Text(
          merchantData.getMerchantDescription(),
          textAlign: TextAlign.justify,
        ),
      ),
    );
  }

  Widget _menuSection(ClientMerchantData merchantData) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          Menu menu = merchantData.getMenus()[index];
          return FoodCardWithOrder(
            menu: menu,
            onAdd: () => Provider.of<ClientOrderData>(context)
                .addMenu(menu: menu, merchant: merchantData.merchant),
            onMinus: () =>
                Provider.of<ClientOrderData>(context).removeMenu(menu: menu),
            quantity: Provider.of<ClientOrderData>(context)
                .getMenuQuantity(menu: menu),
          );
        },
        childCount: merchantData.getMenus().length,
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
    return Consumer<ClientMerchantData>(
      builder: (context, merchantData, child) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: CustomScrollView(
              slivers: <Widget>[
                _appBar(context, merchantData),
                _sectionTitle(merchantData.merchant.merchantName),
                _statusSection(merchantData),
                _sectionTitle("Address"),
                _addressSection(merchantData),
                _sectionTitle("Description"),
                _descriptionSection(merchantData),
                _sectionTitle("Menu"),
                _menuSection(merchantData),
              ],
            ),
          ),
          floatingActionButton:
              Provider.of<ClientOrderData>(context).isMenuEmpty()
                  ? SizedBox()
                  : FABWithNotifications(),
        );
      },
    );
  }
}
