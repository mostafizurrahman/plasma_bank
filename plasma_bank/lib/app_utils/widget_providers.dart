

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import 'package:plasma_bank/widgets/widget_templates.dart';

class WidgetProvider{

  static Widget getAppBar(BuildContext context, {title}) {
    return AppBar(
      elevation: 1.25,
      iconTheme: IconThemeData(
        color: Colors.black,
      ),
      backgroundColor: Colors.white,

      leading: Container(
        height: 70,
        child: Center(
          child: new IconButton(
            icon: new Icon(Icons.arrow_back, ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
      ),
      title: Text(title ?? "", style: TextStyle(
        color: Colors.pink
      ),),
      centerTitle: true,
    );
  }

  static Widget getButton(final String _title, final Icon suffixIcon, final Function _onTap, {final buttonWidth = 250.0}){
    return Padding(
      padding: const EdgeInsets.only(left: 24, right:  24, top: 16, bottom:  24),
      child: Container(
        width: buttonWidth,
        height: 48,
        child: RaisedButton(
          onPressed: _onTap,
          elevation: 0.5,
          color: Colors.blueAccent,
          shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(40),
            side: BorderSide(color: Colors.cyan, width: 1.75),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              Text(
                _title,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.white
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: suffixIcon,
              )
            ],
          ),
        ),
      ),
    );
  }

  static loading(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Material(
        color: Colors.transparent,
        type: MaterialType.card,
        child: WillPopScope(
          onWillPop: () async {
            return Future<bool>.value(false);
          },
          child: BackdropFilter(
            filter: ui.ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: Center(
              child: Container(
                width: 120,
                height: 120,
                decoration: new BoxDecoration(
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Colors.white.withOpacity(0.5),
                      blurRadius: 6.0,
                    ),
                  ],
                  color: Colors.black54.withOpacity(0.5),
                  borderRadius:
                  new BorderRadius.all(const Radius.circular(12.0)),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Center(
                        child: WidgetTemplate.indicator(),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          "LOADING...",
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  static circledIcon(final Widget _icon){
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(1000),
          ),
          border: Border.all(
              width: 0.85,
              color: Colors.red,
              style: BorderStyle.solid)),
      child: _icon,
    );
  }
}