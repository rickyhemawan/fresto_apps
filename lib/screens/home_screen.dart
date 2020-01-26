import 'package:flutter/material.dart';
import 'package:fresto_apps/components/food_card.dart';
import 'package:fresto_apps/components/header_app_bar_button.dart';
import 'package:fresto_apps/components/home_vertical_card.dart';
import 'package:fresto_apps/components/overlapping_sliver_app_bar_delegate.dart';
import 'package:fresto_apps/models_data/merchants_data.dart';
import 'package:fresto_apps/models_data/user_auth_data.dart';
import 'package:fresto_apps/utils/constants.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void _signOut() {
    Provider.of<UserAuthData>(context).signOutUser(context);
  }

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
                        key: Key("btnHomeSignOut"),
                        icon: Icons.exit_to_app,
                        text: "Sign-out",
                        onTap: _signOut,
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

  Widget _topSection() {
    return SliverToBoxAdapter(
      child: Container(
        height: cardHeight,
        child: Provider.of<MerchantsData>(context)
                .getMenusWithMerchantMap()
                .isNotEmpty
            ? ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 5,
                itemBuilder: (context, index) {
                  return HomeVerticalCard(
                    menu: Provider.of<MerchantsData>(context)
                        .getMenusWithMerchantMap()[index + 5]["Menu"],
                    merchant: Provider.of<MerchantsData>(context)
                        .getMenusWithMerchantMap()[index + 5]["Merchant"],
                  );
                },
              )
            : SizedBox(),
      ),
    );
  }

  Widget _bottomSection() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          return FoodCard(
              menu: Provider.of<MerchantsData>(context)
                  .getMenusWithMerchantMap()[index + 5]["Menu"],
              merchant: Provider.of<MerchantsData>(context)
                  .getMenusWithMerchantMap()[index + 5]["Merchant"]);
        },
        childCount: Provider.of<MerchantsData>(context)
                .getMenusWithMerchantMap()
                .length -
            5,
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
          _topSection(),
          _bottomSection(),
        ],
      ),
    );
  }
}
