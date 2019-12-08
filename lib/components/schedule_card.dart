import 'package:flutter/material.dart';

class InformationCard extends StatelessWidget {
  final String title;
  final String content;
  final Function onPressed;
  final Color color;
  final IconData icon;

  InformationCard(
      {this.title, this.content, this.onPressed, this.color, this.icon});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
        child: Container(
          width: double.infinity,
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.all(8.0),
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 0,
                child: Container(
                  padding: EdgeInsets.all(4.0),
                  child: Icon(
                    icon ?? Icons.date_range,
                    size: 36.0,
                    color: color,
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.symmetric(horizontal: 4.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        title,
                        style: TextStyle(
                          color: color,
                        ),
                      ),
                      Text(
                        content,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 0,
                child: Icon(
                  Icons.navigate_next,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
