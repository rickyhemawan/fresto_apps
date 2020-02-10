import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fresto_apps/components/food_card.dart';
import 'package:fresto_apps/components/schedule_card.dart';
import 'package:fresto_apps/components/title_and_subtitle_row_text.dart';
import 'package:fresto_apps/models_data/client_data/client_merchant_data.dart';
import 'package:fresto_apps/models_data/client_data/client_order_data.dart';
import 'package:fresto_apps/utils/constants.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:provider/provider.dart';

class CreateOrderScreen extends StatefulWidget {
  static const route = '/detailed_order_page';

  @override
  _CreateOrderScreenState createState() => _CreateOrderScreenState();
}

class _CreateOrderScreenState extends State<CreateOrderScreen> {
  final _payHalf = "Pay Half";
  final _payFull = "Pay Full";

  String _picked = "Pay Half";

  Widget _foodList(ClientOrderData orderData) {
    return InkWell(
      onTap: () {
        Provider.of<ClientMerchantData>(context)
            .setMerchant(merchant: orderData.merchant);
        Navigator.pushNamed(context, kMerchantDetailScreenRoute);
      },
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(8.0),
            width: double.infinity,
            child: Text(
              'Product Details',
              textAlign: TextAlign.start,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
          ),
          ListView.builder(
            itemBuilder: (context, index) {
              return FoodCardWithQuantity(
                menuHelper: orderData.order.menus[index],
              );
            },
            itemCount: orderData.order.menus.length,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
          )
        ],
      ),
    );
  }

  Widget _timeSection(ClientOrderData orderData) {
    return InformationCard(
      color: Colors.blue,
      title: 'Reservation Date',
      content: orderData.getReservationDate(),
      onPressed: () async {
        DateTime x;
        await DatePicker.showDateTimePicker(context,
            minTime: orderData.minimumDate,
            maxTime: orderData.maximumDate,
            onConfirm: (time) => x = time);
        print(x);
      },
    );
  }

  Widget _merchantDetailsSection(ClientOrderData orderData) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(8.0),
            width: double.infinity,
            child: Text(
              'Merchant Details',
              textAlign: TextAlign.start,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
          ),
          ListTile(
            onTap: () {
              Provider.of<ClientMerchantData>(context)
                  .setMerchant(merchant: orderData.merchant);
              Navigator.pushNamed(context, kMerchantDetailScreenRoute);
            },
            leading: CachedNetworkImage(
              imageUrl: orderData.merchant.imageUrl,
              fit: BoxFit.fill,
            ),
            title: Text(orderData.merchant.merchantName),
            subtitle: Text(
              orderData.merchant.description ?? "No Description",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            isThreeLine: true,
          ),
          ListTile(
            title: Text(
              "Address",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(orderData.merchant.locationName),
            trailing: Icon(
              Icons.location_on,
              color: Colors.orange,
            ),
          ),
          SizedBox(height: 8.0),
        ],
      ),
    );
  }

  Widget _paymentDetailsSection(ClientOrderData orderData) {
    return Card(
      margin: EdgeInsets.symmetric(
        horizontal: 8.0,
        vertical: 4.0,
      ),
      child: Column(
        children: <Widget>[
          _foodList(orderData),
          TitleAndSubtitleRowText(
            title: "Product Total",
            description: orderData.getProductTotal(),
            fontSize: 16.0,
          ),
          TitleAndSubtitleRowText(
            title: "Product Tax",
            description: orderData.getTax(),
            fontSize: 16.0,
          ),
          Divider(),
          TitleAndSubtitleRowText(
            title: "Grand Total",
            description: orderData.getGrandTotal(),
            fontSize: 20,
            titleColor: Colors.blueGrey,
            descriptionColor: Colors.blue,
          ),
        ],
      ),
    );
  }

  Widget _downPaymentSection() {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 8.0, left: 8.0, bottom: 4.0),
            child: Text(
              "Down Payment",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          RadioButtonGroup(
            labels: <String>[
              _payHalf,
              _payFull,
            ],
            picked: _picked,
            onSelected: (String selected) => setState(() => _picked = selected),
            activeColor: Colors.green,
            labelStyle: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _confirmButtonSection() {
    return Container(
      color: Colors.green,
      padding: EdgeInsets.all(8.0),
      margin: EdgeInsets.symmetric(
        vertical: 4.0,
        horizontal: 8.0,
      ),
      width: double.infinity,
      alignment: Alignment.center,
      child: InkWell(
          onTap: () {
            Fluttertoast.showToast(msg: "Order Pressed");
            Navigator.pop(context);
          },
          child: Text(
            "Reserve",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
            ),
          )),
    );
  }

  Widget _cancelButtonSection(ClientOrderData orderData) {
    return Container(
      color: Colors.red,
      padding: EdgeInsets.all(8.0),
      margin: EdgeInsets.symmetric(
        vertical: 4.0,
        horizontal: 8.0,
      ),
      width: double.infinity,
      alignment: Alignment.center,
      child: InkWell(
          onTap: () {
            orderData.clearMerchant();
            Fluttertoast.showToast(msg: "Order Canceled");
            Navigator.pop(context);
          },
          child: Text(
            "Cancel",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
            ),
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ClientOrderData>(
      builder: (context, orderData, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Create Reservation'),
          ),
          body: Container(
            child: ListView(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              children: <Widget>[
                _timeSection(orderData),
                _merchantDetailsSection(orderData),
                _paymentDetailsSection(orderData),
                _downPaymentSection(),
                _confirmButtonSection(),
                _cancelButtonSection(orderData),
              ],
            ),
          ),
        );
      },
    );
  }
}
