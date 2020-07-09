import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

class MessageSender {
  final String senderName;
  final String lastMessageDate;
  final bool hasUnreadMessage;
  final String lastMessage;
  final String referenceID;
  final String senderProfileImage;
  MessageSender(
      {this.referenceID,
      this.senderName,
      this.lastMessage,
      this.lastMessageDate,
      this.senderProfileImage,
      this.hasUnreadMessage});
}

class MessageRepository {

  final BehaviorSubject<MessageSender> _senderBehavior = BehaviorSubject();

  dispose() {

    _senderBehavior.close();
  }

  Stream<MessageSender> getStream(){
    return this._senderBehavior.stream;
  }


  readSenderList(){

  }


}
