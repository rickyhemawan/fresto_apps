import 'package:flutter/material.dart';
import 'package:fresto_apps/models_data/current_user_data.dart';
import 'package:fresto_apps/screens/create_order_screen.dart';
import 'package:fresto_apps/screens/login_screen.dart';
import 'package:fresto_apps/screens/main_screen.dart';
import 'package:fresto_apps/screens/merchant_detail_screen.dart';
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
        ChangeNotifierProvider(builder: (context) => CurrentUserData()),
      ],
      child: MaterialApp(
        title: 'Fresto',
        theme: ThemeData(
          primarySwatch: Colors.green,
          accentColor: Colors.black,
        ),
        initialRoute: kSplashScreenRoute,
        routes: {
          kMainScreenRoute: (context) => MainScreen(),
          kMerchantDetailScreenRoute: (context) => MerchantDetailScreen(),
          kCreateOrderScreenRoute: (context) => CreateOrderScreen(),
          kLoginScreen: (context) => LoginScreen(),
          kSplashScreenRoute: (context) => SplashScreen(),
        },
      ),
    );
  }
}
