import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:plasma_bank/network/donor_handler.dart';
import 'package:rxdart/rxdart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:plasma_bank/app_utils/app_constants.dart';

class MessageData {
  String dateTime;
  bool seen;
  String message;
  bool isOutGoing;
  bool shouldInsert;
  bool isUpdated;

  MessageData.fromMap(Map<dynamic, dynamic> map, bool isOutGoingMessage) {
    this.isOutGoing = isOutGoingMessage;
    this.dateTime = map['date_time'];
    this.message = map['message'];
    this.shouldInsert = map['insert'] ?? true;
    this.seen = map['insert'] ?? true ;
    debugPrint(map['insert'].toString());
    this.isUpdated = map['updated'] ?? false;
  }
  MessageData(this.message, this.dateTime, this.isOutGoing,
      {this.seen = false, this.shouldInsert = false, this.isUpdated = false});
}

class MessageRepository {
  DocumentReference _inComingMessageDoc;
  DocumentReference _outGoingMessageDoc;
  final BehaviorSubject<MessageData> _senderBehavior = BehaviorSubject();

  dispose() {
    _senderBehavior.close();
    _inComingMessageDoc = null;
    _outGoingMessageDoc = null;
  }

  Stream<MessageData> getStream() {
    return this._senderBehavior.stream;
  }

  MessageRepository();

  MessageRepository.fromMail(final String _receiver) {
    final String _loginEmail = donorHandler.loginEmail;
    _outGoingMessageDoc = Firestore.instance
        .collection('donor')
        .document(_loginEmail)
        .collection('messages')
        .document(_receiver);

    _inComingMessageDoc = Firestore.instance
        .collection('donor')
        .document(_receiver)
        .collection('messages')
        .document(_loginEmail);
  }

  Stream<DocumentSnapshot> getInComingStream() {
    return _inComingMessageDoc.snapshots();
  }

  Stream<DocumentSnapshot> getOutGoingStream() {
    return _outGoingMessageDoc.snapshots();
  }

  Stream<DocumentSnapshot> getDonorInfo(final String _email) {
    return Firestore.instance
        .collection('donor')
        .document(_email).snapshots();
  }

  Stream<QuerySnapshot> getMessengers(){

    return Firestore.instance
        .collection('donor')
        .document(donorHandler.loginEmail)
        .collection('messages').snapshots();
  }


  sendMessage(final _email, final _message, Function(bool) _onSent) async {

    final String _date = DateTime.now().toLocal().toString();
    _outGoingMessageDoc.get().then((value){
      if(value.exists) {
        final bool isSeen = value.data['seen'];
        if(isSeen){
          _sendMessage(_email, _message, false, _onSent,_date);
        } else {
          final String _msg =  value.data['message'] + ' ' + _message;
          final String _time = value.data['date_time'];
          _sendMessage(_email, _msg, true, _onSent, _time);
        }
      } else {
        _sendMessage(_email, _message, false, _onSent,_date);
      }
    });



  }

  _sendMessage(final _email, final _message, final _update, final _onSent, final _date){
    _outGoingMessageDoc.setData({
      'seen': false,
      'message': _message,
      'date_time': _date,
      'insert': true,
      'updated' : _update,
    }).then((value) {
      _onSent(true);
    }).catchError((_error){
      _onSent(false);
    });
  }

  updateOutGoingStatus() {
    _outGoingMessageDoc.updateData({'insert': false});
  }

  updateIncomingStatus() {
    _inComingMessageDoc.updateData({'insert': false, 'seen': true, 'updated' : false});
  }

//  getMessage(final String _loginEmail, final String _receiverEmail){
//    this._documentCollection =
//  }

}
