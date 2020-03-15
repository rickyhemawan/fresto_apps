import 'package:flutter/material.dart';
import 'package:fresto_apps/models_data/client_data/client_data.dart';
import 'package:fresto_apps/models_data/user_auth_data.dart';
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
              Text(Provider.of<ClientData>(context).getClientName()),
              Divider(
                indent: 4.0,
                endIndent: 4.0,
              ),
              Text(Provider.of<ClientData>(context).getClientEmail()),
              Text(Provider.of<ClientData>(context).getClientPhoneNumber()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _locationSection() {
    // TODO enable location or disable location tracking
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
            Provider.of<UserAuthData>(context).signOutUser(context);
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
