import 'package:flutter/material.dart';

class HeaderAppBarButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final Function onTap;
  final Key key;
  final Color color;

  HeaderAppBarButton({this.icon, this.text, this.onTap, this.key, this.color});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(),
      child: Container(
        padding: EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Container(
                alignment: Alignment.center,
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: this.color,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Icon(
                icon,
                size: 30.0,
                color: this.color ?? Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
