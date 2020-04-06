import 'package:flutter/material.dart';

class ModifyTextField extends StatelessWidget {
  final BuildContext context;
  final TextEditingController textController;
  final String hintText;
  final Function(String result) onConfirm;
  final TextInputType keyboardType;
  final bool isClient;

  ModifyTextField(
      {this.context,
      this.textController,
      this.hintText,
      this.onConfirm,
      this.keyboardType,
      this.isClient = false});

  @override
  Widget build(BuildContext context) {
    String desc = this.isClient ? "Client" : "Restaurant";
    return AlertDialog(
      title: Text("Change $desc $hintText"),
      content: TextField(
        controller: textController,
        keyboardType: keyboardType,
        decoration: InputDecoration(hintText: "$desc $hintText"),
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
