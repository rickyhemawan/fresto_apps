import 'package:flutter/material.dart';
import 'package:fresto_apps/components/text_and_image_progress_animation.dart';

class MerchantsScreen extends StatefulWidget {
  const MerchantsScreen({Key key}) : super(key: key);

  @override
  _MerchantsScreenState createState() => _MerchantsScreenState();
}

class _MerchantsScreenState extends State<MerchantsScreen> {
  Widget _appBar() {
    return SliverAppBar(
      title: Text("Merchants"),
      floating: true,
    );
  }

  Widget _section1() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, int) {
          return Card(
            child: Container(
              height: 240.0,
              padding: EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: TextAndImageProgressAnimation(),
                  ),
                  Expanded(
                    flex: 0,
                    child: TextAndImageProgressAnimation(
                      height: 15.0,
                      width: 120.0,
                    ),
                  ),
                  Expanded(
                    flex: 0,
                    child: TextAndImageProgressAnimation(
                      height: 15.0,
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
