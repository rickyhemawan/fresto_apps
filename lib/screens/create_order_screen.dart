import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fresto_apps/components/schedule_card.dart';
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
    // Todo Ordered Food List Card
    // Todo Return list of ordered food
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
      ],
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

  Widget _paymentDetailsSection() {
    return Card(
      margin: EdgeInsets.symmetric(
        horizontal: 8.0,
        vertical: 4.0,
      ),
      child: Column(
        children: <Widget>[
          _foodList(),
          DetailAndPriceText(
            description: "Product Total",
            price: 400000.0,
            fontSize: 16.0,
          ),
          DetailAndPriceText(
            description: "Product Tax",
            price: 40000.0,
            fontSize: 16.0,
          ),
          Divider(),
          DetailAndPriceText(
            description: "Grand Total",
            price: 440000.0,
            fontSize: 20,
            descriptionColor: Colors.blueGrey,
            priceColor: Colors.blue,
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

  @override
  Widget build(BuildContext context) {
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
            _confirmButtonSection(),
          ],
        ),
      ),
    );
  }
}

class DetailAndPriceText extends StatelessWidget {
  final String description;
  final double price;
  final double fontSize;
  final Color descriptionColor;
  final Color priceColor;

  DetailAndPriceText(
      {@required this.description,
      @required this.price,
      @required this.fontSize,
      this.descriptionColor,
      this.priceColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Text(
              this.description,
              style: TextStyle(
                color: this.descriptionColor ?? Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: this.fontSize,
              ),
            ),
          ),
          Expanded(
            flex: 0,
            child: Text(
              "Rp $price",
              style: TextStyle(
                color: this.priceColor ?? Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: this.fontSize,
              ),
            ),
          )
        ],
      ),
    );
  }
}
