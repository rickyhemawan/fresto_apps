import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fresto_apps/components/food_card.dart';
import 'package:fresto_apps/components/schedule_card.dart';
import 'package:fresto_apps/components/title_and_subtitle_row_text.dart';
import 'package:fresto_apps/utils/constants.dart';
import 'package:grouped_buttons/grouped_buttons.dart';

class MerchantOrderDetailsScreen extends StatelessWidget {
  final OrderDay orderDay;
  MerchantOrderDetailsScreen({this.orderDay = OrderDay.today});

  final _payHalf = "Pay Half";
  final _payFull = "Pay Full";
  final _picked = "Pay Half";

  Widget _foodList() {
    return Column(
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

  Widget _customerInfoSection() {
    return Card(
      margin: EdgeInsets.symmetric(
        horizontal: 8.0,
        vertical: 4.0,
      ),
      child: Column(
        children: <Widget>[
          Text(
            'Customer Information',
            textAlign: TextAlign.start,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
            ),
          ),
          TitleAndSubtitleRowText(
            title: "Name",
            description: "John Doe",
            fontSize: 16.0,
          ),
          TitleAndSubtitleRowText(
            title: "Email Address",
            description: "Johndoe@email.com",
            fontSize: 16.0,
          ),
          TitleAndSubtitleRowText(
            title: "Phone Number",
            description: "+62812345678901",
            fontSize: 16.0,
          ),
        ],
      ),
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

  Widget _confirmButtonSection(BuildContext context, bool enableTracking) {
    Function _trackingEnabled = () {
      Navigator.pushNamed(context, kMerchantTrackClientScreenRoute);
    };

    Function _trackingDisabled = () {
      Fluttertoast.showToast(msg: "Can't show user location now");
    };

    return Container(
      color: enableTracking ? Colors.green : Colors.grey,
      padding: EdgeInsets.all(8.0),
      margin: EdgeInsets.symmetric(
        vertical: 4.0,
        horizontal: 8.0,
      ),
      width: double.infinity,
      alignment: Alignment.center,
      child: InkWell(
          onTap: enableTracking ? _trackingEnabled : _trackingDisabled,
          child: Text(
            "Show User Location",
            style: TextStyle(
              color: enableTracking ? Colors.white : Colors.grey[700],
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
            ),
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool enableTracking = this.orderDay == OrderDay.today;
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Detail'),
      ),
      body: Container(
        child: ListView(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          children: <Widget>[
            _timeSection(),
            _paymentMethodSection(),
            _paymentDetailsSection(),
            _downPaymentSection(),
            _customerInfoSection(),
            _confirmButtonSection(context, enableTracking),
          ],
        ),
      ),
    );
  }
}
