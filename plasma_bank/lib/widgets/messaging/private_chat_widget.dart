import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:plasma_bank/app_utils/app_constants.dart';
import 'package:plasma_bank/app_utils/widget_providers.dart';
import 'package:plasma_bank/app_utils/widget_templates.dart';
import 'package:plasma_bank/network/donor_handler.dart';
import 'package:plasma_bank/network/message_repository.dart';
import 'package:plasma_bank/network/models/blood_donor.dart';
import 'package:plasma_bank/network/sqlit_database.dart';
import 'package:plasma_bank/widgets/base/base_chat_widget.dart';
import 'package:plasma_bank/widgets/stateful/dynamic_keyboard.dart';
import 'package:rxdart/rxdart.dart';

class PrivateChatWidget extends BaseChatWidget {
  PrivateChatWidget(final Map _args) : super(_args);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState

    return _PrivateChatState();
  }
}

class _PrivateChatState extends BaseChatState<PrivateChatWidget> {
  BehaviorSubject<bool> _keyboardBehavior = BehaviorSubject();
  BehaviorSubject<bool> _indicatorBehavior = BehaviorSubject();
  BehaviorSubject<bool> _sendingBehavior = BehaviorSubject();

  BehaviorSubject<List<MessageData>> _messageBehavior = BehaviorSubject();
  TextEditingController _chatTextController = TextEditingController();
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _keyboardBehavior.close();
    _indicatorBehavior.close();
    _sendingBehavior.close();
    _messageBehavior.close();
  }

  MessageRepository _messageRepository;
  SqliteDatabase _sqliteDatabase;
  @override
  void initState() {
    // TODO: implement initState_
    super.initState();
    _initChatWidget();
  }

  set message(List<MessageData> _value) {
    _messageBehavior.sink.add(_value);
  }

  _initChatWidget() async {
    final BloodDonor _donor = super.widget.getData('donor');
    _messageRepository = MessageRepository.fromMail(_donor.emailAddress);
    _sqliteDatabase = new SqliteDatabase(
        donorHandler.loginEmail, _donor.emailAddress, _onInitialized);
  }

  _onInitialized() {
    Future.delayed(Duration(seconds: 1), () {
      this._sqliteDatabase.getMessages().then((value) => message = value);
      this._messageRepository.getInComingStream().listen(_onInComingMessage);
      this._messageRepository.getOutGoingStream().listen(_onOutGoingMessage);
      this._indicatorBehavior.sink.add(false);
    });
  }

  _onInComingMessage(final DocumentSnapshot _messageSnap) {
    if (_messageSnap != null && _messageSnap.data != null) {
      _updateRepository(_messageSnap, false);
    }
  }

  _onOutGoingMessage(final DocumentSnapshot _messageSnap) {
    if (_messageSnap != null && _messageSnap.data != null) {
      _updateRepository(_messageSnap, true);

      //read last outgoing message
      //check if seen or not
      //merge if not seen
      //update database if not seen
      //if seen insert in database
    }
  }

  _updateRepository(DocumentSnapshot _messageSnap, bool isOut) {
    final messageData = MessageData.fromMap(_messageSnap.data, isOut);
    if (messageData.shouldInsert) {
      _sqliteDatabase.updateMessage(messageData);
      if (isOut) {
        _messageRepository.updateOutGoingStatus();
      } else {
        _messageRepository.updateIncomingStatus();
      }
      _addToList(messageData);
    }
  }

  _addToList(MessageData messageData){
    final _list = this._messageBehavior.value ?? [];
    _list.add(messageData);
    this._messageBehavior.sink.add(_list);
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
        ),
      ),
    );
  }

  Widget _getChatWidget(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<MessageData>>(
        stream: _messageBehavior.stream,
        initialData: null,
        builder: (_messageContext, _messageSnapshot) {
          if (_messageSnapshot.hasData) {
            List<MessageData> _dataList = _messageSnapshot.data;
            if (_dataList != null && _dataList.length > 0) {
              return ListView.builder(
                reverse: true,
                scrollDirection: Axis.vertical,
                itemCount: _dataList.length + 1,
                itemBuilder: (_context, _index) {
                  if (_index == 0) {
                    return WidgetTemplate.getPageAppBar(context);
                  }
                  final _data = _dataList[_index - 1];
                  return _getWidget(_data);
                },
              );
            }
          }
          return Container(
            child: Center(
              child: WidgetTemplate.indicator(),
            ),
          );
        },
      ),
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
            onTap: () => this._keyboardBehavior.sink.add(true),
            decoration: InputDecoration(
              isDense: true,
              contentPadding: const EdgeInsets.only(
                  left: 8.0, bottom: 4.0, top: 4.0, right: 8.0),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent, width: 0.750),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent, width: 0.750),
              ),
              hintText: "TYPE SOMETHING TO SEND...",
              hintStyle: TextStyle(
                  color: Color.fromARGB(255, 220, 220, 220), fontSize: 12),
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
    if (_key.toLowerCase() == 'space') {
      _key = ' ';
    } else if (_key.toLowerCase() == 'done') {
      if(!(_sendingBehavior.value ?? true)) {
        _sendingBehavior.sink.add(true);
        final BloodDonor _donor = super.widget.getData('donor');
        _messageRepository.sendMessage(
            _donor.emailAddress, this._chatTextController.text, _onDataSent);
        this._chatTextController.text = '';
      }
      return;
    }
    if (this._chatTextController.text.length < 200) {
      WidgetProvider.addTextInController(_chatTextController, _key);
    }
  }

  _onDataSent(final bool success) {
    if (!success) {

    }
    _sendingBehavior.sink.add(false);
  }

  Widget _getWidget(final MessageData _data) {
    return Padding(
      padding: EdgeInsets.all(24),
      child: Container(
        child: Column(
          crossAxisAlignment: _data.isOutGoing
              ? CrossAxisAlignment.start
              : CrossAxisAlignment.end,
          children: <Widget>[
            Text(_data.dateTime),
            Padding(
              padding: EdgeInsets.only(
                top: 12,
                left: 12,
              ),
              child: Text(_data.message),
            )
          ],
        ),
        decoration: AppStyle.listItemDecoration,
      ),
    );
  }
}
