

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WidgetProvider{

  static Widget getAppBar(BuildContext context) {
    return AppBar(
      elevation: 0.25,
      iconTheme: IconThemeData(
        color: Colors.black,
      ),
      backgroundColor: Colors.blueGrey,
      leading: Container(
        height: 70,
        child: Center(
          child: new IconButton(
            icon: new Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
      ),
      title: Text("Add Money"),
      centerTitle: false,
    );
  }
}