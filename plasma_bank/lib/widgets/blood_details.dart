import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:plasma_bank/app_utils/app_constants.dart';
import 'package:plasma_bank/app_utils/widget_providers.dart';
import 'package:plasma_bank/app_utils/widget_templates.dart';
import 'package:plasma_bank/network/firebase_repositories.dart';
import 'package:plasma_bank/network/imgur_handler.dart';
import 'package:plasma_bank/network/models/abstract_person.dart';
import 'package:plasma_bank/network/person_handler.dart';
import 'package:url_launcher/url_launcher.dart';

class BloodDetails extends StatefulWidget {
  final BloodInfo bloodInfo;
  BloodDetails(this.bloodInfo);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _BloodDetailsState();
  }
}

class _BloodDetailsState extends State<BloodDetails> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          body: Column(
            children: <Widget>[
              WidgetProvider.getCustomAppBar(
                  context, widget.bloodInfo.bloodGroup,  ' BLOOD ${widget.bloodInfo.isDonor ? 'AVAILABLE' : 'REQUIRED'}'),
              Padding(
                padding: EdgeInsets.only(left: 24, right: 24),
                child: Container(
                  width: displayData.width - 48,
//              color: Colors.red,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: 24,
                      ),
                      Row(
                        children: <Widget>[
                          ClipRRect(
                            borderRadius:
                                BorderRadius.all(Radius.circular(110)),
                            child: Container(
                              width: 65,
                              height: 65,
                              child: widget.bloodInfo.clientPicture != null
                                  ? WidgetTemplate.getImageWidget(
                                      response: ImgurResponse.fromThumb(
                                          widget.bloodInfo.clientPicture))
                                  : Container(
                                    width: 50,
                                    height: 50,
                                    decoration: AppStyle.circleBorder(),
                                    child: Center(
                                      child: Text(
                                        widget.bloodInfo.clientName
                                            .substring(0, 1)
                                            .toUpperCase(),
                                        style: TextStyle(
                                          fontSize: 28,
                                          fontWeight: FontWeight.w900,
                                          color: AppStyle.theme(),
                                        ),
                                      ),
                                    ),
                                  ),
                            ),
                          ),
                          SizedBox(
                            width: 12,
                          ),
                          Expanded(
                            child: this.widget.bloodInfo.bloodGroup == null ? _getSeekerDescription() :
                            this.widget.bloodInfo.injectionDate == null ? _getBloodDonorDescription() : _getRequestDescription(),

//                        Text(
//                          '${} is looking for  ${widget.bloodInfo.bloodGroup} bloods. If you are interested to assist him, then please! respond to him/her.'
//                        ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 24,
                      ),
                      Container(
                        decoration: AppStyle.getLightBox(),
                        width: displayData.width - 48,
                        height: 60,
                        child: Row(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(
                                left: 16,
                              ),
                              child: Text(
                                'M : ',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                this.widget.bloodInfo.clientMobile,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 1.15,
                                  color: AppStyle.theme(),
                                ),
                              ),
                            ),
                            WidgetProvider.getMaterialButton(
                                () => _makePhoneCall(
                                    widget.bloodInfo.clientMobile),
                                Icons.phone),
                            SizedBox(
                              width: 8,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 24,
                      ),
                      Container(
                        decoration: AppStyle.getLightBox(),
                        width: displayData.width - 48,
                        height: 60,
                        child: Row(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(
                                left: 16,
                              ),
                              child: Text(
                                'E : ',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                this.widget.bloodInfo.clientEmail,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 1.15,
                                  color: AppStyle.theme(),
                                ),
                              ),
                            ),
                            WidgetProvider.getMaterialButton(
                                () => _makeEmailCall(
                                    widget.bloodInfo.clientEmail),
                                Icons.mail),
                            SizedBox(
                              width: 8,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 24,
                      ),
                      Container(
                        decoration: AppStyle.getLightBox(),
                        width: displayData.width - 48,
                        height: 60,
                        child: Row(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(
                                left: 16,
                              ),
                              child: Text(
                                'Chat with ',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                this.widget.bloodInfo.clientName.toUpperCase(),
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 1.15,
                                  color: AppStyle.theme(),
                                ),
                              ),
                            ),
                            WidgetProvider.getMaterialButton(
                                _makeChatCall, Icons.chat),
                            SizedBox(
                              width: 8,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _makeEmailCall(String _emailID) async {
    final Uri params = Uri(
      scheme: 'mailto',
      path: _emailID,
    );
    String url = params.toString();
    if (await canLaunch('mailto://$_emailID')) {
      await launch(url);
    } else {
      print('Could not launch $url');
    }
  }

  _makePhoneCall(String _mobileNumber) {
    launch("tel://$_mobileNumber");
  }

  _makeChatCall() async {
    WidgetProvider.loading(context);
    final _repository = FirebaseRepositories();
    final _emailID = this.widget.bloodInfo.clientEmail;
    if (_emailID == donorHandler.loginEmail) {
      Navigator.pop(context);
      WidgetTemplate.message(context, 'you have posted this blood request!');
    } else {
      Person _person = await _repository.getDonorData(_emailID);
      if (_person == null) {
        _person = await _repository.getCollectorData(_emailID);
      }
      if (_person != null) {
        Future.delayed(Duration(seconds: 1), () {
          Navigator.pop(context);
          Navigator.pushNamed(context, AppRoutes.pagePrivateChat,
              arguments: {'donor': _person});
        });
      } else {
        Navigator.pop(context);
        WidgetTemplate.message(context,
            'the person information could not be found or who has requested the blood does not found right now.');
      }
    }
  }

  Widget _getRequestDescription(){
    return RichText(
      text: TextSpan(
        children: <TextSpan>[
          TextSpan(
            text: widget.bloodInfo.clientName
                .toUpperCase(),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppStyle.theme(),
            ),
          ),
          TextSpan(
            text: '\nis looking for ',
            style: TextStyle(
              fontSize: 13,
//                                      fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          TextSpan(
            text: '${widget.bloodInfo.bloodBags}',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppStyle.theme(),
            ),
          ),
          TextSpan(
            text: ' bags of ',
            style: TextStyle(
              fontSize: 13,
//                                      fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          TextSpan(
            text: widget.bloodInfo.bloodGroup,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppStyle.theme(),
            ),
          ),
          TextSpan(
            style: TextStyle(
              fontSize: 13,
//                                      fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
            text:
            ' bloods. If you are interested to assist him, then please! respond to him/her.',
          ),
        ],
      ),
    );
  }

  Widget _getSeekerDescription(){
    return RichText(
      text: TextSpan(
        children: <TextSpan>[
          TextSpan(
            text: widget.bloodInfo.clientName
                .toUpperCase(),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppStyle.theme(),
            ),
          ),
          TextSpan(
            text: '\nis looking for blood. He lives in ',
            style: TextStyle(
              fontSize: 13,
//                                      fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          TextSpan(
            text: '${widget.bloodInfo.hospitalAddress.toString()}.',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppStyle.theme(),
            ),
          ),
          TextSpan(
            text: ' you can contact him, if you are willing to donate blood.',
            style: TextStyle(
              fontSize: 13,
//                                      fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget  _getBloodDonorDescription(){
    return RichText(
      text: TextSpan(
        children: <TextSpan>[
          TextSpan(
            text: widget.bloodInfo.clientName
                .toUpperCase(),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppStyle.theme(),
            ),
          ),
          TextSpan(
            text: '\nis willing to donate blood near the address :  ',
            style: TextStyle(
              fontSize: 13,
//                                      fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          TextSpan(
            text: '${widget.bloodInfo.hospitalAddress.toString()}.',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppStyle.theme(),
            ),
          ),
          TextSpan(
            text: ' you can contact him, if you are searching for ${widget.bloodInfo.bloodGroup} blood.',
            style: TextStyle(
              fontSize: 13,
//                                      fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
