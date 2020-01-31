import 'package:flutter/material.dart';
import 'package:flutter_picker/Picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fresto_apps/models_data/maps_data/map_search_data.dart';
import 'package:fresto_apps/models_data/merchant_data/merchant_data.dart';
import 'package:fresto_apps/utils/constants.dart';
import 'package:provider/provider.dart';

class MerchantProfileScreen extends StatefulWidget {
  const MerchantProfileScreen({Key key}) : super(key: key);
  @override
  _MerchantProfileScreenState createState() => _MerchantProfileScreenState();
}

class _MerchantProfileScreenState extends State<MerchantProfileScreen> {
  // Text Fields Controllers
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();

  //--------------
  // Reusable UI's
  //--------------

  // This function show ios like number picker
  void showPickerNumber(BuildContext context,
      {void Function(int) onConfirm, Widget title}) {
    Picker(
      adapter: NumberPickerAdapter(
        data: [NumberPickerColumn(begin: 0, end: 23)],
      ),
      onConfirm: (Picker picker, List value) => onConfirm(value[0]),
      title: title,
      itemExtent: 32.0,
    ).showModal(context);
  }

  // This function show dialog to edit text's
  void _modifyTextField({
    @required BuildContext context,
    @required TextEditingController textController,
    @required String hintText,
    @required Function(String result) onConfirm,
    TextInputType keyboardType,
  }) {
    {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Change Restaurant $hintText"),
            content: TextField(
              controller: textController,
              keyboardType: keyboardType,
              decoration: InputDecoration(hintText: "Restaurant $hintText"),
            ),
            actions: <Widget>[
              FlatButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Cancel"),
              ),
              FlatButton(
                onPressed: () {
                  onConfirm(textController.text);
                  Navigator.pop(context);
                },
                child: Text("Save Changes"),
              ),
            ],
          );
        },
      );
    }
  }

  // This is the base alignment for each Sections
  Widget _sectionAlignment({@required Widget child}) {
    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.all(8.0),
        margin: EdgeInsets.symmetric(horizontal: 8.0),
        child: child,
      ),
    );
  }

  //-----------------
  // Main Contents UI
  //-----------------

  /* This is the main content of this page,
  it is ordered from top to bottom*/

  Widget _appBar(BuildContext context, MerchantData merchantData) {
    return SliverAppBar(
      title: Text("Merchant Profile"),
      expandedHeight: 200,
      flexibleSpace:
          FlexibleSpaceBar(background: merchantData.getMerchantImage()),
      pinned: true,
    );
  }

  Widget _statusSection(MerchantData merchantData) {
    return _sectionAlignment(
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
                  )),
              child: Text(
                merchantData.isMerchantOpen() ? "Open" : "Close",
                style: TextStyle(
                  color:
                      merchantData.isMerchantOpen() ? Colors.green : Colors.red,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _addressSection(MerchantData merchantData) {
    return _sectionAlignment(
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
    );
  }

  Widget _descriptionSection(MerchantData merchantData) {
    return _sectionAlignment(
      child: Text(
        merchantData.getMerchantDescription(),
        textAlign: TextAlign.justify,
      ),
    );
  }

  Widget _modifyMerchantSection(MerchantData merchantData) {
    return _sectionAlignment(
      child: ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.add_photo_alternate),
            title: Text("Modify Restaurant Image"),
            trailing: Icon(Icons.edit),
            onTap: () async =>
                await merchantData.selectImageFromGallery(context),
          ),
          ListTile(
            leading: Icon(Icons.title),
            title: Text("Modify Restaurant Name"),
            trailing: Icon(Icons.edit),
            onTap: () => _modifyTextField(
              context: context,
              textController: titleController,
              hintText: "Name",
              onConfirm: merchantData.setMerchantName,
            ),
          ),
          ListTile(
            leading: Icon(Icons.wb_sunny),
            title: Text("Modify Restaurant Open Hour"),
            trailing: Icon(Icons.edit),
            onTap: () => showPickerNumber(
              context,
              title: Text("Open Hour"),
              onConfirm: merchantData.setMerchantOpenHour,
            ),
          ),
          ListTile(
            leading: Icon(Icons.timelapse),
            title: Text("Modify Restaurant Close Hour"),
            trailing: Icon(Icons.edit),
            onTap: () => showPickerNumber(
              context,
              title: Text("Close Hour"),
              onConfirm: merchantData.setMerchantCloseHour,
            ),
          ),
          ListTile(
            leading: Icon(Icons.edit_location),
            title: Text("Modify Restaurant Address"),
            trailing: Icon(Icons.edit),
            onTap: () {
              Navigator.pushNamed(context, kMapSearchScreenRoute);
              Provider.of<MapSearchData>(context)
                  .setUserType(UserType.merchant);
              Provider.of<MapSearchData>(context).changeGoogleMapCamera(
                  cameraPosition: merchantData.getCameraPosition());
            },
          ),
          ListTile(
            leading: Icon(Icons.details),
            title: Text("Modify Restaurant Description"),
            trailing: Icon(Icons.edit),
            onTap: () => _modifyTextField(
              context: context,
              textController: descriptionController,
              hintText: "Description",
              onConfirm: merchantData.setMerchantDescription,
            ),
          ),
          ListTile(
            leading: Icon(Icons.do_not_disturb_alt),
            title: Text("Disable Restaurant Temporarily"),
            subtitle: Text(merchantData.isDayOff()
                ? "This restaurant is currently Disabled"
                : "This restaurant is currently Enabled"),
            trailing: Icon(Icons.edit),
            onTap: merchantData.toggleDayOff,
          ),
        ],
      ),
    );
  }

  Widget _addMerchantButtonSection(
      BuildContext context, MerchantData merchantData) {
    if (merchantData.isLoading) {
      return _sectionAlignment(
          child: Center(child: CircularProgressIndicator()));
    }
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: MaterialButton(
          padding: EdgeInsets.all(8.0),
          color: Colors.green,
          textColor: Colors.white,
          child: Text("Add Merchant"),
          onPressed: () async {
            //TODO
          },
        ),
      ),
    );
  }

  Widget _logoutSection(MerchantData merchantData) {
    if (merchantData.isLoading) {
      return _sectionAlignment(
          child: Center(child: CircularProgressIndicator()));
    }
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: MaterialButton(
          padding: EdgeInsets.all(8.0),
          color: Colors.red,
          textColor: Colors.white,
          child: Text("Sign Out"),
          onPressed: () => Navigator.pushNamedAndRemoveUntil(
              context, kLoginScreenRoute, (Route<dynamic> route) => false),
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
    return Consumer<MerchantData>(
      builder: (context, merchantData, child) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: CustomScrollView(
              slivers: <Widget>[
                _appBar(context, merchantData),
                _sectionTitle(merchantData.getMerchantTitle()),
                _statusSection(merchantData),
                _sectionTitle("Address"),
                _addressSection(merchantData),
                _sectionTitle("Description"),
                _descriptionSection(merchantData),
                _sectionTitle("Modify Options"),
                _modifyMerchantSection(merchantData),
                _logoutSection(merchantData),
              ],
            ),
          ),
        );
      },
    );
  }
}
