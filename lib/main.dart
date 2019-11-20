import 'package:flutter/material.dart';
import 'package:fresto_apps/screens/main_screen.dart';

import 'utils/constants.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fresto',
      theme: ThemeData(
        primarySwatch: Colors.green,
        accentColor: Colors.black,
      ),
      initialRoute: kMainScreenRoute,
      routes: {
        kMainScreenRoute: (context) => MainScreen(),
      },
    );
  }
}
