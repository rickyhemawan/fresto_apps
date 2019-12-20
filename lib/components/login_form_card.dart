import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fresto_apps/models_data/current_user_data.dart';
import 'package:provider/provider.dart';

class FormCard extends StatelessWidget {
  final bool isRegister;
  FormCard({this.isRegister = true});

  Widget _customTextField(
      {Key tfKey,
      bool obscureText = false,
      String name,
      TextInputType keyboardType,
      void Function(String) onChanged}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: ScreenUtil.getInstance().setHeight(30),
        ),
        Text(name,
            style: TextStyle(
                fontFamily: "Poppins-Medium",
                fontSize: ScreenUtil.getInstance().setSp(26))),
        TextField(
          key: tfKey,
          obscureText: obscureText,
          keyboardType: keyboardType,
          onChanged: onChanged,
          decoration: InputDecoration(
              hintText: name.toLowerCase(),
              hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0)),
        ),
      ],
    );
  }

  Widget registerProperties(context) {
    if (!isRegister) return SizedBox();
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        _customTextField(
            tfKey: Key("tfConfirmPassword"),
            name: "Confirm Password",
            obscureText: true,
            onChanged:
                Provider.of<CurrentUserData>(context).setConfirmPassword),
        _customTextField(
            tfKey: Key("tfPhoneNumber"),
            name: "Phone Number",
            keyboardType: TextInputType.phone,
            onChanged: Provider.of<CurrentUserData>(context).setPhoneNumber),
        _customTextField(
            tfKey: Key("tfFullName"),
            name: "Full Name",
            onChanged: Provider.of<CurrentUserData>(context).setFullName),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final String title = isRegister ? "Register" : "Login";
    return new Container(
      width: double.infinity,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
                color: Colors.black12,
                offset: Offset(0.0, 15.0),
                blurRadius: 15.0),
            BoxShadow(
                color: Colors.black12,
                offset: Offset(0.0, -10.0),
                blurRadius: 10.0),
          ]),
      child: Padding(
        padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(title,
                style: TextStyle(
                    fontSize: ScreenUtil.getInstance().setSp(45),
                    fontFamily: "Poppins-Bold",
                    letterSpacing: .6)),
            _customTextField(
              tfKey: Key("tfEmail"),
              name: "Email",
              keyboardType: TextInputType.emailAddress,
              onChanged: Provider.of<CurrentUserData>(context).setEmail,
            ),
            _customTextField(
              tfKey: Key("tfPassword"),
              name: "Password",
              obscureText: true,
              onChanged: Provider.of<CurrentUserData>(context).setPassword,
            ),
            registerProperties(context),
            SizedBox(height: ScreenUtil.getInstance().setHeight(50)),
          ],
        ),
      ),
    );
  }
}
