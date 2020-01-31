import 'package:flutter/material.dart';
import 'package:fresto_apps/models_data/merchants_data.dart';
import 'package:fresto_apps/models_data/user_auth_data.dart';
import 'package:fresto_apps/utils/constants.dart';
import 'package:provider/provider.dart';

class AdminMainScreen extends StatefulWidget {
  @override
  _AdminMainScreenState createState() => _AdminMainScreenState();
}

class _AdminMainScreenState extends State<AdminMainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Fresto Admin Page"),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            ListView(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.add),
                  title: Text("Register New Merchant"),
                  trailing: Icon(Icons.navigate_next),
                  onTap: () => Navigator.pushNamed(
                      context, kAdminAddMerchantScreenRoute),
                ),
                ListTile(
                    leading: Icon(Icons.list),
                    title: Text("Show all merchants"),
                    trailing: Icon(Icons.navigate_next),
                    onTap: () {
                      Provider.of<MerchantsData>(context)
                          .fetchMerchantsFromDatabase();
                      Navigator.pushNamed(
                          context, kAdminShowMerchantsScreenRoute);
                    }),
                ListTile(
                  leading: Icon(Icons.exit_to_app),
                  title: Text("Log Out"),
                  trailing: Icon(Icons.navigate_next),
                  onTap: () =>
                      Provider.of<UserAuthData>(context).signOutUser(context),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
