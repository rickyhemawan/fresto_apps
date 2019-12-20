import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fresto_apps/components/food_card.dart';
import 'package:fresto_apps/components/schedule_card.dart';
import 'package:fresto_apps/components/title_and_subtitle_row_text.dart';
import 'package:fresto_apps/utils/constants.dart';
import 'package:grouped_buttons/grouped_buttons.dart';

class CreateOrderScreen extends StatefulWidget {
  static const route = '/detailed_order_page';

  @override
  _CreateOrderScreenState createState() => _CreateOrderScreenState();
}

class _CreateOrderScreenState extends State<CreateOrderScreen> {
  final _payHalf = "Pay Half";
  final _payFull = "Pay Full";

  String _picked = "Pay Half";

  Widget _foodList() {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, kMerchantDetailScreenRoute),
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
              return FoodCardWithQuantity();
            },
            itemCount: 1,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
          )
        ],
      ),
    );
  }

  Widget _timeSection() {
    return InformationCard(
      color: Colors.blue,
      title: 'Pick Up Time',
      content: '31 December 2019 at 7:00 PM',
      onPressed: () {
        Fluttertoast.showToast(msg: 'Cannot Change Date Once being ordered');
      },
    );
  }

  Widget _merchantDetailsSection() {
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
            onTap: () =>
                Navigator.pushNamed(context, kMerchantDetailScreenRoute),
            leading: CachedNetworkImage(
              imageUrl: kDummyMerchantImage,
              fit: BoxFit.fill,
            ),
            title: Text(kDummyMerchantName),
            subtitle: Text(
              kDummyDescription,
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
            subtitle: Text(kDummyMerchantAddress),
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

  Widget _paymentDetailsSection() {
    return Card(
      margin: EdgeInsets.symmetric(
        horizontal: 8.0,
        vertical: 4.0,
      ),
      child: Column(
        children: <Widget>[
          _foodList(),
          TitleAndSubtitleRowText(
            title: "Product Total",
            description: "Rp 400000.0",
            fontSize: 16.0,
          ),
          TitleAndSubtitleRowText(
            title: "Product Tax",
            description: "Rp 40000.0",
            fontSize: 16.0,
          ),
          Divider(),
          TitleAndSubtitleRowText(
            title: "Grand Total",
            description: "Rp 440000.0",
            fontSize: 20,
            titleColor: Colors.blueGrey,
            descriptionColor: Colors.blue,
          ),
        ],
      ),
    );
  }

  Widget _paymentMethodSection() {
    return InformationCard(
      icon: Icons.attach_money,
      color: Colors.green,
      title: 'Payment Method',
      content: 'OVO',
      onPressed: () {
        Fluttertoast.showToast(msg: 'Cannot Change Date Once being ordered');
      },
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
            padding: EdgeInsets.only(top: 8.0, left: 24.0, bottom: 4.0),
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

  Widget _cancelButtonSection() {
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
            Fluttertoast.showToast(msg: "Order Pressed");
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Reservation'),
      ),
      body: Container(
        child: ListView(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          children: <Widget>[
            _timeSection(),
            _paymentMethodSection(),
            _merchantDetailsSection(),
            _paymentDetailsSection(),
            _downPaymentSection(),
            _confirmButtonSection(),
            _cancelButtonSection(),
          ],
        ),
      ),
    );
  }
}
