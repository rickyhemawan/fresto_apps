import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fresto_apps/components/round_icon_button.dart';
import 'package:fresto_apps/components/text_and_image_progress_animation.dart';
import 'package:fresto_apps/models/helper/menu_helper.dart';
import 'package:fresto_apps/models/menu.dart';
import 'package:fresto_apps/models/merchant.dart';
import 'package:fresto_apps/models_data/client_data/client_merchant_data.dart';
import 'package:fresto_apps/models_data/merchant_data/merchant_modify_menu_data.dart';
import 'package:fresto_apps/utils/constants.dart';
import 'package:provider/provider.dart';

class LoadingFoodCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
              flex: 0,
              child: TextAndImageProgressAnimation(
                height: 72.0,
                width: 72.0,
              ),
            ),
            Expanded(
              flex: 0,
              child: SizedBox(
                width: 8.0,
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextAndImageProgressAnimation(height: 15.0),
                  TextAndImageProgressAnimation(
                    height: 15.0,
                    width: 72.0,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FoodCard extends StatelessWidget {
  final Menu menu;
  final Merchant merchant;
  FoodCard({this.menu, this.merchant});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Provider.of<ClientMerchantData>(context)
            .setMerchant(merchant: this.merchant);
        Navigator.pushNamed(context, kMerchantDetailScreenRoute);
      },
      child: Card(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 0,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(3.0),
                  child: CachedNetworkImage(
                    imageUrl: menu.imageUrl ?? kDummyFoodImage,
                    height: 72.0,
                    width: 72.0,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Expanded(
                flex: 0,
                child: SizedBox(
                  width: 8.0,
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      menu.name ?? kDummyFoodName,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.justify,
                    ),
                    SizedBox(height: 4.0),
                    Text(
                      merchant.merchantName ?? kDummyMerchantName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.justify,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FoodCardWithQuantity extends StatelessWidget {
  final MenuHelper menuHelper;

  FoodCardWithQuantity({@required this.menuHelper});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: Column(
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 0,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(3.0),
                  child: CachedNetworkImage(
                    imageUrl: this.menuHelper.imageUrl ?? kDummyDefaultImage,
                    height: 72.0,
                    width: 72.0,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Expanded(
                flex: 0,
                child: SizedBox(
                  width: 8.0,
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      this.menuHelper.name ?? "No Name",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      this.menuHelper.price.toString() ?? "No Price",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                    Container(
                      width: double.infinity,
                      child: Text(
                        "Quantity : ${this.menuHelper.quantity}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 4.0),
          Divider(height: 12.0),
        ],
      ),
    );
  }
}

class FoodCardWithOrder extends StatelessWidget {
  final Menu menu;
  final int quantity;
  final Function onAdd;
  final Function onMinus;
  FoodCardWithOrder({this.menu, this.quantity, this.onAdd, this.onMinus});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(3.0),
              child: Container(
                width: double.infinity,
                child: CachedNetworkImage(
                  height: 180.0,
                  imageUrl: menu.imageUrl ?? kDummyDefaultImage,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    menu.name ?? "No Name",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    menu.price.toString() ?? "No Price",
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    menu.description ?? "No Description",
                    textAlign: TextAlign.justify,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      RoundIconButton(
                        icon: Icons.chevron_left,
                        onPressed: this.onMinus,
                      ),
                      Text(
                        "${this.quantity}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      RoundIconButton(
                        icon: Icons.chevron_right,
                        onPressed: this.onAdd,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FoodCardBig extends StatelessWidget {
  final String foodImageUrl;
  final Widget foodImage;
  final String foodName;
  final String foodPrice;
  final String foodDescription;

  FoodCardBig(
      {this.foodImageUrl,
      this.foodName,
      this.foodPrice,
      this.foodDescription,
      this.foodImage});

  Widget getImage() {
    if (foodImage != null) {
      return foodImage;
    }
    return CachedNetworkImage(
      height: 180.0,
      width: double.infinity,
      imageUrl: foodImageUrl ?? kDummyFoodImage,
      fit: BoxFit.cover,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: Card(
        child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(3.0),
                child: getImage(),
              ),
              Container(
                padding: EdgeInsets.all(8.0),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      foodName ?? kDummyFoodName,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      foodPrice ?? kDummyFoodPrice,
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      foodDescription ?? kDummyDescription,
                      textAlign: TextAlign.justify,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FoodCardWithEdit extends StatelessWidget {
  final Menu menu;
  final BuildContext context;
  FoodCardWithEdit({@required this.context, @required this.menu});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(3.0),
              child: CachedNetworkImage(
                height: 180.0,
                imageUrl: menu.imageUrl ?? kDummyDefaultImage,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    menu.name ?? "No Name",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    menu.price.toString() ?? "No Price",
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    menu.description ?? "No Description",
                    textAlign: TextAlign.justify,
                  ),
                  Container(
                    width: double.infinity,
                    alignment: Alignment.centerRight,
                    child: MaterialButton(
                      onPressed: () {
                        Navigator.pushNamed(
                            context, kMerchantEditSingleMenuScreenRoute);
                        Provider.of<MerchantModifyMenuData>(context)
                            .selectMenu(this.menu);
                      },
                      child: Text("Edit"),
                      color: Colors.green,
                      textColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
