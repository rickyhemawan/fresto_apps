import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fresto_apps/models_data/admin_data/admin_modify_merchant_data.dart';
import 'package:fresto_apps/utils/constants.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AdminAddMerchantScreen extends StatefulWidget {
  @override
  _AdminAddMerchantScreenState createState() => _AdminAddMerchantScreenState();
}

class _AdminAddMerchantScreenState extends State<AdminAddMerchantScreen> {
  Future _modifyImage() async {
    print("selecting img from gallery");
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    Provider.of<AdminModifyMerchantData>(context).uploadImage(file: image);
  }

  Widget _appBar(BuildContext context) {
    return SliverAppBar(
      title: Text("Add Merchant (Preview)"),
      expandedHeight: 200,
      flexibleSpace: FlexibleSpaceBar(
        background:
            Provider.of<AdminModifyMerchantData>(context).getMerchantImage(),
      ),
      pinned: true,
    );
  }

  Widget _statusSection() {
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
                kDummyMerchantOpenStatus,
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
                      color: Colors.green,
                    )),
                child: Text(
                  "Open",
                  style: TextStyle(
                    color: Colors.green,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _addressSection() {
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
                kDummyMerchantAddress,
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

  Widget _descriptionSection() {
    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.all(8.0),
        margin: EdgeInsets.symmetric(
          horizontal: 8.0,
        ),
        child: Text(
          kDummyDescription,
          textAlign: TextAlign.justify,
        ),
      ),
    );
  }

  Widget _modifyMerchantSection() {
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
              title: Text("Modify Restaurant Image"),
              trailing: Icon(Icons.edit),
              onTap: _modifyImage,
            ),
            ListTile(
              leading: Icon(Icons.title),
              title: Text("Modify Restaurant Name"),
              trailing: Icon(Icons.edit),
            ),
            ListTile(
              leading: Icon(Icons.wb_sunny),
              title: Text("Modify Restaurant Operating Hours"),
              trailing: Icon(Icons.edit),
            ),
            ListTile(
              leading: Icon(Icons.edit_location),
              title: Text("Modify Restaurant Address"),
              trailing: Icon(Icons.edit),
            ),
            ListTile(
              leading: Icon(Icons.details),
              title: Text("Modify Restaurant Details"),
              trailing: Icon(Icons.edit),
            ),
            ListTile(
              leading: Icon(Icons.do_not_disturb_alt),
              title: Text("Disable Restaurant Temporarily"),
              subtitle: Text("Set Restaurant Day Off"),
              trailing: Icon(Icons.edit),
            ),
          ],
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

  Widget _addMerchantButtonSection() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: MaterialButton(
          padding: EdgeInsets.all(8.0),
          color: Colors.green,
          textColor: Colors.white,
          child: Text("Add Merchant"),
          onPressed: () {
            _dummyAddMerchantFunction();
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      body: Container(
        child: SafeArea(
          child: Container(
            color: Colors.white,
            child: CustomScrollView(
              slivers: <Widget>[
                _appBar(context),
                _sectionTitle(kDummyMerchantName),
                _statusSection(),
                _sectionTitle("Address"),
                _addressSection(),
                _sectionTitle("Description"),
                _descriptionSection(),
                _sectionTitle("Modify Options"),
                _modifyMerchantSection(),
                _addMerchantButtonSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // TODO: Delete this function later
  void _dummyAddMerchantFunction() async {
//    print("main executed");
//    Merchant merchant = Merchant(email: "new@merchant.com", menus: [
//      Menu(
//          name: "MENU1",
//          price: 1000.0,
//          available: true,
//          description: "This is MENU1",
//          imageUrl: ""),
//      Menu(
//          name: "MENU2",
//          price: 2000.0,
//          available: true,
//          description: "This is MENU2",
//          imageUrl: ""),
//      Menu(
//          name: "MENU3",
//          price: 3000.0,
//          available: true,
//          description: "This is MENU3",
//          imageUrl: ""),
//    ]);
//    String password = "password1234";
//    String createMerchant = await MerchantAPI.addNewMerchantToDatabase(
//      merchant: merchant,
//      password: password,
//      confirmPassword: password,
//    );
//    print(createMerchant ?? "success adding merchant");
  }
}
