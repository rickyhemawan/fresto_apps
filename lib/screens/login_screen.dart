import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fresto_apps/components/login_form_card.dart';
import 'package:fresto_apps/models_data/user_auth_data.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _login = true;

  String _buttonNames(bool checker) {
    if (checker) return "Login";
    return "Register";
  }

  String _descriptionNames(bool checker) {
    if (!checker) return "New User? ";
    return "Already have an account? ";
  }

  Future<void> _buttonPressed(context) async {
    String result;
    final provider = Provider.of<UserAuthData>(context);
    if (_login) {
      result = await provider.loginUser();
    } else {
      result = await provider.registerUser();
    }
    if (result != null) {
      Scaffold.of(context).showSnackBar(SnackBar(content: Text(result)));
      return;
    }
    provider.nextPage(context);
  }

  Widget _loadingScreen(bool isLoading) {
    return isLoading
        ? Container(
            alignment: Alignment.center,
            color: Colors.white.withOpacity(0.5),
            child: CircularProgressIndicator(),
          )
        : SizedBox();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil.getInstance()..init(context);
    ScreenUtil.instance =
        ScreenUtil(width: 750, height: 1334, allowFontScaling: true);
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomPadding: true,
      body: Builder(builder: (context) {
        return Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Container(color: Colors.green),
            SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(left: 28.0, right: 28.0, top: 60.0),
                child: Column(
                  children: <Widget>[
                    Text(
                      "Fresto",
                      style: TextStyle(
                        fontFamily: "Poppins-Bold",
                        fontSize: ScreenUtil.getInstance().setSp(72),
                        color: Colors.white,
                        letterSpacing: .6,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: ScreenUtil.getInstance().setHeight(60),
                    ),
                    FormCard(isRegister: !_login),
                    SizedBox(height: ScreenUtil.getInstance().setHeight(40)),
                    InkWell(
                      child: Container(
                        width: double.infinity,
                        height: ScreenUtil.getInstance().setHeight(100),
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                colors: [Colors.orangeAccent, Colors.lime]),
                            borderRadius: BorderRadius.circular(6.0),
                            boxShadow: [
                              BoxShadow(
                                  color: Color(0xFF6078ea).withOpacity(.3),
                                  offset: Offset(0.0, 8.0),
                                  blurRadius: 8.0)
                            ]),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            key: Key("btnLoginOrRegister"),
                            onTap: () async => await _buttonPressed(context),
                            child: Center(
                              child: Text(_buttonNames(_login),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: "Poppins-Bold",
                                      fontSize: 18,
                                      letterSpacing: 1.0)),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: ScreenUtil.getInstance().setHeight(40),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          _descriptionNames(!_login),
                          style: TextStyle(
                            fontFamily: "Poppins-Medium",
                            color: Colors.white,
                          ),
                        ),
                        InkWell(
                          onTap: () => setState(() => _login = !_login),
                          key: Key("btnSwitchLoginOrRegister"),
                          child: Text(_buttonNames(!_login),
                              style: TextStyle(
                                  color: Colors.yellow,
                                  fontFamily: "Poppins-Bold")),
                        )
                      ],
                    ),
                    SizedBox(height: ScreenUtil.getInstance().setHeight(120)),
                  ],
                ),
              ),
            ),
            _loadingScreen(Provider.of<UserAuthData>(context).loadingStatus),
          ],
        );
      }),
    );
  }
}
