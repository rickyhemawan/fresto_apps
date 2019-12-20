import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fresto_apps/components/bottom_navigation_icon.dart';
import 'package:fresto_apps/screens/merchant_screens/merchant_menu_list_screen.dart';
import 'package:fresto_apps/screens/merchant_screens/merchant_order_list_screen.dart';
import 'package:fresto_apps/screens/merchant_screens/merchant_profile_screen.dart';

class MerchantMainScreen extends StatefulWidget {
  @override
  _MerchantMainScreenState createState() => _MerchantMainScreenState();
}

class _MerchantMainScreenState extends State<MerchantMainScreen> {
  int _page = 0;

  final PageStorageBucket _bucket = PageStorageBucket();

  void _onTabTapped(int index) => setState(() => _page = index);

  final List<Widget> _bodyList = [
    MerchantOrderListScreen(key: PageStorageKey("MerchantPage0")),
    MerchantMenuListScreen(key: PageStorageKey("MerchantPage1")),
    MerchantProfileScreen(key: PageStorageKey("MerchantPage2")),
  ];

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Theme.of(context).primaryColor,
      ),
      child: Scaffold(
        bottomNavigationBar: CurvedNavigationBar(
          items: <Widget>[
            BottomNavigationIcon(Icons.history),
            BottomNavigationIcon(Icons.list),
            BottomNavigationIcon(Icons.store),
          ],
          onTap: _onTabTapped,
          buttonBackgroundColor: Theme.of(context).primaryColor,
          backgroundColor: Theme.of(context).primaryColorDark,
          color: Theme.of(context).accentColor,
        ),
        body: PageStorage(
          child: _bodyList[_page],
          bucket: _bucket,
        ),
      ),
    );
  }
}
