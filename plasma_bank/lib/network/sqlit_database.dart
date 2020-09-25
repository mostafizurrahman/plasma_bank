import 'package:flutter/cupertino.dart';
import 'package:plasma_bank/network/message_repository.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' show join;

class SqliteDatabase {
  String _tableName;
  String _sender;
  String _receiver;
  Database _database;
  static const int LIMIT = 20;
  int _offset = 0;

  SqliteDatabase(
      final String _email1, final String _email2, final Function _onCompleted) {
    this._sender = _email1;
    this._receiver = _email2;
    final _table1 =
        (_email1 + '_' + _email2).replaceAll("@", "").replaceAll('.', '');
    final _table2 =
        (_email2 + '_' + _email1).replaceAll("@", "").replaceAll('.', '');
    getDatabasesPath().then((_databasePath) {
      String path = join(_databasePath, 'chat.db');
      openDatabase(path).then((value) async {
        this._database = value;
        final _data1 = await this
            ._database
            .rawQuery("SELECT * FROM sqlite_master WHERE name = ?", [_table1]);
        final _data2 = await this
            ._database
            .rawQuery("SELECT * FROM sqlite_master WHERE name = ?", [_table2]);
        if (_data1.length == 1) {
          _tableName = _table1;
        } else if (_data2.length == 1) {
          _tableName = _table2;
        } else {
          _tableName = _table1;
          this
              ._database
              .execute(
                  'CREATE TABLE $_table1 (date_time STRING PRIMARY KEY, message TEXT, sender TEXT, receiver TEXT, out_going INTEGER)')
              .catchError((_error) {
            debugPrint("what the hac" + _error.toString());
          });
        }
        _onCompleted();
      });
    });
  }

  Future<int> insertMessage(MessageData messageData) async {
    assert(_tableName != null, "TABLE NAME FOUND NULL");
    if (_tableName != null && _tableName.isNotEmpty) {
      int count = await this._database.insert(_tableName, {
        'date_time': messageData.dateTime ?? DateTime.now().toString(),
        'message': messageData.message ?? '',
        'sender': messageData.isOutGoing ? _sender : _receiver,
        'receiver': messageData.isOutGoing ? _receiver : _sender,
        'out_going': messageData.isOutGoing ? 1 : 0,
      });
      return count;
    }
    return -1;
  }

  Future<int> updateMessage(MessageData messageData) async {
    assert(_tableName != null, "TABLE NAME FOUND NULL");
    if (_tableName != null && _tableName.isNotEmpty) {
      int count = await this._database.rawUpdate(
          'UPDATE $_tableName SET message = ? WHERE date_time = ?; ',
          [messageData.message, messageData.dateTime]);
      return count;
    }
    return -1;
  }

  Future<List<MessageData>> getMessages() async {
    assert(_tableName != null, "TABLE NAME FOUND NULL");
    List<Map<String, dynamic>> messageList = await this._database.rawQuery(
        "SELECT * FROM $_tableName LIMIT ? OFFSET ?;", [LIMIT, this._offset]);
    this._offset += LIMIT;
    List<MessageData> _messages = List();
    for (var value in messageList) {
      final String message = value['message'];
      final String dateTime = value['date_time'];
      bool isOutGoing = value['out_going'] != 0;
      final _data = MessageData(message, dateTime, isOutGoing);
      _messages.add(_data);
    }
    return _messages;
  }

  Future<int> queueMessage(MessageData _messageData) async {
    assert(_tableName != null, "TABLE NAME FOUND NULL");
    if (_tableName != null && _tableName.isNotEmpty) {
      int count = await this._database.insert(_tableName, {
        'date_time': _messageData.dateTime ?? DateTime.now().toString(),
        'message': _messageData.message ?? '',
        'sender': _sender,
        'receiver': _receiver,
        'out_going': 2,
      });
      return count;
    }
    return -1;
  }

  ///TODO :: FOR OUTGOING 1, PENDING MESSAGES 2, INCOMING 1

}
