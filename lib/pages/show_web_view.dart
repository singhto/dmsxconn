import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ShowWebView extends StatefulWidget {
  final String url;
  const ShowWebView({
    Key key,
    @required this.url,
  }) : super(key: key);

  @override
  State<ShowWebView> createState() => _ShowWebViewState();
}

class _ShowWebViewState extends State<ShowWebView> {

  @override
  void initState() {
    super.initState();
    WebView.platform = AndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: WebView(initialUrl: widget.url,),
    );
  }
}
