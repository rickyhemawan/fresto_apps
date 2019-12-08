import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fresto_apps/components/bottom_navigation_icon.dart';
import 'package:fresto_apps/components/fab_with_notifications.dart';
import 'package:fresto_apps/screens/account_screen.dart';
import 'package:fresto_apps/screens/home_screen.dart';
import 'package:fresto_apps/screens/merchants_screen.dart';
import 'package:fresto_apps/screens/order_timeline_screen.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _page = 0;

  final PageStorageBucket _bucket = PageStorageBucket();

  void _onTabTapped(int index) => setState(() => _page = index);

  final List<Widget> _bodyList = [
    HomeScreen(key: PageStorageKey("Page0")),
    MerchantsScreen(key: PageStorageKey("Page1")),
    OrderTimelineScreen(key: PageStorageKey("Page2")),
    AccountScreen(key: PageStorageKey("Page3")),
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
            BottomNavigationIcon(Icons.list),
            BottomNavigationIcon(Icons.store),
            BottomNavigationIcon(Icons.room_service),
            BottomNavigationIcon(Icons.person),
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
        floatingActionButton: FABWithNotifications(),
      ),
    );
  }
}
