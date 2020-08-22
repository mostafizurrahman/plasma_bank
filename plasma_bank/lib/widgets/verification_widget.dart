import 'dart:async';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:plasma_bank/app_utils/app_constants.dart';
import 'package:plasma_bank/app_utils/widget_providers.dart';
import 'package:plasma_bank/app_utils/widget_templates.dart';
import 'package:plasma_bank/network/donor_handler.dart';
import 'package:plasma_bank/widgets/stateful/keyboard_widget.dart';
import 'package:rxdart/rxdart.dart';

class VerificationWidget extends StatefulWidget {
  final String emailAddress;
  final Function resendCode;
  final Function onCodeVerified;
  VerificationWidget(this.emailAddress, this.onCodeVerified, this.resendCode);

  @override
  State<StatefulWidget> createState() {
    return _VerificationState();
  }
}

class _VerificationState extends State<VerificationWidget> {
  int _selectedBoxIndex = 0;
  List<String> _otpDigits = List.generate(6, (i) => '');
  BehaviorSubject _keyboardBehavior = BehaviorSubject<bool>();
  BehaviorSubject _otpBoxBehavior = BehaviorSubject<int>();

  @override
  void initState() {
    super.initState();

//    Future.delayed(Duration(microseconds: 200), this.startTimer);
  }

  @override
  void dispose() {
    super.dispose();
    if (_keyboardBehavior != null) {
      _keyboardBehavior.close();
    }

    if (_otpBoxBehavior != null) {
      _otpBoxBehavior.close();
    }
  }

//  Future<bool> _onPop() async {
//    if(this._timeCounter > 0){
//      MsgUtils.showPopupDecisionMsg(context, localization.getValue('OTP_BACK_HDR'), localization.getValue('OTP_BACK_MSG'), positive: (){
//        Navigator.pop(context);
//      });
//      return Future<bool>.value(false);
//    }
//    return Future<bool>.value(true);
//  }

  @override
  Widget build(BuildContext context) {
    final String otpBodyMsg =
        '6-digit verification code has been sent to email address _ for login verification.';
    return Container(
      color: Colors.white,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Padding(
          padding: EdgeInsets.only(left: 24, right: 24, top: 12),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 32),
                child: RichText(
                  textAlign: TextAlign.left,

                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: otpBodyMsg.split("_")[0],
                        style: TextStyle(fontSize: 13, color: Colors.black54, height: 1.3),
                      ),
                      TextSpan(
                        text: this.widget.emailAddress,
                        style: TextStyle(
                            color: Colors.black87,
                            fontSize: 14,
                            fontWeight: FontWeight.bold, height: 1.3),
                      ),
                      TextSpan(
                        text: otpBodyMsg.split("_")[1],
                        style: TextStyle(fontSize: 13, color: Colors.black54, height: 1.3),
                      ),
                    ],
                  ),
                ),
              ),

              //OTP boxes
              Padding(
                padding: EdgeInsets.only(top: 8, bottom: 16),
                child: StreamBuilder(
                  initialData: 0,
                  stream: this._otpBoxBehavior.stream,
                  builder: (_context, _data) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: _getTextBoxList(_data.data),
                    );
                  },
                ),
              ),
              _getResendOTPWidget(),
            ],
          ),
        ),
        floatingActionButton: SizedBox(
          width: displayData.width - 48,
          height: 45,
          child: RaisedButton(
            color: AppStyle.theme(),
            onPressed: _verifyOTP,
            child: Text(
              'VERIFY EMAIL & LOGIN',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        bottomNavigationBar: StreamBuilder(
          stream: _keyboardBehavior.stream,
          initialData: true,
          builder: (_context, _snap) {
            return _snap.data ? KeyboardWidget(this._onKeyPressed) : SizedBox();
          },
        ),
      ),
    );
  }

  _onKeyPressed(final String inputKey) {
    debugPrint(inputKey);
    if (inputKey == 'd') {
      this._keyboardBehavior.sink.add(false);
    } else if (inputKey == 'x') {
      this._otpDigits[this._selectedBoxIndex] = '';
      if (this._selectedBoxIndex > 0) {
        this._selectedBoxIndex--;
      }
      this._otpBoxBehavior.sink.add(this._selectedBoxIndex);
    } else if (this._selectedBoxIndex < 6) {
      this._otpDigits[this._selectedBoxIndex] = inputKey;
      this._selectedBoxIndex++;
      if (this._selectedBoxIndex == 6) {
        --this._selectedBoxIndex;
      }
      this._otpBoxBehavior.sink.add(this._selectedBoxIndex);
    }
  }

  List<Padding> _getTextBoxList(final int _selectedIndex) {
    List<Padding> list = new List();

    for (int i = 0; i < 6; i++) {
      final _otpContainer = Padding(
        padding: EdgeInsets.fromLTRB(0, 0, i == 5 ? 0 : 12, 0),
        child: Container(
          width: 38,
          height: 38,
          decoration: new BoxDecoration(
            boxShadow: _selectedIndex == i
                ? [
                    BoxShadow(
                        color: AppStyle.theme().withAlpha(150),
                        blurRadius: 4,
                        spreadRadius: 0.75)
                  ]
                : null,
            color: Colors.white,
            border: Border.all(
                width: 0.75,
                color: _selectedIndex == i
                    ? AppStyle.theme().withAlpha(200).withOpacity(0.5)
                    : Colors.grey),
            borderRadius: new BorderRadius.all(const Radius.circular(5.0)),
          ),
          child: new Center(
            child: new Container(
              child: new Material(
                child: new InkWell(
                  onTap: () {
                    if (!(this._keyboardBehavior.value ?? false)) {
                      this._keyboardBehavior.sink.add(true);
                    }
                    this._otpBoxBehavior.sink.add(i);
                    this._selectedBoxIndex = i;
                  },
                  child: new Center(
                    child: new Text(
                      this._otpDigits[i],
                      style: TextStyle(fontSize: 24),
                    ),
                  ),
                ),
                color: Colors.transparent,
              ),
              color: Colors.transparent,
            ),
          ),
        ),
      );
      list.add(_otpContainer);
    }
    return list;
  }

  Widget _getResendOTPWidget() {
    return Container(
      height: 40,
      child: FlatButton(
        onPressed: this.widget.resendCode,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.refresh,
              color: AppStyle.theme(),
              size: 16,
            ),
            SizedBox(
              width: 5.5,
            ),
            Text(
              'RESEND VERIFICATION CODE',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppStyle.theme(),
                decoration: TextDecoration.underline,
              ),
            ),
          ],
        ),
      ),
    );
  }







  _verifyOTP() async {
    WidgetProvider.loading(context);
    String _otp = "";
    for (String otp in this._otpDigits) {
      _otp += otp;
    }
    if (_otp.length == 6 && donorHandler.verifyIDF(_otp)) {
      this.widget.onCodeVerified();
      Future.delayed(Duration(microseconds: 300), (){
        Navigator.pop(context);
      });
    } else {
      Navigator.pop(context);
      Future.delayed(Duration(microseconds: 300), (){
        WidgetTemplate.message(context,
            'Please! Check the verification code sent to '
                +  this.widget.emailAddress ?? 'email'
                + ', enter all digits properly.');
      });


    }
  }

}
