import 'package:flutter/material.dart';
import 'package:fresto_apps/components/food_card.dart';

class MerchantEditSingleMenuScreen extends StatefulWidget {
  @override
  _MerchantEditSingleMenuScreenState createState() =>
      _MerchantEditSingleMenuScreenState();
}

class _MerchantEditSingleMenuScreenState
    extends State<MerchantEditSingleMenuScreen> {
  Widget _appBar(BuildContext context) {
    return SliverAppBar(
      title: Text("Edit Menu"),
      floating: true,
    );
  }

  Widget _menuDetails() {
    return SliverToBoxAdapter(
      child: FoodCardBig(),
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

  Widget _saveChangesSection() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: MaterialButton(
          padding: EdgeInsets.all(8.0),
          color: Colors.green,
          textColor: Colors.white,
          child: Text("Update Menu"),
          onPressed: () {},
        ),
      ),
    );
  }

  Widget _modifyMenuSection() {
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
              leading: Icon(Icons.add_photo_alternate),
              title: Text("Modify Menu Image"),
              trailing: Icon(Icons.edit),
            ),
            ListTile(
              leading: Icon(Icons.title),
              title: Text("Modify Menu Name"),
              trailing: Icon(Icons.edit),
            ),
            ListTile(
              leading: Icon(Icons.attach_money),
              title: Text("Modify Menu Price"),
              trailing: Icon(Icons.edit),
            ),
            ListTile(
              leading: Icon(Icons.details),
              title: Text("Modify Restaurant Details"),
              trailing: Icon(Icons.edit),
            ),
            ListTile(
              leading: Icon(Icons.do_not_disturb_alt),
              title: Text("Disable Menu Temporarily"),
              trailing: Icon(Icons.edit),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: <Widget>[
            _appBar(context),
            _sectionTitle("Menu Details"),
            _menuDetails(),
            _sectionTitle("Modify Menu"),
            _modifyMenuSection(),
            _saveChangesSection(),
          ],
        ),
      ),
    );
  }
}
