import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:plasma_bank/app_utils/app_constants.dart';
import 'package:plasma_bank/app_utils/widget_providers.dart';
import 'package:plasma_bank/app_utils/widget_templates.dart';
import 'package:plasma_bank/network/person_handler.dart';
import 'package:plasma_bank/network/message_repository.dart';
import 'package:plasma_bank/network/models/blood_donor.dart';

class MessageListWidget extends StatefulWidget {
  final Function onSelectLogin;
  MessageListWidget(this.onSelectLogin);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MessageListState();
  }
}

class _MessageListState extends State<MessageListWidget> {
  final MessageRepository _messageRepository = MessageRepository();

  Widget _getTitle() {
    return AppBar(
      elevation: 0,
      iconTheme: IconThemeData(
        color: Colors.black,
      ),
      backgroundColor: Colors.transparent,
      leading: Padding(
        padding: const EdgeInsets.only(left: 20),
        child: Icon(
          Icons.mail,
          size: 35,
          color: AppStyle.theme(),
        ),
      ),
      title: Text(
        'MESSAGE BOX',
        style: TextStyle(
            fontSize: 22, fontFamily: AppStyle.fontBold, color: Colors.black),
      ),
      centerTitle: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: displayData.height - displayData.navHeight,
      width: displayData.width,
      child: SafeArea(
        child: Scaffold(
          extendBodyBehindAppBar: true,
          appBar: _getTitle(),
          body: donorHandler.loginEmail == null
              ? Container(
                  width: displayData.width,
                  child: Center(
                    child: SizedBox(
                      width: displayData.width - 48,
                      height: 45,
                      child: RaisedButton(
                        color: AppStyle.theme(),
                        onPressed: _switchEmail,
                        child: Text(
                          'LOGIN TO CHAT',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              : StreamBuilder(
                  stream: _messageRepository.getMessengers(),
                  builder: (_context, _snap) {
                    if (_snap.data != null) {
                      final QuerySnapshot collection = _snap.data;
                      if (collection != null &&
                          collection.documents.isNotEmpty) {
                        final _dataList = collection.documents;
                        return ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: _dataList.length + 1,
                          itemBuilder: (_context, _index) {
                            if (_index == 0) {
                              return Container(
                                height: 16,
                              );
                            }
                            final _mapData = _dataList[_index - 1];
                            final MessageData _data =
                                MessageData.fromMap(_mapData.data, true);
                            return _getPersonRow(_data, _mapData.documentID);
                          },
                        );
                      }
                    }
                    return Center(
                      child: WidgetTemplate.indicator(),
                    );
                  },
                ),
        ),
      ),
    );
  }

  Widget _getPersonRow(final MessageData _message, String _email) {
    final _date =
        DateFormat.yMMMEd().add_jms().format(DateTime.parse(_message.dateTime));
    final double _boxHeight = 95;
    return Padding(
      padding: EdgeInsets.only(bottom: 28, left: 24, right: 24),
      child: Container(
        decoration: AppStyle.listItemDecoration,
        height: _boxHeight,
        child: StreamBuilder(
            stream: _messageRepository.getDonorInfo(_email),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Column(
                  children: <Widget>[
                    SizedBox(
                      height: 8,
                    ),
                    WidgetTemplate.indicator(),
                    Text('information of - '),
                    Text(
                      _email,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppStyle.theme(),
                      ),
                    )
                  ],
                );
              }
              final DocumentSnapshot _docSnap = snapshot.data;
              final BloodDonor _bloodDonor = BloodDonor.fromMap(_docSnap.data);
              return ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                child: Material(
                  child: Ink(
                    child: InkWell(
                      onTap: () {
                        debugPrint("DONT");
                        Navigator.pushNamed(context, AppRoutes.pagePrivateChat,
                            arguments: {'donor': _bloodDonor});
                      },
                      child: Row(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(left: 12, right: 12),
                            child: WidgetTemplate.getProfilePicture(_bloodDonor,
                                proHeight: 60),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                width: displayData.width - 132,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.only(
                                          top: 4, right: 4, bottom: 4),
                                      child: Text(
                                        _date.toString(),
                                        style: TextStyle(
                                            fontSize: 11,
                                            color: Colors.black54),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Text(
                                (_bloodDonor.fullName ?? 'NO NAME')
                                    .toUpperCase(),
                                style: TextStyle(
                                  color: AppStyle.theme(),
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.only(right: 4),
                                  width: displayData.width - 132,
//                          height: _boxHeight - 65,
                                  child: Text(
                                    _message.message ?? 'NO MESSAGE',
                                    softWrap: true,
                                    maxLines: 2,
                                    style: TextStyle(
                                      fontWeight: _message.seen
                                          ? FontWeight.normal
                                          : FontWeight.w600,
                                      color: Colors.black,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                width: displayData.width - 132,
                                height: 20,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    Padding(
                                      padding:
                                          EdgeInsets.only(right: 4, bottom: 4),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(100)),
                                        child: _message.seen
                                            ? SizedBox()
                                            : Container(
                                                width: 15,
                                                height: 15,
                                                color: Colors.green,
                                              ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
      ),
    );
  }

  _switchEmail() {
    this.widget.onSelectLogin();
  }
}
