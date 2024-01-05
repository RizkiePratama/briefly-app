import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class BrieflyAppWebView extends StatefulWidget {
  const BrieflyAppWebView({Key? key, required this.url}) : super(key: key);

  final String url;

  @override
  State<BrieflyAppWebView> createState() => _BrieflyAppWebViewState();
}

class _BrieflyAppWebViewState extends State<BrieflyAppWebView> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(
        Uri.parse(widget.url),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: WebViewWidget(controller: _controller),
    );
  }
}
