import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class OverlappingSliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final double expandedHeight;
  final String title;
  final Widget cardContent;

  OverlappingSliverAppBarDelegate(
      {@required this.expandedHeight,
      @required this.title,
      @required this.cardContent});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Stack(
      fit: StackFit.expand,
      overflow: Overflow.visible,
      children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              colorFilter: new ColorFilter.mode(
                  Colors.black.withOpacity(0.4), BlendMode.colorBurn),
              image: CachedNetworkImageProvider(
                "https://s3.envato.com/files/261599624/571A2167.jpg",
              ),
            ),
          ),
          child: Opacity(
            opacity: shrinkOffset / expandedHeight,
            child: AppBar(
              title: Text(title),
            ),
          ),
        ),
        Positioned(
          top: expandedHeight / 2 - shrinkOffset - 42.0,
          left: MediaQuery.of(context).size.width / 16,
          right: MediaQuery.of(context).size.width / 16,
          child: Opacity(
            opacity: (1 - shrinkOffset / expandedHeight),
            child: Card(
              elevation: 10,
              clipBehavior: Clip.antiAlias,
              child: SizedBox(
                height: expandedHeight,
                child: cardContent,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent => kToolbarHeight;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}
