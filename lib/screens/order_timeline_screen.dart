import 'package:flutter/material.dart';
import 'package:fresto_apps/components/text_and_image_progress_animation.dart';

class OrderTimelineScreen extends StatefulWidget {
  const OrderTimelineScreen({Key key}) : super(key: key);

  @override
  _OrderTimelineScreenState createState() => _OrderTimelineScreenState();
}

class _OrderTimelineScreenState extends State<OrderTimelineScreen> {
  Widget _appBar() {
    return SliverAppBar(
      title: Text("Orders"),
      floating: true,
    );
  }

  Widget _section1() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, int) {
          return Card(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    flex: 0,
                    child: TextAndImageProgressAnimation(
                      height: 72.0,
                      width: 72.0,
                    ),
                  ),
                  Expanded(
                    flex: 0,
                    child: SizedBox(
                      width: 8.0,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        TextAndImageProgressAnimation(
                          height: 15.0,
                          width: 80.0,
                        ),
                        TextAndImageProgressAnimation(
                          height: 15.0,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        childCount: 8,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        _appBar(),
        _section1(),
      ],
    );
  }
}
