import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
  BehaviorSubject<String> _keyTapBehavior = BehaviorSubject();
  StreamSubscription<DocumentSnapshot> _counterSubscription;
  BehaviorSubject<List<MessageData>> _messageBehavior = BehaviorSubject();
  TextEditingController _chatTextController = TextEditingController();

  FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _keyboardBehavior.close();
    _indicatorBehavior.close();
    _sendingBehavior.close();
    _messageBehavior.close();
    _counterSubscription.cancel();
    this._messageRepository.dispose();
    _keyTapBehavior.close();
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
      FocusScope.of(context).requestFocus(_focusNode);
      this._chatTextController.text = "";
      this._indicatorBehavior.sink.add(false);
      this._sqliteDatabase.getMessages().then((value) => message = value);
      _counterSubscription = this
          ._messageRepository
          .getInComingStream()
          .listen(_onInComingMessage);
      this._messageRepository.getOutGoingStream().listen(_onOutGoingMessage);
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
    if (isOut && messageData.isUpdated) {
      _sqliteDatabase.updateMessage(messageData).then((value) {
        if (value > 0) {
          final _list = this._messageBehavior.value ?? [];
          _list.forEach((element) {
            if (element.dateTime == messageData.dateTime) {
              element.message = messageData.message;
            }
          });
          if (!this._messageBehavior.isClosed) {
            this._messageBehavior.sink.add(_list);
          }
        }
      });
    } else if (messageData.shouldInsert) {
      if (isOut) {
        _messageRepository.updateOutGoingStatus();
        _sqliteDatabase.insertMessage(messageData);
        _addToList(messageData);
      } else {
        if (messageData.isUpdated) {
          //updated incoming message
          _sqliteDatabase.updateMessage(messageData).then((value) {
            if (value > 0) {
              final _list = this._messageBehavior.value ?? [];
              _list.forEach((element) {
                if (element.dateTime == messageData.dateTime) {
                  element.message = messageData.message;
                }
              });
              if (!this._messageBehavior.isClosed) {
                this._messageBehavior.sink.add(_list);
              }
            } else {
              _sqliteDatabase.insertMessage(messageData).catchError((_error) {
                debugPrint('insertion fail  _______ ' + _error.toString());
              });
              _addToList(messageData);
              _messageRepository.updateIncomingStatus();
            }
          }).catchError((_error) {
            debugPrint('update fail');
          });
          debugPrint(messageData.message);
        } else {
          _sqliteDatabase.insertMessage(messageData).catchError((_error) {
            debugPrint('insertion fail  _______ ' + _error.toString());
          });
          _messageRepository.updateIncomingStatus();
          _addToList(messageData);
        }
      }
    }
  }

  _addToList(MessageData messageData) {
    final _list = this._messageBehavior.value ?? [];
    _list.add(messageData);
    if (!this._messageBehavior.isClosed) {
      this._messageBehavior.sink.add(_list);
    }
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
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(top:32),
        child: Row(
          children: <Widget>[
            Container(
              height: 50, width: 50,
              color: Colors.red,
            ),

            Expanded(
              child: SizedBox(width: displayData.width * 0.2,),
            ),
            Container(
              height: 50, width: 50,
              color: Colors.green,
            )
          ],
        ),
      ),
      body: StreamBuilder<List<MessageData>>(
        stream: _messageBehavior.stream,
        initialData: null,
        builder: (_messageContext, _messageSnapshot) {
          final _dataList = _messageSnapshot.data ?? [];
          return ListView.builder(
            reverse: true,
            scrollDirection: Axis.vertical,
            itemCount: _dataList.length + 1,
            itemBuilder: (_context, _index) {
              if (_index == _dataList.length) {
                return WidgetTemplate.getPageAppBar(context);
              }
              final _data = _dataList[_dataList.length - _index - 1];
              return _getWidget(_data);
            },
          );
//          return Container(
//            child: Center(
//              child: WidgetTemplate.indicator(),
//            ),
//          );
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
          child: Row(
            children: <Widget>[
              Container(
                width: displayData.width - 55,
                child: TextFormField(
                  focusNode: _focusNode,
                  controller: _chatTextController,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                  onTap: () => this._keyboardBehavior.sink.add(true),
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: const EdgeInsets.only(
                        left: 8.0, bottom: 4.0, top: 4.0, right: 8.0),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.transparent, width: 0.750),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.transparent, width: 0.750),
                    ),
                    hintText: "TYPE SOMETHING TO SEND...",
                    hintStyle: TextStyle(
                        color: Color.fromARGB(255, 220, 220, 220),
                        fontSize: 12),
                  ),
                  readOnly: true,
                  showCursor: true,
                  maxLines: 3,
                ),
              ),
              SizedBox(
                width: 5,
              ),
              Container(
                width: 50,
                height: 75,
                color: Colors.red,
                child: Column(
                  children: <Widget>[
                    Container(
                      height: 75.0 / 2,
                      color: Colors.grey,
                      child: StreamBuilder<String>(
                        stream: _keyTapBehavior.stream,
                        initialData: null,
                        builder: (_context, _snap) {
                          return Center(
                            child: Text(
                              _snap.data != null ? _snap.data : '',
                              style: TextStyle(
                                  fontSize: 25, fontFamily: AppStyle.fontBold),
                            ),
                          );
                        },
                      ),
                    ),
                    Container(
                      height: 75.0 / 2,
                      child: Material(
                        color: Color.fromARGB(255, 200, 200, 200),
                        child: Ink(
                          child: InkWell(
                            onTap: () {
                              final _visible =
                                  this._keyboardBehavior.value ?? true;
                              this._keyboardBehavior.sink.add(!_visible);
                            },
                            child: Center(
                              child: StreamBuilder<bool>(
                                stream: this._keyboardBehavior.stream,
                                initialData: true,
                                builder: (_context, _snap) {
                                  return Center(
                                    child: Icon(
                                      _snap.data
                                          ? Icons.close
                                          : Icons.keyboard_arrow_up,
                                      color: _snap.data
                                          ? Colors.red
                                          : Colors.green,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        _data
            ? DynamicKeyboardWidget(
                _onKeyPressed,
                doneButtonIcon: Icons.message,
                onKeyDownStart: _onKeyStarted,
                onDeleteLongPressed: _onDeleteEverything,
              )
            : SizedBox(),
      ],
    );
  }

  _onDeleteEverything() {
    this._chatTextController.text = '';
    this._chatTextController.clear();
  }

  _onKeyStarted(String _key) {
    this._keyTapBehavior.sink.add(_key);
  }

  _onKeyPressed(String _key) {
    if (_key.toLowerCase() == 'space') {
      _key = ' ';
    } else if (_key.toLowerCase() == 'done') {
      if (!(_sendingBehavior.value ?? false)) {
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
    if (!success) {}
    _sendingBehavior.sink.add(false);
  }

  Widget _getWidget(final MessageData _data) {
    final _date =
        DateFormat.yMMMEd().add_jms().format(DateTime.parse(_data.dateTime));
    double left = 0;
    double right = 0;
    String _title = _date.toString();
    var _alignment = CrossAxisAlignment.start;
    if (_data.isOutGoing) {
      right = 32;
//      _title = (_data.seen ? 'seen  ' : '') + _title;
    } else {
      left = 32;
      _alignment = CrossAxisAlignment.end;
//      _title = _title + (_data.seen ? '  seen' : '');
    }
    return Padding(
      padding: EdgeInsets.only(bottom: 20, left: 12, right: 12),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: left,
          ),
          Expanded(
            child: Container(
              child: Column(
                crossAxisAlignment: _alignment,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8, top: 4),
                    child: Text(
                      _title,
                      style: TextStyle(fontSize: 11, color: Colors.black54),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Text(_data.message,
                        style: TextStyle(
                            fontSize: 14,
                            height: 1.4,
                            fontWeight: FontWeight.w600)),
                  )
                ],
              ),
              decoration: AppStyle.lightDecoration,
            ),
          ),
          SizedBox(
            width: right,
          ),
        ],
      ),
    );
  }
}
