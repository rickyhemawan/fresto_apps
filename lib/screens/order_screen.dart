import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fresto_apps/components/food_card.dart';
import 'package:fresto_apps/components/schedule_card.dart';
import 'package:fresto_apps/components/title_and_subtitle_row_text.dart';
import 'package:fresto_apps/utils/constants.dart';
import 'package:grouped_buttons/grouped_buttons.dart';

class OrderScreen extends StatelessWidget {
  final _payHalf = "Pay Half";
  final _payFull = "Pay Full";
  final _picked = "Pay Half";

  Widget _foodList() {
    return ListView.builder(
      itemBuilder: (context, index) {
        return FoodCardWithQuantity();
      },
      itemCount: 1,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
    );
  }

  Widget _timeSection() {
    return InformationCard(
      color: Colors.blue,
      title: 'Reservation Date',
      content: '31 December 2019 at 7:00 PM',
      showViewIcon: false,
      onPressed: () {
        Fluttertoast.showToast(msg: 'Cannot Change Date Once being ordered');
      },
    );
  }

  Widget _merchantDetailsSection(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          onTap: () => Navigator.pushNamed(context, kMerchantDetailScreenRoute),
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
      ],
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
      showViewIcon: false,
      onPressed: () {
        Fluttertoast.showToast(msg: 'Cannot Change Date Once being ordered');
      },
    );
  }

  Widget _downPaymentSection() {
    final List<String> _downPaymentList = [
      _payHalf,
      _payFull,
    ];
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
            labels: _downPaymentList,
            picked: _picked,
            disabled: _downPaymentList,
            activeColor: Colors.green,
            labelStyle: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _confirmButtonSection(context) {
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
          onTap: () => Navigator.pop(context),
          child: Text(
            "Cancel Reservation",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
            ),
          )),
    );
  }

  Widget _sectionTitle(BuildContext context, String title,
      {EdgeInsetsGeometry margin}) {
    return Container(
      margin: margin ?? EdgeInsets.fromLTRB(16.0, 16.0, 8.0, 4.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.title,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reservation Details'),
      ),
      body: Container(
        child: ListView(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          children: <Widget>[
            _timeSection(),
            _paymentMethodSection(),
            _sectionTitle(context, "Restaurant Details"),
            _merchantDetailsSection(context),
            _sectionTitle(context, "Product Details"),
            _paymentDetailsSection(),
            _downPaymentSection(),
            _confirmButtonSection(context),
          ],
        ),
      ),
    );
  }
}
