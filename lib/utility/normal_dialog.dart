import 'package:flutter/material.dart';

Future<void> normalDialog(BuildContext context, String message,
    {Widget widget}) async {
  showDialog(
    context: context,
    builder: (context) => SimpleDialog(
      title: Text(
        message,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          fontStyle: FontStyle.normal,
        ),
      ),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            widget ?? const SizedBox(),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(widget == null ? 'OK' : 'Cancel'),
            ),
          ],
        )
      ],
    ),
  );
}
