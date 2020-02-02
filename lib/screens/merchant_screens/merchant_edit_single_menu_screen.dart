import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fresto_apps/components/food_card.dart';
import 'package:fresto_apps/components/modify_text_field.dart';
import 'package:fresto_apps/models_data/merchant_data/merchant_data.dart';
import 'package:fresto_apps/models_data/merchant_data/merchant_modify_menu_data.dart';
import 'package:provider/provider.dart';

class MerchantEditSingleMenuScreen extends StatefulWidget {
  @override
  _MerchantEditSingleMenuScreenState createState() =>
      _MerchantEditSingleMenuScreenState();
}

class _MerchantEditSingleMenuScreenState
    extends State<MerchantEditSingleMenuScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController detailsController = TextEditingController();

  Widget _appBar(BuildContext context) {
    return SliverAppBar(
      title: Text("Edit Menu"),
      floating: true,
    );
  }

  Widget _menuDetails(MerchantModifyMenuData menuData) {
    return SliverToBoxAdapter(
      child: FoodCardBig(
        foodImage: menuData.getMenuImage(),
        foodPrice: menuData.getMenuPrice(),
        foodDescription: menuData.getMenuDescription(),
        foodName: menuData.getMenuName(),
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
          color: menuData.isSameAsPrevious() ? Colors.grey : Colors.green,
          textColor: Colors.white,
          child: Text("Update Menu"),
          onPressed: () async {
            menuData.setLoading(true);
            menuData
                .printDifference(Provider.of<MerchantData>(context).merchant);
            String msg = await menuData
                .updateMenu(Provider.of<MerchantData>(context).merchant);
            if (msg != null) {
              Fluttertoast.showToast(msg: msg);
              menuData.setLoading(false);
              return;
            }
            Provider.of<MerchantData>(context).loadCurrentMerchantData();
            menuData.setLoading(false);
            Fluttertoast.showToast(msg: "Menu updated successfully");
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
                _sectionTitle("Menu Details"),
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
