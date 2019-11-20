import 'package:flutter/material.dart';
import 'package:skeleton_text/skeleton_text.dart';

class TextAndImageProgressAnimation extends StatelessWidget {
  final double height;
  final double width;

  TextAndImageProgressAnimation({this.height, this.width});

  @override
  Widget build(BuildContext context) {
    return SkeletonAnimation(
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4.0),
        height: height,
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.grey[300],
        ),
      ),
    );
  }
}
