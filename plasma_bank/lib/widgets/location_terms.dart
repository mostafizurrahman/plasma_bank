import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:plasma_bank/app_utils/app_constants.dart';
import 'package:plasma_bank/app_utils/widget_providers.dart';
import 'package:plasma_bank/widgets/widget_templates.dart';
import 'package:rxdart/rxdart.dart';
import 'package:webview_flutter/webview_flutter.dart';

class LocationTerms extends StatefulWidget {
  @override
  LocationTermsState createState() {
    return LocationTermsState();
  }
}

class LocationTermsState extends State<LocationTerms> {
  WebViewController _controller;

  PublishSubject<bool> _webPublisher = PublishSubject<bool>();

  Widget _widget;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(milliseconds: 50), () {
      this._webPublisher.sink.add(false);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _webPublisher.close();
  }


  _onAgree(){

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyle.greyBackground(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: WidgetProvider.button(_onAgree, "I AGREE", context),
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: AppStyle.greyBackground(),
        title: Text(
          'Terms & Conditions',
          style: TextStyle(color: AppStyle.theme()),
        ),
        iconTheme: IconThemeData(color: AppStyle.theme()),
        titleSpacing: 0,
        
      ),
      body: StreamBuilder(
        stream: _webPublisher.stream,
        initialData: true,
        builder: (_context, _snap) {
          return _snap.data
              ? Container(
                  color: AppStyle.greyBackground(),
                  child: Container(
                    child: WebView(
                      initialUrl: '',
                      javascriptMode: JavascriptMode.unrestricted,
                      onWebViewCreated:
                          (WebViewController webViewController) async {
                        _controller = webViewController;
                        await _loadHtmlFromAssets();
                      },
                    ),
                  ),
                )
              : Center(
                  child: WidgetTemplate.progressIndicator(),
                );
        },
      ),
    );
  }

  Future<void> _loadHtmlFromAssets() async {
    String fileText = await rootBundle.loadString('lib/assets/terms.htm');
    _controller.loadUrl(Uri.dataFromString(fileText,
            mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
        .toString());
    Future.delayed(Duration(milliseconds: 200), () {
      this._webPublisher.sink.add(true);
    });
  }
}
