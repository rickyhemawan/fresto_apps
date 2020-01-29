import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
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
  // Text Fields Controllers
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  Future _modifyImage() async {
    print("selecting img from gallery");
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    Provider.of<AdminModifyMerchantData>(context).setImageViaFile(file: image);
  }

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

  void _modifyTextField({
    @required BuildContext context,
    @required TextEditingController textController,
    @required String hintText,
    @required Function successCallback,
  }) {
    {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Change Restaurant $hintText"),
            content: TextField(
              controller: textController,
              decoration: InputDecoration(hintText: "Restaurant $hintText"),
            ),
            actions: <Widget>[
              FlatButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Cancel"),
              ),
              FlatButton(
                onPressed: () {
                  successCallback(textController.text);
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
                Provider.of<AdminModifyMerchantData>(context)
                    .getMerchantOperatingHour(),
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
                Provider.of<AdminModifyMerchantData>(context)
                    .getMerchantAddress(),
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
          Provider.of<AdminModifyMerchantData>(context)
              .getMerchantDescription(),
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
              onTap: () => _modifyTextField(
                context: context,
                textController: titleController,
                hintText: "Name",
                successCallback: (name) =>
                    Provider.of<AdminModifyMerchantData>(context)
                        .setMerchantName(name: name),
              ),
            ),
            ListTile(
              leading: Icon(Icons.wb_sunny),
              title: Text("Modify Restaurant Open Hour"),
              trailing: Icon(Icons.edit),
              onTap: () => showPickerNumber(
                context,
                title: Text("Open Hour"),
                onConfirm: (int value) =>
                    Provider.of<AdminModifyMerchantData>(context)
                        .setMerchantOpenHour(value),
              ),
            ),
            ListTile(
              leading: Icon(Icons.timelapse),
              title: Text("Modify Restaurant Close Hour"),
              trailing: Icon(Icons.edit),
              onTap: () => showPickerNumber(
                context,
                title: Text("Close Hour"),
                onConfirm: (int value) =>
                    Provider.of<AdminModifyMerchantData>(context)
                        .setMerchantCloseHour(value),
              ),
            ),
            ListTile(
              leading: Icon(Icons.edit_location),
              title: Text("Modify Restaurant Address"),
              trailing: Icon(Icons.edit),
              onTap: () => Navigator.pushNamed(context, kMapSearchScreenRoute),
            ),
            ListTile(
              leading: Icon(Icons.details),
              title: Text("Modify Restaurant Description"),
              trailing: Icon(Icons.edit),
              onTap: () => _modifyTextField(
                context: context,
                textController: descriptionController,
                hintText: "Description",
                successCallback: (description) =>
                    Provider.of<AdminModifyMerchantData>(context)
                        .setMerchantDescription(description: description),
              ),
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
                _sectionTitle(Provider.of<AdminModifyMerchantData>(context)
                    .getMerchantTitle()),
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
}
