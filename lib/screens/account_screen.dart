import 'package:flutter/material.dart';
import 'package:fresto_apps/models_data/current_user_data.dart';
import 'package:provider/provider.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key key}) : super(key: key);
  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  Widget _appBar() {
    return SliverAppBar(
      title: Text("Account"),
      floating: true,
    );
  }

  Widget _accountSection() {
    return SliverToBoxAdapter(
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text("Ricky Hemawan"),
              Divider(
                indent: 4.0,
                endIndent: 4.0,
              ),
              Text("rickyhemawan@gmail.com"),
              Text("+6281234567890"),
            ],
          ),
        ),
      ),
    );
  }

  Widget _logoutSection() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: MaterialButton(
          key: Key("btnAccountSignOut"),
          padding: EdgeInsets.all(8.0),
          color: Colors.red,
          textColor: Colors.white,
          child: Text("Sign Out"),
          onPressed: () {
            Provider.of<CurrentUserData>(context).signOutUser(context);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        _appBar(),
        _accountSection(),
        _logoutSection(),
      ],
    );
  }
}
