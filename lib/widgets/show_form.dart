import 'package:flutter/material.dart';

class ShowForm extends StatelessWidget {
  final String label;
  final IconData iconData;
  final TextInputType textInputType;
  final String Function(String) funcValidate;
  final Function(String) funcSave;
  const ShowForm(
      {Key key,
      @required this.label,
      @required this.iconData,
      @required this.funcValidate,
      @required this.funcSave,
      this.textInputType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 16),
      width: 250,
      child: TextFormField(onSaved: funcSave,
        validator: funcValidate,
        keyboardType: textInputType ?? TextInputType.text,
        decoration: InputDecoration(
          prefixIcon: Icon(iconData),
          labelText: label,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}
