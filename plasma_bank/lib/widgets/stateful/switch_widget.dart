import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:plasma_bank/app_utils/app_constants.dart';
import 'package:plasma_bank/app_utils/widget_providers.dart';
import 'package:plasma_bank/app_utils/widget_templates.dart';
import 'package:plasma_bank/network/donor_handler.dart';
import 'package:plasma_bank/network/models/blood_donor.dart';
import 'package:rxdart/rxdart.dart';

class SwitchWidget extends StatefulWidget {
  final Function(String) onSwitched;
  final Function(String) onLogOut;
  final Function onLogin;
  final BloodDonor bloodDonor;
  SwitchWidget(this.onSwitched, this.onLogOut, this.onLogin, this.bloodDonor);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _SwitchState();
  }
}

class _SwitchState extends State<SwitchWidget> {
  final TextConfig _emailConfig = TextConfig('email');

  BehaviorSubject<bool> _logoutBehavior = BehaviorSubject<bool>();
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    if(_logoutBehavior != null){
      _logoutBehavior.close();
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: EdgeInsets.only(left: 24, right: 24, top: 16),
        child: Column(
          children: <Widget>[
            Text(
                'Enter an email address to login. A 6-digit code will be sent to the email. After entering the code account will be logged in automatically!'),
            Padding(
              padding: EdgeInsets.only(top: 8, bottom: 8),
              child: WidgetTemplate.getTextField(
                this._emailConfig,
                maxLen: 32,
                isReadOnly: false,
                showCursor: true,
                validator: (String _value) {
                  if (_value == null || _value.isEmpty) {
                    return null;
                  }
                  bool emailValid = RegExp(
                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                      .hasMatch(_value);
                  return emailValid ? null : 'enter valid email';
                },
              ),
            ),
            SizedBox(
              height: 12,
            ),
            SizedBox(
              width: displayData.width - 48,
              height: 45,
              child: RaisedButton(
                color: AppStyle.theme(),
                onPressed: _switchEmail,
                child: Text(
                  'SEND CODE & VERIFY',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
            StreamBuilder<bool>(
              stream: _logoutBehavior.stream,
              initialData: donorHandler.loginEmail != null,
              builder: (context, snapshot) {
                return snapshot.data ? Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Container(
                        decoration: AppStyle.lightDecoration,
                        height: 99,
                        width: displayData.width - 48,
                        child: Row(
                          children: <Widget>[
                            SizedBox(
                              width: 12,
                            ),
                            _getProfile(),
                            SizedBox(
                              width: 12,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Text(this.widget.bloodDonor.fullName),
                                Text(
                                  this.widget.bloodDonor.emailAddress,
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black54,
                                      height: 1.5),
                                ),
                                Text(
                                  this.widget.bloodDonor.mobileNumber,
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                      height: 1.5),
                                ),
                                Container(

                                  width:
                                  displayData.width - 48 - 99,
//                                color: Colors.grey,
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      Ink(
                                        child: InkWell(
                                          onTap: (){
                                            final _email = this.widget.bloodDonor.emailAddress;
                                            this.widget.onLogOut(_email);
                                            WidgetProvider.loading(context);
                                            Future.delayed(Duration(seconds: 1), (){
                                              Navigator.pop(context);
                                              donorHandler.loginEmail = null;
                                              this._logoutBehavior.sink.add(false);

                                              WidgetTemplate.message(context, 'The donor account of $_email has been logged out successfully!');
                                              Navigator.pop(context);
                                            });
                                          },
                                          child: Icon(
                                            Icons.cancel,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 32,
                      ),
                    ],
                  ),
                ) : SizedBox();
              }
            )
          ],
        ),
      ),
    );
  }

  Widget _getProfile(){
    return Container(
      width: 75,
      height: 75,
      decoration: AppStyle.circularShadow(),
      child: ClipRRect(
        borderRadius:
        BorderRadius.all(Radius.circular(110)),
        child: this.widget.bloodDonor.profilePicture?.imageUrl != null ?
//                            Icon(Icons.person, size: 60,)

        Image(
          image: NetworkImage( this.widget.bloodDonor.profilePicture.imageUrl),
          fit: BoxFit.fitWidth,
        )

            : Icon(Icons.person, size: 55,),
      ),
    );
  }

  _switchEmail() {
    this.widget.onSwitched(this._emailConfig.controller.text);
  }
}
