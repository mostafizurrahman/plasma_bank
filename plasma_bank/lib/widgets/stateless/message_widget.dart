import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import 'package:plasma_bank/app_utils/app_constants.dart';

class MessageWidget extends StatelessWidget {
  final Color headerColor;
  final Color messageColor;
  final String _message;
  final String dialogTitle;
  final String actionTitle;
  final Function onTapped;

  final Function onActionTap;
  final Icon actionIcon;
  final Icon titleIcon;
  MessageWidget(this._message,
      {this.dialogTitle,
      this.onTapped,
      this.actionTitle,
      this.titleIcon = const Icon(
        Icons.info,
        color: Colors.blueAccent,
        size: 30,
      ),
        this.onActionTap,
      this.actionIcon ,
      this.headerColor = Colors.green,
      this.messageColor = Colors.black54});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return Future<bool>.value(false);
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Ink(
            child: InkWell(
              onTap: () {
                if (this.onTapped != null) {
                  this.onTapped();
                } else {
                  Navigator.pop(context);
                }
              },
              child: BackdropFilter(
                filter: ui.ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: new BoxDecoration(
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color: Colors.black54.withOpacity(0.2),
                            blurRadius: 4.0,
                            offset: Offset(0.0, -4),
                          ),
                        ],
                        color: Colors.white,
                        borderRadius: new BorderRadius.only(
                          topLeft: const Radius.circular(12.0),
                          topRight: const Radius.circular(12.0),
                        ),
                      ),
//                      height: 210,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 16, 0, 12),
                            child: this.dialogTitle != null
                                ? Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding:
                                            EdgeInsets.only(left: 24, right: 8),
                                        child: this.titleIcon,
                                      ),
                                      Text(
                                        this.dialogTitle,
                                        style: TextStyle(
                                          color: this.headerColor,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  )
                                : SizedBox(),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 24, right: 24),
                            child: RichText(
                              softWrap: true,
                              textAlign: TextAlign.left,
                              text: TextSpan(
                                children: this.getFormattedTextSpan(_message),
                                style: TextStyle(
                                  color: this.messageColor,
                                  fontSize: 14,
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ),
                          this._getActionWidget(context)
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<TextSpan> getFormattedTextSpan(String text,
      {String start = "<b>",
      String end = "<//b>",
      TextStyle style =
          const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)}) {
    List<TextSpan> textSpans = List();
    while (text.contains(start)) {
      int startIndex = text.indexOf(start);
      int endIndex = text.indexOf(end);

      TextSpan boldTextSpan = TextSpan(
          text: text.substring(startIndex, endIndex).replaceFirst(start, ""),
          style: style);

      String preText = startIndex != 0 ? text.substring(0, startIndex) : "";
      text = text.substring(endIndex, text.length).replaceFirst(end, "");
      textSpans.add(TextSpan(text: preText));
      textSpans.add(boldTextSpan);
    }
    if (text != null && text.length > 0) {
      textSpans.add(TextSpan(text: text));
    }
    return textSpans;
  }

  Widget _getActionWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24, top: 16, bottom: 16),
      child: Container(
        height: 45,
        child: RaisedButton(
          onPressed: this.onActionTap ?? this.onTapped ??
              () {
                debugPrint("DONE");
                Navigator.pop(context);
              },
          elevation: 0.5,
          color: AppStyle.theme(),
          shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(40),
            side: BorderSide(color: Colors.cyan, width: 0.75),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                this.actionTitle ?? "DONE",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.white),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: this.actionIcon != null ? this.actionIcon : Text(''),
              )
            ],
          ),
        ),
      ),
    );
  }
}
