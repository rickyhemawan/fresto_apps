import 'package:flutter/material.dart';

class ModifyTextField extends StatelessWidget {
  final BuildContext context;
  final TextEditingController textController;
  final String hintText;
  final Function(String result) onConfirm;
  final TextInputType keyboardType;

  ModifyTextField(
      {this.context,
      this.textController,
      this.hintText,
      this.onConfirm,
      this.keyboardType});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Change Restaurant $hintText"),
      content: TextField(
        controller: textController,
        keyboardType: keyboardType,
        decoration: InputDecoration(hintText: "Restaurant $hintText"),
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () => Navigator.pop(context),
          child: Text("Cancel"),
        ),
        FlatButton(
          onPressed: () {
            onConfirm(textController.text);
            Navigator.pop(context);
          },
          child: Text("Save Changes"),
        ),
      ],
    );
  }
}
