import 'package:flutter/material.dart';

class WidgetImage extends StatelessWidget {
  final String path;
  final double width;
  final double height;

  const WidgetImage({
    Key key,
    @required this.path,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(path);
  }
}
