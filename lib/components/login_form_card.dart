import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fresto_apps/models_data/user_auth_data.dart';
import 'package:provider/provider.dart';

class FormCard extends StatefulWidget {
  final bool isRegister;
  FormCard({this.isRegister = true});

  @override
  _FormCardState createState() => _FormCardState();
}

class _FormCardState extends State<FormCard> {
  bool _hidePassword = true;
  bool _hideConfirmPassword = true;

  Widget _customTextField(
      {Key tfKey,
      bool obscureText = false,
      bool isConfirmPassword = false,
      isPassword = false,
      String name,
      TextInputType keyboardType,
      void Function(String) onChanged}) {
    void _changeVisibilityStatus() {
      if (isPassword) setState(() => _hidePassword = !_hidePassword);
      if (isConfirmPassword)
        setState(() => _hideConfirmPassword = !_hideConfirmPassword);
      print("visibility icon pressed!");
    }

    Widget _visibilityIconButton() {
      return IconButton(
        icon: Icon(obscureText ? Icons.visibility : Icons.visibility_off),
        onPressed: _changeVisibilityStatus,
      );
    }

    bool _isIconNeeded() {
      if (isConfirmPassword) return true;
      if (isPassword) return true;
      return false;
    }

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
              suffixIcon: _isIconNeeded() ? _visibilityIconButton() : null,
              hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0)),
        ),
      ],
    );
  }

  Widget _registerProperties(context) {
    if (!widget.isRegister) return SizedBox();
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        _customTextField(
            tfKey: Key("tfConfirmPassword"),
            name: "Confirm Password",
            obscureText: _hideConfirmPassword,
            isConfirmPassword: true,
            onChanged: Provider.of<UserAuthData>(context).setConfirmPassword),
        _customTextField(
            tfKey: Key("tfPhoneNumber"),
            name: "Phone Number",
            keyboardType: TextInputType.phone,
            onChanged: Provider.of<UserAuthData>(context).setPhoneNumber),
        _customTextField(
            tfKey: Key("tfFullName"),
            name: "Full Name",
            onChanged: Provider.of<UserAuthData>(context).setFullName),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final String title = widget.isRegister ? "Register" : "Login";
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
              onChanged: Provider.of<UserAuthData>(context).setEmail,
            ),
            _customTextField(
              tfKey: Key("tfPassword"),
              name: "Password",
              isPassword: true,
              obscureText: _hidePassword,
              onChanged: Provider.of<UserAuthData>(context).setPassword,
            ),
            _registerProperties(context),
            SizedBox(height: ScreenUtil.getInstance().setHeight(50)),
          ],
        ),
      ),
    );
  }
}
