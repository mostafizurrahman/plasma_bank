

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WidgetTemplates{


  static Widget progressIndicator(){
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          WidgetTemplates.indicator(),
          Padding(
            padding: EdgeInsets.all(12),
            child: Text(
              "LOADING...",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }

  static Widget indicator(){
    return CircularProgressIndicator(
      strokeWidth: 1.75,
      backgroundColor: Colors.red,
      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      semanticsLabel: "LOADING...",
    );
  }
}