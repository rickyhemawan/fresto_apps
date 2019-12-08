import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:fresto_apps/models_data/current_user_data.dart';
import 'package:fresto_apps/utils/constants.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  void _changeScreen() {
    Navigator.of(context).pushNamedAndRemoveUntil(
        kMainScreenRoute, (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CurrentUserData>(
      builder: (context, currentUserData, child) {
        return FlutterLogin(
          title: "Fresto",
          onLogin: currentUserData.authUser,
          onSignup: currentUserData.registerUser,
          onSubmitAnimationCompleted: _changeScreen,
          onRecoverPassword: currentUserData.recoverPassword,
          theme: LoginTheme(
            bodyStyle: TextStyle(
              fontFamily: "Poppins-Medium",
            ),
            titleStyle: TextStyle(
              fontFamily: "Poppins-Bold",
              letterSpacing: .6,
            ),
            accentColor: Colors.white,
            buttonStyle: TextStyle(
              fontFamily: "Poppins-Bold",
              fontSize: 14,
              letterSpacing: 1.0,
            ),
          ),
        );
      },
    );
  }
}
