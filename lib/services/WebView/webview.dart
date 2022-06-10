import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'webViewStack.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'navigationControls.dart';
import 'menu.dart';

class WebViewExample extends StatefulWidget {
  final String url;
  const WebViewExample({Key? key, required this.url}) : super(key: key);
  @override
  WebViewExampleState createState() => WebViewExampleState();
}

class WebViewExampleState extends State<WebViewExample> {
  final controller = Completer<WebViewController>();
  @override
  void initState() {
    super.initState();
    // Enable virtual display.
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("WebView"),
        actions: [
          NavigationControls(controller: controller),
          Menu(
            controller: controller,
            url: widget.url,
          ), //
        ],
      ),
      body: WebViewStack(
        controller: controller,
        url: widget.url,
      ),
    );
  }
}
