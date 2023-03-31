import 'package:flutter/material.dart';

class WidgetIconButton extends StatelessWidget {
  final IconData iconData;
  final Function() pressFunc;
  final double size;
  final EdgeInsetsGeometry edgeInsetsGeometry;

  const WidgetIconButton({
    Key key,
    @required this.iconData,
    @required this.pressFunc,
    this.size,
    this.edgeInsetsGeometry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: pressFunc,
      icon: Icon(
        iconData,
        color: Colors.yellow,
      ),
      iconSize: size ?? 24,
      padding: edgeInsetsGeometry ?? EdgeInsets.all(8),
    );
  }
}
