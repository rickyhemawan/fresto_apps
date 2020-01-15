import 'package:flutter/material.dart';
import 'package:fresto_apps/models_data/user_auth_data.dart';
import 'package:fresto_apps/screens/admin_screens/admin_add_merchant_screen.dart';
import 'package:fresto_apps/screens/admin_screens/admin_main_screen.dart';
import 'package:fresto_apps/screens/admin_screens/admin_show_merchants_screen.dart';
import 'package:fresto_apps/screens/create_order_screen.dart';
import 'package:fresto_apps/screens/login_screen.dart';
import 'package:fresto_apps/screens/main_screen.dart';
import 'package:fresto_apps/screens/merchant_detail_screen.dart';
import 'package:fresto_apps/screens/merchant_screens/merchant_add_single_menu_screen.dart';
import 'package:fresto_apps/screens/merchant_screens/merchant_edit_single_menu_screen.dart';
import 'package:fresto_apps/screens/merchant_screens/merchant_main_screen.dart';
import 'package:fresto_apps/screens/merchant_screens/merchant_order_details_screen.dart';
import 'package:fresto_apps/screens/merchant_screens/merchant_track_client_screen.dart';
import 'package:fresto_apps/screens/order_screen.dart';
import 'package:fresto_apps/screens/splash_screen.dart';
import 'package:provider/provider.dart';

import 'utils/constants.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(builder: (context) => UserAuthData()),
      ],
      child: MaterialApp(
        title: 'Fresto',
        theme: ThemeData(
          primarySwatch: Colors.green,
          accentColor: Colors.black,
        ),
        initialRoute: kSplashScreenRoute,
        routes: {
          // Client
          kMainScreenRoute: (context) => MainScreen(),
          kMerchantDetailScreenRoute: (context) => MerchantDetailScreen(),
          kCreateOrderScreenRoute: (context) => CreateOrderScreen(),
          kLoginScreenRoute: (context) => LoginScreen(),
          kSplashScreenRoute: (context) => SplashScreen(),
          kOrderScreenRoute: (context) => OrderScreen(),
          // Merchant
          kMerchantMainScreenRoute: (context) => MerchantMainScreen(),
          kMerchantOrderDetailsScreenRoute: (context) =>
              MerchantOrderDetailsScreen(),
          kMerchantAddSingleMenuScreenRoute: (context) =>
              MerchantAddSingleMenuScreen(),
          kMerchantEditSingleMenuScreenRoute: (context) =>
              MerchantEditSingleMenuScreen(),
          kMerchantTrackClientScreenRoute: (context) =>
              MerchantTrackClientScreen(),
          //Admin
          kAdminMainScreenRoute: (context) => AdminMainScreen(),
          kAdminAddMerchantScreenRoute: (context) => AdminAddMerchantScreen(),
          kAdminShowMerchantsScreenRoute: (context) =>
              AdminShowMerchantsScreen(),
        },
      ),
    );
  }
}
