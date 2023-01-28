import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class WebViewAndroid extends StatefulWidget {
  const WebViewAndroid({Key? key}) : super(key: key);

  @override
  State<WebViewAndroid> createState() => _WebViewAndroidState();
}

class _WebViewAndroidState extends State<WebViewAndroid> {
  WebViewController? _controller;
  var _connection = 'unknown';

  @override
  void initState() {
    super.initState();

    // Check for internet connection
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      setState(() {
        _connection = result.toString();
      });
    });

    // Define the webview parameters
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0xFFFFC107))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // loading bar
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            // Define the URL to be used on the Webview
            if(request.url.startsWith('https://jornalstrada.com/')) {
              return NavigationDecision.navigate;
            }
            launchUrl(Uri.parse(request.url)); // open url in the default device browser
            return NavigationDecision.prevent;
          },
        ),
      )
      ..loadRequest(Uri.parse('https://jornalstrada.com'));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Webview App"),
        actions: const [],
      ),
      body: WebViewWidget(controller: _controller!),
    );
  }
}