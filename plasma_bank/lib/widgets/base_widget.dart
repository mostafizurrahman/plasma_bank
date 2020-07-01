

import 'package:flutter/cupertino.dart';

abstract class BaseWidget extends StatefulWidget{

  final Map arguments;
  BaseWidget(this.arguments);
  getData(String _key){
    if("country_list" == _key){
      debugPrint("________equat__________");
    }
    final _data = arguments["country_list"];
    return arguments[_key.toString()];
  }


}