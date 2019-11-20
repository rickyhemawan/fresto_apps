import 'package:flutter/material.dart';
import 'package:fresto_apps/components/overlapping_sliver_app_bar_delegate.dart';
import 'package:fresto_apps/components/text_and_image_progress_animation.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final double expandedHeight = 152;
  final double cardHeight = 240.0;
  final double cardWidth = 160.0;

  Widget _appBar(BuildContext context) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: OverlappingSliverAppBarDelegate(
        expandedHeight: expandedHeight,
        title: "Home",
        cardContent: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                flex: 0,
                child: Container(
                  padding: EdgeInsets.all(8.0),
                  color: Theme.of(context).primaryColor,
                  child: Text("Welcome to Fresto!",
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .title
                          .copyWith(color: Colors.white)),
                ),
              ),
              Expanded(
                flex: 1,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: HeaderAppBarButton(
                        icon: Icons.location_searching,
                        text: "Update Current Location",
                      ),
                    ),
                    VerticalDivider(
                      indent: 16.0,
                      endIndent: 16.0,
                    ),
                    Expanded(
                      flex: 1,
                      child: HeaderAppBarButton(
                        icon: Icons.history,
                        text: "Re-order Previous Order",
                      ),
                    ),
                    VerticalDivider(
                      indent: 16.0,
                      endIndent: 16.0,
                    ),
                    Expanded(
                      flex: 1,
                      child: HeaderAppBarButton(
                        icon: Icons.exit_to_app,
                        text: "Sign-out",
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _section1() {
    return SliverToBoxAdapter(
      child: Container(
        height: cardHeight,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 5,
          itemBuilder: (context, index) {
            return Container(
              width: cardWidth,
              child: Card(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Expanded(
                        flex: 0,
                        child: TextAndImageProgressAnimation(
                          height: 15.0,
                        ),
                      ),
                      Expanded(
                        flex: 0,
                        child: TextAndImageProgressAnimation(
                          height: 15.0,
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: TextAndImageProgressAnimation(),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _section2() {
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
                        TextAndImageProgressAnimation(height: 15.0),
                        TextAndImageProgressAnimation(
                          height: 15.0,
                          width: 72.0,
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
    return SafeArea(
      child: CustomScrollView(
        slivers: <Widget>[
          _appBar(context),
          SliverToBoxAdapter(
            child: SizedBox(
              height: expandedHeight / 3.2,
            ),
          ),
          _section1(),
          _section2(),
        ],
      ),
    );
  }
}

class HeaderAppBarButton extends StatelessWidget {
  final IconData icon;
  final String text;

  HeaderAppBarButton({this.icon, this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
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
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Icon(
              icon,
              size: 30.0,
              color: Colors.green,
            ),
          ),
        ],
      ),
    );
  }
}
