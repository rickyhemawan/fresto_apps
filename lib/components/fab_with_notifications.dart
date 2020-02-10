import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fresto_apps/models_data/client_data/client_order_data.dart';
import 'package:fresto_apps/utils/constants.dart';
import 'package:provider/provider.dart';

class FABWithNotifications extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Fluttertoast.showToast(
          msg: "FAB Pressed!",
          gravity: ToastGravity.CENTER,
        );
        Navigator.pushNamed(context, kCreateOrderScreenRoute);
      },
      child: Stack(
        children: <Widget>[
          Icon(Icons.shopping_basket),
          Positioned(
            right: 0,
            child: Container(
              padding: EdgeInsets.all(1),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(6),
              ),
              constraints: BoxConstraints(
                minWidth: 12,
                minHeight: 12,
              ),
              child: Text(
                '${Provider.of<ClientOrderData>(context).getTotalItems()}',
                style: new TextStyle(
                  color: Colors.white,
                  fontSize: 8,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          )
        ],
      ),
    );
  }
}
