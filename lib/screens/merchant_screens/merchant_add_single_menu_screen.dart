import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fresto_apps/components/food_card.dart';
import 'package:fresto_apps/components/modify_text_field.dart';
import 'package:fresto_apps/models_data/merchant_data/merchant_data.dart';
import 'package:fresto_apps/models_data/merchant_data/merchant_modify_menu_data.dart';
import 'package:provider/provider.dart';

class MerchantAddSingleMenuScreen extends StatefulWidget {
  @override
  _MerchantAddSingleMenuScreenState createState() =>
      _MerchantAddSingleMenuScreenState();
}

class _MerchantAddSingleMenuScreenState
    extends State<MerchantAddSingleMenuScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController detailsController = TextEditingController();

  Widget _appBar(BuildContext context) {
    return SliverAppBar(
      title: Text("Add New Menu"),
      floating: true,
    );
  }

  Widget _menuDetails(MerchantModifyMenuData menuData) {
    return SliverToBoxAdapter(
      child: FoodCardBig(
        foodImage: menuData.getMenuImage(),
        foodName: menuData.getMenuName(),
        foodDescription: menuData.getMenuDescription(),
        foodPrice: menuData.getMenuPrice(),
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

  Widget _saveChangesSection(MerchantModifyMenuData menuData) {
    if (menuData.isLoading) {
      return SliverToBoxAdapter(
        child: Container(
          width: double.infinity,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: MaterialButton(
          padding: EdgeInsets.all(8.0),
          color: Colors.green,
          textColor: Colors.white,
          child: Text("Add Menu"),
          onPressed: () async {
            menuData.setLoading(true);
            print(
                "add menu callback says => ${Provider.of<MerchantData>(context).merchant}");
            String msg = await menuData
                .addMenu(Provider.of<MerchantData>(context).merchant);
            if (msg != null) {
              Fluttertoast.showToast(msg: msg);
              menuData.setLoading(false);
              return;
            }
            Provider.of<MerchantData>(context).loadCurrentMerchantData();
            menuData.setLoading(false);
            Fluttertoast.showToast(msg: "Menu added successfully");
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  Widget _modifyMenuSection(
      BuildContext context, MerchantModifyMenuData menuData) {
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
              onTap: () async => await menuData.selectImageFromGallery(context),
            ),
            ListTile(
              leading: Icon(Icons.title),
              title: Text("Modify Menu Name"),
              trailing: Icon(Icons.edit),
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return ModifyTextField(
                        hintText: "Menu Name",
                        context: context,
                        textController: nameController,
                        onConfirm: menuData.setMenuName,
                      );
                    });
              },
            ),
            ListTile(
                leading: Icon(Icons.attach_money),
                title: Text("Modify Menu Price"),
                trailing: Icon(Icons.edit),
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return ModifyTextField(
                          hintText: "Menu Price",
                          keyboardType: TextInputType.number,
                          context: context,
                          textController: priceController,
                          onConfirm: menuData.setMenuPrice,
                        );
                      });
                }),
            ListTile(
              leading: Icon(Icons.details),
              title: Text("Modify Restaurant Details"),
              trailing: Icon(Icons.edit),
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return ModifyTextField(
                        hintText: "Menu Details",
                        context: context,
                        textController: detailsController,
                        onConfirm: menuData.setMenuDescription,
                      );
                    });
              },
            ),
            ListTile(
              leading: Icon(Icons.do_not_disturb_alt),
              title: Text("Toggle Menu Availability"),
              subtitle: Text(
                menuData.getMenuAvailability()
                    ? "This Menu is Enabled"
                    : "This menu is Disabled",
              ),
              trailing: Icon(Icons.edit),
              onTap: menuData.toggleAvailability,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MerchantModifyMenuData>(
      builder: (context, menuData, child) {
        return Scaffold(
          body: SafeArea(
            child: CustomScrollView(
              slivers: <Widget>[
                _appBar(context),
                _sectionTitle("Menu Preview"),
                _menuDetails(menuData),
                _sectionTitle("Modify Menu"),
                _modifyMenuSection(context, menuData),
                _saveChangesSection(menuData),
              ],
            ),
          ),
        );
      },
    );
  }
}
