import 'package:flutter/material.dart';

class TitleAndSubtitleRowText extends StatelessWidget {
  final String title;
  final String description;
  final double fontSize;
  final Color titleColor;
  final Color descriptionColor;

  TitleAndSubtitleRowText(
      {@required this.title,
      @required this.description,
      @required this.fontSize,
      this.titleColor,
      this.descriptionColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            flex: 0,
            child: Text(
              this.title,
              style: TextStyle(
                color: this.titleColor ?? Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: this.fontSize,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              description,
              style: TextStyle(
                color: this.descriptionColor ?? Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: this.fontSize,
              ),
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.end,
            ),
          )
        ],
      ),
    );
  }
}
