import 'package:flutter/material.dart';
import 'package:psinsx/utility/my_constant.dart';

class WidgetTextRich extends StatelessWidget {
  const WidgetTextRich({
    Key? key,
    required this.head,
    required this.value,
  }) : super(key: key);

  final String head;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
          text: head,
          style: MyConstant()
              .h3Style(color: Colors.yellow, fontWeight: FontWeight.bold),
          children: <InlineSpan>[
            TextSpan(
                text: ' : ',
                style: MyConstant()
                    .h3Style(fontWeight: FontWeight.bold, color: Colors.white)),
            TextSpan(
              text: value,
              style: MyConstant().h3Style(color: Colors.white),
            ),
          ]),
    );
  }
}
