import 'package:flutter/material.dart';
import 'package:psinsx/utility/my_constant.dart';
import 'package:psinsx/widgets/logo.dart';
import 'package:psinsx/widgets/show_text.dart';

class CustomDialog {
  Future<Null> loadingDialog(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => WillPopScope(
        child: Center(child: CircularProgressIndicator()),
        onWillPop: () async => false,
      ),
    );
  }

  Future<void> actionDialog({
    @required BuildContext context,
    @required String title,
    @required String subTitle,
    @required String label,
    @required Function() pressFunc,
    String label2,
    Function() pressFucn2,
  }) async {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: ListTile(
          leading: Logo(),
          title: ShowText(
            text: title,
            textStyle: MyConstant().h2Style(),
          ),
          subtitle: ShowText(
            text: subTitle,
          ),
        ),
        actions: [
          TextButton(
            onPressed: pressFunc,
            child: Text(label),
          ),
          label2 == null ? const SizedBox() :
           TextButton(
            onPressed: pressFucn2,
            child: Text(label2),
          ),
        ],
      ),
    );
  }
}
