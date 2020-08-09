import 'dart:async';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:plasma_bank/app_utils/app_constants.dart';
import 'package:plasma_bank/widgets/stateful/keyboard_widget.dart';
import 'package:rxdart/rxdart.dart';

class VerificationWidget extends StatefulWidget {
  final String emailAddress;
  VerificationWidget(this.emailAddress);

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
          width: MediaQuery.of(context).size.width - 48,
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
        onPressed: () {
          _sendOTP();
        },
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

  _onOTPError(final _error) {
//    this._isOTPRequested = false;
//    this._otpCountBehavior.sink.add(0);
    Navigator.pop(context);
    Future.delayed(Duration(milliseconds: 150), () {
//      MsgUtils.showPopupMsg(
//          context, "", localization.getValue('OTP_SEND_UNABLE'));
    });
  }

  _onOTPReadError(final _error) {
//    MsgUtils.showPopupMsg(context, "", "Something went wrong!");
  }

  _sendOTP() async {
//    final int _waitCount = await DatabaseUtils.updateResendOTPCount(
//        this.widget.addMoneyInfo.mobileNumber);
//    if (_waitCount > 0) {
//      this.waitTimerDialog =
//          WaitTimerDialog(_waitCount, () => Navigator.pop(context));
//      await WidgetHelper.displayLockTimer(waitTimerDialog, context);
//    } else {
//      this._isOTPRequested = true;
//      if (_timer.isActive) {
//        _timer.cancel();
//      }
//      if (Platform.isAndroid &&
//          this.widget.addMoneyInfo.otpData.isAutoReadActive) {
//        _readOTPAutomatically();
//      }
//      MsgUtils.openLoadingDialog(context);
//      final _otpRequest = AddMoneyOtpRequest();
//      _otpRequest.mobileNo = this.widget.addMoneyInfo.mobileNumber;
//      _otpRequest.packageName = userInfo.deviceInformation.packageName;
//      _otpRequest.event = this.widget.addMoneyInfo.otpData.eventName;
//      final _fundController = BankTransferControllerApi();
//      _fundController
//          .requestAddMoneyOTP(_otpRequest)
//          .then(_onOTPSend)
//          .catchError(_onOTPError);
//    }
  }

  _onOTPRead(final String _otpString) {
    if (context != null && mounted && 6 == _otpString.length) {
      this._selectedBoxIndex = 0;
      for (int i = 0; i < 6; i++) {
        final _otp = _otpString[i];
        this._otpDigits[this._selectedBoxIndex] = _otp;
        this._selectedBoxIndex++;
        if (this._selectedBoxIndex < 6) {
          this._otpBoxBehavior.sink.add(this._selectedBoxIndex);
        } else {
          this._otpBoxBehavior.sink.add(this._selectedBoxIndex - 1);
        }
      }
      _verifyOTP();
    } else {
      _readOTPAutomatically();
    }
  }

  _readOTPAutomatically() async {
    final _randTime = Random(10000).nextDouble();
    final _methodChannel = MethodChannel('flutter.surecash.com.smschannel');
    _methodChannel
        .invokeMethod('getLoginOTP', _randTime)
        .then(_onOTPRead)
        .catchError(_onOTPReadError);
  }

  _verifyOTP() async {
    String _otp = "";
    for (String otp in this._otpDigits) {
      _otp += otp;
    }

    if (_otp.length == 6) {
//      final _otpVerifyRequest = OtpVerifyRequest();
//      _otpVerifyRequest.code = _otp;
//      _otpVerifyRequest.mobileNo = this.widget.addMoneyInfo.mobileNumber;
//      _otpVerifyRequest.event = this.widget.addMoneyInfo.otpData.eventName;
//      _otpVerifyRequest.account = this.widget.addMoneyInfo.bankAccountNumber;
//
//      MsgUtils.openLoadingDialog(context);
//      final _fundController = BankTransferControllerApi();
//      _fundController
//          .verifyOTP(_otpVerifyRequest)
//          .then(_onOTPVerified)
//          .catchError(_onOTPVerifyFail);
    } else {
//      MsgUtils.showPopupMsg(
//          context,
//          "",
//          localization.shouldUseBangla
//              ? "অসম্পূর্ণ OTP দেওয়া হয়েছে, দয়া করে সকল OTP ডিজিট গুলো প্রদান করুন"
//              : "OTP is incomplete. Please enter all OTP digits.");
    }
  }

  _onOTPVerified(final _value) async {
//    this._timer.cancel();
//    final _decoded = json.decode(_value);
//    final _refId = _decoded["refId"];
//    this.widget.addMoneyInfo.otpData.referenceID = _refId;
//    if (this.widget.addMoneyInfo.bankAlreadyAdded) {
//      Navigator.pop(context);
//      Future.delayed(Duration(milliseconds: 100), () {
//        Navigator.pushNamed(context, AppRoutes.addMoneyAmount,
//            arguments: this.widget.addMoneyInfo);
//      });
//    } else {
//      this.widget.addMoneyInfo.otpData.otpVerified = true;
//      this._timer.cancel();
//      final _addBankRequest = AddBankAccountRequest();
//      _addBankRequest.bank = "fsibl";
//      _addBankRequest.mfsBank = 'fsibl';
//      _addBankRequest.channel = userInfo.channel;
//      _addBankRequest.accessKey = _refId;
//      _addBankRequest.mobile = widget.addMoneyInfo.mobileNumber;
//      _addBankRequest.account = widget.addMoneyInfo.bankAccountNumber;
//      _addBankRequest.accountName = widget.addMoneyInfo.bankAccountName;
//      _addBankRequest.nid = widget.addMoneyInfo.nidNumber;
//      _addBankRequest.doB = widget.addMoneyInfo.dateOfBirth;
//      _addBankRequest.walletType = 'Customer';
//
//      final _fundController = BankTransferControllerApi();
//      final _addBankResponse = await _fundController
//          .addBankAccount(_addBankRequest)
//          .catchError((_error) {
//        return null;
//      });
//      Navigator.pop(context);
//      if (_addBankResponse != null) {
//        Future.delayed(Duration(milliseconds: 150), () {
//          Navigator.pushNamed(context, AppRoutes.addMoneyAmount,
//              arguments: this.widget.addMoneyInfo);
//        });
//      }
//    }

    debugPrint("error_occurred");
  }

  _onOTPVerifyFail(final _error) async {
//    Navigator.pop(context);
//    if(_error.message.toString().toLowerCase().contains('nvalid otp code provided')){
//      await DatabaseUtils.updateWrongOTPCount(this.widget.addMoneyInfo.mobileNumber);
//    }
//    Future.delayed(Duration(milliseconds: 100), () {
//      if (_error.message.contains("Max Try Exceeded")) {
//        DatabaseUtils.setTimeLock(this.widget.addMoneyInfo.mobileNumber, false);
//        if (this._timer.isActive) {
//          this._timer.cancel();
//        }
//        MsgUtils.showPopupMsg(context, localization.getValue('OTP_WRONG_HDR'),
//            localization.getValue('OTP_TIMEOUT_MSG'), callBack: () {
//              Navigator.pop(context);
//            });
//        return;
//      } else if (_error.code == 404){
//        MsgUtils.showPopupMsg(
//          context,"",'No Internet',);
//      } else {
//        MsgUtils.showPopupMsg(
//          context,
//          localization.getValue('OTP_WRONG_HDR'),
//          localization.getValue('OTP_WRONG_MSG'),
//        );
//      }
//
//    });
  }
}
