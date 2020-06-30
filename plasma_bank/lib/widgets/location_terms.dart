import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

class LocationTerms extends StatefulWidget {
  @override
  LocationTermsState createState() {
    return LocationTermsState();
  }
}

class LocationTermsState extends State<LocationTerms> {
  WebViewController _controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Terms & Conditions'),
        titleSpacing: 0,
      ),
      body: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.only(left: 12, right: 12, top:  12, bottom: 48),
          child: Container(
            color: Colors.red,
            child: WebView(
              initialUrl: '',
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (WebViewController webViewController) async {
                _controller = webViewController;
                await _loadHtmlFromAssets();
              },
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _loadHtmlFromAssets() async {
    String fileText = await rootBundle.loadString('lib/assets/terms.htm');
    _controller.loadUrl(Uri.dataFromString(fileText,
            mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
        .toString());
  }
}
