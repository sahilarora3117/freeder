import 'dart:async';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
enum _MenuOptions {
  navigationDelegate,
  userAgent, // Add this line
}

class Menu extends StatelessWidget {
  final String url;
  const Menu({required this.controller, Key? key, required this.url})
      : super(key: key);

  final Completer<WebViewController> controller;
  
  @override
  void _launchUrl() async {
  if (!await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication)) throw 'Could not launch';
}
  Widget build(BuildContext context) {
    
    return FutureBuilder<WebViewController>(
      future: controller.future,
      builder: (context, controller) {
        return PopupMenuButton<_MenuOptions>(
          onSelected: (value) async {
            switch (value) {
              case _MenuOptions.navigationDelegate:
                _launchUrl();
                break;
              case _MenuOptions.userAgent:
                final userAgent = await controller.data!
                    .runJavascriptReturningResult('navigator.userAgent');
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(userAgent),
                ));
                break;
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem<_MenuOptions>(
              value: _MenuOptions.navigationDelegate,
              child: Text('Open in brower'),
            ),
            const PopupMenuItem<_MenuOptions>(
              value: _MenuOptions.userAgent,
              child: Text('Show user-agent'),
            ),
          ],
        );
      },
    );
  }
}
