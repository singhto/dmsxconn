import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class WidgetIconButton extends StatelessWidget {
  final IconData iconData;
  final Function() pressFunc;

  const WidgetIconButton({
    Key key,
    @required this.iconData,
    @required this.pressFunc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: pressFunc,
        icon: Icon(
          iconData,
          color: Colors.yellow,
        ));
  }
}
