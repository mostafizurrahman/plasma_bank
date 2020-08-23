


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:plasma_bank/widgets/base/base_chat_widget.dart';

class ChatWidget extends BaseChatWidget {

  ChatWidget(final Map _args) : super(_args);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState

    return _ChatState();
  }

}

class _ChatState extends BaseChatState<ChatWidget> {

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      color: Colors.red,
    );
  }
}