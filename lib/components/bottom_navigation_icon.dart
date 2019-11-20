import 'package:flutter/material.dart';

class BottomNavigationIcon extends StatelessWidget {
  final IconData iconData;
  BottomNavigationIcon(this.iconData);

  @override
  Widget build(BuildContext context) {
    return Icon(
      iconData,
      size: 30,
      color: Theme.of(context).primaryColorLight,
    );
  }
}
