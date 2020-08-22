

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:plasma_bank/app_utils/app_constants.dart';

class MessageListWidget extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MessageListState();
  }
}

class _MessageListState extends State<MessageListWidget>{


  @override
  Widget build(BuildContext context) {
    return Container(color: Colors.red, height: displayData.height - displayData.navHeight, width: displayData.width,);
  }
}