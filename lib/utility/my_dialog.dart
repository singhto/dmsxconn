import 'package:flutter/material.dart';
import 'package:psinsx/widgets/show_proogress.dart';
import 'package:psinsx/widgets/show_text.dart';
import 'package:psinsx/widgets/widget_text_button.dart';

class MyDialog {
  final BuildContext context;
  MyDialog({
    required this.context,
  });

  void normalDialot({
    required String title,
    required String subTitle,
    Widget? firstButton,
    Widget? secondButton,
    Widget? contentWidget,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: ListTile(
          title: ShowText(text: title),
          subtitle: ShowText(text: subTitle),
        ),
        content: contentWidget ?? const SizedBox(),
        actions: [
          firstButton ?? const SizedBox(),
          secondButton ??
              WidgetTextButton(
                  label: 'ยกเลิก',
                  pressFunc: () {
                    Navigator.pop(context);
                  })
        ],
      ),
      barrierDismissible: false,
    );
  }

  Future<void> processDialog() async {
    showDialog(
      context: context,
      builder: (BuildContext context) => WillPopScope(
        child: ShowProgress(),
        onWillPop: () async {
          return false;
        },
      ),
      barrierDismissible: false,
    );
  }
}
