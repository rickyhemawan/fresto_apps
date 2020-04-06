import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fresto_apps/models_data/admin_data/admin_modify_merchant_data.dart';
import 'package:fresto_apps/models_data/client_data/client_create_order_data.dart';
import 'package:fresto_apps/models_data/client_data/client_data.dart';
import 'package:fresto_apps/models_data/client_data/client_merchant_data.dart';
import 'package:fresto_apps/models_data/client_data/client_order_timeline_data.dart';
import 'package:fresto_apps/models_data/maps_data/map_search_data.dart';
import 'package:fresto_apps/models_data/maps_data/map_track_data.dart';
import 'package:fresto_apps/models_data/merchant_data/merchant_data.dart';
import 'package:fresto_apps/models_data/merchant_data/merchant_modify_menu_data.dart';
import 'package:fresto_apps/models_data/merchant_data/merchant_order_timeline_data.dart';
import 'package:fresto_apps/models_data/merchants_data.dart';
import 'package:fresto_apps/models_data/update_order_data.dart';
import 'package:fresto_apps/models_data/user_auth_data.dart';
import 'package:fresto_apps/screens/admin_screens/admin_add_merchant_screen.dart';
import 'package:fresto_apps/screens/admin_screens/admin_main_screen.dart';
import 'package:fresto_apps/screens/admin_screens/admin_modify_merchant_screen.dart';
import 'package:fresto_apps/screens/admin_screens/admin_show_merchants_screen.dart';
import 'package:fresto_apps/screens/create_order_screen.dart';
import 'package:fresto_apps/screens/login_screen.dart';
import 'package:fresto_apps/screens/main_screen.dart';
import 'package:fresto_apps/screens/maps_screens/map_search_screen.dart';
import 'package:fresto_apps/screens/maps_screens/map_track_screen.dart';
import 'package:fresto_apps/screens/merchant_detail_screen.dart';
import 'package:fresto_apps/screens/merchant_screens/merchant_add_single_menu_screen.dart';
import 'package:fresto_apps/screens/merchant_screens/merchant_edit_single_menu_screen.dart';
import 'package:fresto_apps/screens/merchant_screens/merchant_main_screen.dart';
import 'package:fresto_apps/screens/merchant_screens/merchant_track_client_screen.dart';
import 'package:fresto_apps/screens/order_screen.dart';
import 'package:fresto_apps/screens/splash_screen.dart';
import 'package:provider/provider.dart';

import 'utils/constants.dart';

void main() async {
  await DotEnv().load('.env');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(builder: (context) => UserAuthData()),
        ChangeNotifierProvider(builder: (context) => AdminModifyMerchantData()),
        ChangeNotifierProvider(builder: (context) => ClientData()),
        ChangeNotifierProvider(builder: (context) => ClientMerchantData()),
        ChangeNotifierProvider(builder: (context) => ClientCreateOrderData()),
        ChangeNotifierProvider(builder: (context) => ClientOrderTimelineData()),
        ChangeNotifierProvider(builder: (context) => MerchantsData()),
        ChangeNotifierProvider(builder: (context) => MapSearchData()),
        ChangeNotifierProvider(builder: (context) => MapTrackData()),
        ChangeNotifierProvider(builder: (context) => MerchantData()),
        ChangeNotifierProvider(builder: (context) => MerchantModifyMenuData()),
        ChangeNotifierProvider(
            builder: (context) => MerchantOrderTimelineData()),
        ChangeNotifierProvider(builder: (context) => UpdateOrderData()),
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
          kAdminModifyMerchantScreenRoute: (context) =>
              AdminModifyMerchantScreen(),
          //Maps
          kMapSearchScreenRoute: (context) => MapSearchScreen(),
          kMapTrackScreenRoute: (context) => MapTrackScreen(),
        },
      ),
    );
  }
}
