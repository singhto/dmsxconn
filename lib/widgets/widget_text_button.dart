import 'package:flutter/material.dart';
import 'package:psinsx/utility/my_constant.dart';
import 'package:psinsx/widgets/show_text.dart';

class WidgetTextButton extends StatelessWidget {
  final String label;
  final Function() pressFunc;
  const WidgetTextButton({
    Key key,
    @required this.label,
    @required this.pressFunc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: pressFunc,
      child: ShowText(
        text: label,
        textStyle: MyConstant().h3Style(),
      ),
    );
  }
}
