import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:plasma_bank/app_utils/app_constants.dart';
import 'package:plasma_bank/app_utils/widget_providers.dart';
import 'package:plasma_bank/app_utils/widget_templates.dart';
import 'package:plasma_bank/widgets/base/base_chat_widget.dart';
import 'package:plasma_bank/widgets/stateful/dynamic_keyboard.dart';
import 'package:rxdart/rxdart.dart';

class ChatWidget extends BaseChatWidget {
  ChatWidget(final Map _args) : super(_args);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState

    return _ChatState();
  }
}

class _ChatState extends BaseChatState<ChatWidget> {
  BehaviorSubject<bool> _keyboardBehavior = BehaviorSubject();
  BehaviorSubject<bool> _indicatorBehavior = BehaviorSubject();
  TextEditingController _chatTextController = TextEditingController();
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _keyboardBehavior.close();

    _indicatorBehavior.close();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _initChatWidget();
    Future.delayed(Duration(seconds: 1), _initChatWidget);
  }

  _initChatWidget() async {
    this._indicatorBehavior.sink.add(false);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
//    Navigator.pop(context);
    return Container(
      color: Colors.white,
      child: Padding(
          padding:
              EdgeInsets.only(bottom: displayData.bottom, top: displayData.top),
          child: StreamBuilder<bool>(
            stream: _indicatorBehavior.stream,
            initialData: true,
            builder: (context, snapshot) {
              return snapshot.data
                  ? Center(
                      child: WidgetTemplate.indicator(),
                    )
                  : _getChatWidget(context);
            },
          )),
    );
  }

  Widget _getChatWidget(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: StreamBuilder<bool>(
        initialData: true,
        stream: _keyboardBehavior.stream,
        builder: (_context, snapshot) {
//          double _keyboardHeight = 200;
          return Container(
              height: snapshot.data ? 285 : 75,
              child: _getBottomNavigator(snapshot.data));
        },
      ),
    );
  }

  Widget _getBottomNavigator(final bool _data) {
    return Column(
      children: <Widget>[
        Container(
          height: 75,
          decoration: BoxDecoration(
            boxShadow: [
               BoxShadow(
                color: Colors.grey,
              ),
              BoxShadow(
                color: Colors.white,
                spreadRadius: -1.0,
                blurRadius: 1.750,
              ),
            ],
          ),
//            color: Colors.white,
          child: TextFormField(
            controller: _chatTextController,
            style: TextStyle(
              fontSize: 14,
            ),
            onTap: ()=>this._keyboardBehavior.sink.add(true),
            decoration: InputDecoration(
              isDense: true,
              contentPadding:
              const EdgeInsets.only(left: 8.0, bottom: 4.0, top: 4.0, right: 8.0),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent, width: 0.750),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent, width: 0.750),
              ),
              hintText: "TYPE SOMETHING TO SEND...",
              hintStyle: TextStyle(color: Color.fromARGB(255, 220, 220, 220), fontSize: 12),
            ),
            readOnly: true,
            showCursor: true,
            maxLines: 6,
          ),
        ),
        _data
            ? GestureDetector(
                onHorizontalDragUpdate: (value) {
                  debugPrint('dragging');
                  this._keyboardBehavior.sink.add(false);
                },
                child: DynamicKeyboardWidget(
                  _onKeyPressed,
                  doneButtonIcon: Icons.message,
                ),
              )
            : SizedBox(),
      ],
    );
  }

  _onKeyPressed( String _key) {
    debugPrint(_key);
    if(_key.toLowerCase() == 'space'){
      _key = ' ';
    }
    if(this._chatTextController.text.length < 200){
      WidgetProvider.addTextInController(_chatTextController, _key);
    }
  }
}
