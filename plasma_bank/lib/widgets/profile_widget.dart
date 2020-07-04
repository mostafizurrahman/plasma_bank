import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:plasma_bank/app_utils/app_constants.dart';
import 'package:plasma_bank/app_utils/widget_providers.dart';
import 'package:plasma_bank/app_utils/widget_templates.dart';
import 'package:plasma_bank/media/dash_painter.dart';
import 'package:plasma_bank/network/models/abstract_person.dart';
import 'package:plasma_bank/network/models/blood_donor.dart';
import 'package:plasma_bank/widgets/base_widget.dart';
import 'package:rxdart/rxdart.dart';

class ProfileWidget extends BaseWidget {
  ProfileWidget(Map arguments) : super(arguments);

  @override
  State<StatefulWidget> createState() {
    return _ProfileState();
  }
}

class _ProfileState extends State<ProfileWidget> {
  final BehaviorSubject<String> _errorBehavior = BehaviorSubject<String>();
  final TextConfig _nameConfig = TextConfig('name');
  final TextConfig _emailConfig = TextConfig('email');
  final TextConfig _phoneConfig = TextConfig('mobile #');
  String profileImage;
  ScrollController _scrollController;
  final BehaviorSubject<String> _profileBehavior = BehaviorSubject();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController = new ScrollController(
      initialScrollOffset: 0.0,
      keepScrollOffset: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final _paddingBottom = MediaQuery.of(context).padding.bottom;
    final _paddingTop = MediaQuery.of(context).padding.top;
    final _appBarHeight = 54;
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;
    final _contentHeight =
        _height - _paddingBottom - _paddingTop - _appBarHeight;
    final double ratio = 0.35;
    return Container(
      color: AppStyle.greyBackground(),
      child: Padding(
        padding: EdgeInsets.only(bottom: _paddingBottom),
        child: Scaffold(
          appBar: WidgetProvider.appBar('Profile'),
          body: Padding(
            padding: EdgeInsets.only(left: 24, right: 24),
            child: Column(
              children: [
                Container(
                  height: 400,
//              color: Colors.grey,
                  child: SingleChildScrollView(
                    controller: this._scrollController,
                    child: Container(
                      height: 600,
//                  color: Colors.cyan,
                      child: Column(
                        children: [
                          Container(
                            width: _width,
                            height: _width * ratio + AppStyle.PADDING * 1.25,
                            color: Colors.transparent,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Center(
                                    child: Container(
                                      decoration: AppStyle.circularShadow(),
                                      child: ClipRRect(
                                        child: StreamBuilder<String>(
                                          stream: _profileBehavior.stream,
                                          initialData: this.profileImage,
                                          builder: (context, snapshot) {
                                            return snapshot.data == null
                                                ? Container(
                                                    width: _width * ratio,
                                                    height: _width * ratio,
                                                    child: new Material(
                                                      child: new InkWell(
                                                        onTap: _openCamera,
                                                        child: new Center(
                                                          child: Container(
                                                            height: 80,
                                                            width: 150,
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Icon(
                                                                  Icons.person,
                                                                  size: 50,
                                                                ),
                                                                Text('PICTURE')
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      color: Colors.transparent,
                                                    ),
                                                  )
                                                : _getProfileImage(
                                                    snapshot.data, _width * ratio);
                                          },
                                        ),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(_width)),
                                      ),
                                    ),
                                  ),
                                ),
                                CustomPaint(
                                  size:
                                      Size(MediaQuery.of(context).size.width, 1.0),
                                  painter: DashLinePainter(),
                                ),
                              ],
                            ),
                          ),
                          WidgetTemplate.getTextField(
                            this._nameConfig,
                            maxLen: 32,
                            isReadOnly: false,
                            showCursor: true,
                            onTap: () {
                              this._errorBehavior.sink.add('');
                            },
                          ),
                          WidgetTemplate.getTextField(
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
                            onTap: () {
                              this._errorBehavior.sink.add('');
                              _animateTextFields();
                            },
                            onEditingDone: () {
                              _animateTextFields(isHide: true);
                            },
                          ),
                          WidgetTemplate.getTextField(
                            this._phoneConfig,
                            maxLen: 15,
                            isReadOnly: false,
                            isDigit: true,
                            showCursor: true,
                            onTap: () {
                              this._errorBehavior.sink.add('');
                              _animateTextFields();
                            },
                            onEditingDone: () {
                              _animateTextFields(isHide: true);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      StreamBuilder(
                        initialData: '',
                        builder: (_context, _snap){
                          return Text(
                            _snap.data,
                            style: TextStyle(
                              color: AppStyle.theme(),
                            ),
                          );
                        },
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: WidgetProvider.button(
            _saveProfile,
            "NEXT",
            context,
          ),
        ),
      ),
    );
  }

  Widget _getProfileImage(final String _imagePath, final double _dimension) {
    return Container(
      width: _dimension,
      height: _dimension,
      child: new Material(
        child: new InkWell(
          onTap: _openCamera,
          child: Image.file(
            File(_imagePath),
            fit: BoxFit.fitWidth,
          ),
        ),
        color: Colors.transparent,
      ),
    );
  }

  _openCamera() {
    if(!this.skipTouch ){
      this.skipTouch = true;
      final arguments = {
        'is_front_camera': true,
        'on_captured_function': _onCaptured,
      };
      Navigator.pushNamed(context, AppRoutes.pageRouteCamera,
          arguments: arguments);
      Future.delayed(Duration(seconds: 1),(){
        this.skipTouch = false;
      });
    }
  }

  _animateTextFields({isHide = false}) {
    if (isHide) {
      FocusScope.of(context).requestFocus(FocusNode());
      Future.delayed(
        Duration(seconds: 1),
        () {
          _scrollController.animateTo(0.0,
              duration: Duration(milliseconds: 500), curve: Curves.ease);
        },
      );
    } else {
      if (this._scrollController.offset == 0.0) {
        Future.delayed(Duration(seconds: 1), () {
          _scrollController.animateTo(200.0,
              duration: Duration(milliseconds: 500), curve: Curves.ease);
        });
      }
    }
  }

  _onCaptured(final String imagePath) async {
    await FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
    this.profileImage = imagePath;
    this._profileBehavior.sink.add(imagePath);
  }

  bool skipTouch = false;

  _saveProfile() {
    if(!this.skipTouch ){
      this.skipTouch = true;
      debugPrint('save profile');
      _animateTextFields(isHide: true);
      Future.delayed(Duration(seconds: 1),(){

        final String _name = this._nameConfig.controller.text;
        final String _email = this._emailConfig.controller.text;
        final String _mobile = this._phoneConfig.controller.text;
        if(_name.isEmpty){
          this._errorBehavior.sink.add('name is empty');
        } else if (_email.isEmpty){
          this._errorBehavior.sink.add('email is empty');
        } else if (_mobile.isEmpty){
          this._errorBehavior.sink.add('mobile number is empty');
        } else {

          final Address _address = this.widget.getData('address'); 
          final BloodDonor bloodDonor = BloodDonor.fromMap(map)

          
        }

        this.skipTouch = false;
      });
    }
//    this._emailConfig.controller.notifyListeners();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    if (_errorBehavior != null && !_errorBehavior.isClosed) {
      _errorBehavior.close();
    }
    if (_profileBehavior != null && !_profileBehavior.isClosed) {
      _profileBehavior.close();
    }
  }
}
