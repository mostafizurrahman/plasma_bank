

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:plasma_bank/app_utils/app_constants.dart';
import 'package:plasma_bank/app_utils/widget_templates.dart';

class SwitchWidget extends StatefulWidget {

  final Function(String) onSwitched;
  final Function(String) onLogOut;

  SwitchWidget(this.onSwitched, this.onLogOut);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _SwitchState();
  }

}

class _SwitchState extends State<SwitchWidget>{
  final TextConfig _emailConfig = TextConfig('email');

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: Colors.transparent,
      body: Padding(
        padding: EdgeInsets.only(left: 24, right: 24, top: 16),
        child: Column(
          children: <Widget>[
            Text(
              'Enter an email address to login. A 6-digit code will be sent to the email. After entering the code account will be logged in automatically!'
            ),
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
            SizedBox(height: 12,),
            SizedBox(
              width: MediaQuery.of(context).size.width - 48,
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
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Container(
                    decoration: AppStyle.shadowDecoration,
                    height: 99,
                    width: MediaQuery.of(context).size.width - 48,
                    child: Row(
                      children: <Widget>[
                        SizedBox(width: 12,),
                        Container(
                          width: 75,
                          height: 75,
                          decoration: AppStyle.circularShadow(),
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(110)),
                            child: Image(image: NetworkImage('https://i.imgur.com/oCb2p45.jpeg'), fit: BoxFit.fitWidth,),
                          ),
                        ),
                        SizedBox(width: 12,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Text('MOSTAFIZUR RAHMAN'),
                            Text('mostafizur.cse@gmail.com', style: TextStyle(fontSize: 12, color: Colors.black54, height: 1.5),),
                            Text('++8801675876752', style: TextStyle(fontSize: 12, color: Colors.grey, height: 1.5),),
                            Container(


                                width: MediaQuery.of(context).size.width - 48 - 99,
//                                color: Colors.grey,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    Icon(Icons.cancel, color: Colors.red,),
                                  ],
                                ),
                            )

                          ],
                        ),
//                        Expanded(
//                          child: Row(
//                            mainAxisAlignment: MainAxisAlignment.end,
//                            children: <Widget>[
//                              SizedBox(
//                                width: 50,
//                                height: 50,
//                                child: Container(
//                                  child: Text('LOG OUT'),
//                                ),
//                              )
//                            ],
//                          ),
//                        )

                      ],
                    ),

                  ),
                  SizedBox(height: 32,),
                ],
              ),

            )
          ],
        ),
      ),

    );
  }

  _switchEmail(){
    this.widget.onSwitched(this._emailConfig.controller.text);
  }
}