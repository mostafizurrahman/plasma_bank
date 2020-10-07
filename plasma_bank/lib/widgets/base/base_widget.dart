

import 'package:flutter/cupertino.dart';

abstract class BaseWidget extends StatefulWidget{

  final Map arguments;
  BaseWidget(this.arguments);
  getData(String _key){
    return arguments[_key.toString()];
  }


}