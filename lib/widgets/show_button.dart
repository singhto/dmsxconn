import 'package:flutter/material.dart';

class ShowButton extends StatelessWidget {
  final Function() pressFunc;
  final String label;
  final Color colorLabel;
  const ShowButton({
    Key key,
    @required this.pressFunc,
    @required this.label,
    this.colorLabel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: pressFunc,
      child: Text(
        label,
        style: TextStyle(color: colorLabel ?? Colors.blue),
      ),
    );
  }
}
