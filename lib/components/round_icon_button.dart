import 'package:flutter/material.dart';

class RoundIconButton extends StatelessWidget {
  final IconData icon;
  final Function onPressed;

  RoundIconButton({@required this.icon, @required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      child: Icon(
        icon,
        color: Colors.white,
      ),
      onPressed: () {
        onPressed();
      },
      elevation: 0.0,
      constraints: BoxConstraints.tightFor(
        width: 32.0,
        height: 32.0,
      ),
      shape: CircleBorder(),
      fillColor: Colors.green,
    );
  }
}
