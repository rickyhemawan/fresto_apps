import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fresto_apps/components/modify_text_field.dart';
import 'package:fresto_apps/models_data/client_data/client_data.dart';
import 'package:fresto_apps/models_data/user_auth_data.dart';
import 'package:fresto_apps/utils/constants.dart';
import 'package:provider/provider.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key key}) : super(key: key);
  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  Widget _appBar() {
    return SliverAppBar(
      title: Text("Account"),
      floating: true,
    );
  }

  Widget _accountSection(ClientData clientData) {
    return SliverToBoxAdapter(
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(clientData.getClientName()),
              Divider(
                indent: 4.0,
                endIndent: 4.0,
              ),
              Text(clientData.getClientEmail()),
              Text(clientData.getClientPhoneNumber()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _allowTrackingSection(ClientData clientData) {
    return SliverToBoxAdapter(
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "Allow Tracking",
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
              Checkbox(
                onChanged: clientData.toggleAllowTracking,
                value: clientData.isTrackingAllowed(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _trackingTerms() {
    return SliverToBoxAdapter(
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
        child: Text(
          kTrackingTerms,
          textAlign: TextAlign.justify,
        ),
      ),
    );
  }

  Widget _modifyAccountSection(BuildContext context, ClientData clientData) {
    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.all(8.0),
        margin: EdgeInsets.symmetric(
          horizontal: 8.0,
        ),
        child: ListView(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.title),
              title: Text("Modify Name"),
              trailing: Icon(Icons.edit),
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return ModifyTextField(
                        isClient: true,
                        hintText: "Name",
                        context: context,
                        textController: nameController,
                        onConfirm: clientData.setClientName,
                      );
                    });
              },
            ),
            ListTile(
                leading: Icon(Icons.phone),
                title: Text("Modify Phone Number"),
                trailing: Icon(Icons.edit),
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return ModifyTextField(
                          isClient: true,
                          hintText: "Phone Number",
                          keyboardType: TextInputType.number,
                          context: context,
                          textController: phoneController,
                          onConfirm: clientData.setClientPhoneNumber,
                        );
                      });
                }),
          ],
        ),
      ),
    );
  }

  Widget _saveChangesSection(ClientData clientData) {
    if (clientData.isLoading) {
      return SliverToBoxAdapter(
        child: Container(
          width: double.infinity,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    // This button on pressed action
    void onPressed() async {
      clientData.setLoading(true);
      String msg = await clientData.saveChanges();
      clientData.setLoading(false);
      if (msg != null) {
        Fluttertoast.showToast(msg: msg);
        return;
      }
      Fluttertoast.showToast(msg: "Account updated successfully!");
    }

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: MaterialButton(
          padding: EdgeInsets.all(8.0),
          color: clientData.isSameAsPrevious() ? Colors.grey : Colors.green,
          textColor: Colors.white,
          child: Text("Update Account"),
          onPressed: onPressed,
        ),
      ),
    );
  }

  Widget _logoutSection(ClientData clientData) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: MaterialButton(
          key: Key("btnAccountSignOut"),
          padding: EdgeInsets.all(8.0),
          color: Colors.red,
          textColor: Colors.white,
          child: Text("Sign Out"),
          onPressed: () {
            clientData.unsubscribeFCM();
            Provider.of<UserAuthData>(context).signOutUser(context);
            clientData.setTracking(false);
          },
        ),
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
    return Consumer<ClientData>(
      builder: (context, clientData, child) {
        return CustomScrollView(
          slivers: <Widget>[
            _appBar(),
            _sectionTitle("Details"),
            _accountSection(clientData),
            _sectionTitle("Modify",
                margin: EdgeInsets.only(top: 4.0, left: 16.0)),
            _modifyAccountSection(context, clientData),
            _allowTrackingSection(clientData),
            _trackingTerms(),
            _saveChangesSection(clientData),
            _logoutSection(clientData),
          ],
        );
      },
    );
  }
}
