import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fresto_apps/models_data/user_auth_data.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil.getInstance()..init(context);
    ScreenUtil.instance =
        ScreenUtil(width: 750, height: 1334, allowFontScaling: true);
    Provider.of<UserAuthData>(context).nextPage(context);
    return Scaffold(
      backgroundColor: Colors.green,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Fresto",
              style: TextStyle(
                fontFamily: "Poppins-Bold",
                color: Colors.white,
                letterSpacing: .6,
                fontSize: ScreenUtil.getInstance().setSp(120),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: ScreenUtil.getInstance().setHeight(180)),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
