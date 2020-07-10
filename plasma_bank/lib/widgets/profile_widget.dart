import 'dart:io';
import 'package:app_settings/app_settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:plasma_bank/app_utils/app_constants.dart';
import 'package:plasma_bank/app_utils/widget_templates.dart';
import 'package:plasma_bank/media/dash_painter.dart';
import 'package:plasma_bank/widgets/base/base_state.dart';
import 'package:plasma_bank/widgets/base_widget.dart';
import 'package:rxdart/rxdart.dart';

class ProfileWidget extends BaseWidget {
  ProfileWidget(Map arguments) : super(arguments);

  @override
  State<StatefulWidget> createState() {
    return _ProfileState();
  }
}

class _ProfileState extends BaseKeyboardState<ProfileWidget> {
  final TextConfig _nameConfig = TextConfig('name');
  final TextConfig _emailConfig = TextConfig('email');
  final TextConfig _phoneConfig = TextConfig('mobile #');

  String profileImage;
  final BehaviorSubject<String> _profileBehavior = BehaviorSubject();

  @override
  void initState() {
    super.initState();
    this._nameConfig.controller.text = 'mostafizur rahman';
    this._emailConfig.controller.text = 'mostafizur.cse@gmail.com';
    this._phoneConfig.controller.text = '01675876752';
  }

  @override
  Widget build(BuildContext context) {
    return super.build(context);
  }

  Widget _getProfileImage(final String _imagePath, final double _dimension) {
    final _imageWidget = Image.file(
      File(_imagePath),
      fit: BoxFit.fitWidth,
    );
    _imageWidget.image.evict();
    return Container(
      width: _dimension,
      height: _dimension,
      child: new Material(
        child: new InkWell(
          onTap: _openCamera,
          child: _imageWidget,
        ),
        color: Colors.transparent,
      ),
    );
  }

  _openCamera() async {

    var _status = await Permission.camera.status;
    if(_status.isGranted || _status.isUndetermined){
      this.skipTouch = true;
      final arguments = {
        'image_named': 'profile',
        'is_front_camera': true,
        'on_captured_function': _onCaptured,
        'route_name': AppRoutes.pagePersonData,
      };
      Navigator.pushNamed(context, AppRoutes.pageRouteCamera,
          arguments: arguments);
      Future.delayed(
        Duration(seconds: 1),
            () {
          this.skipTouch = false;
        },
      );
    } else {
      WidgetTemplate.message(context,
          'camera permission is denied. please, go to app settings and grant the camera permission',
          actionIcon: Icon(Icons.settings, color: Colors.white,),
          onActionTap: this._onCameraDenied,
          actionTitle: 'open app settings');
    }
  }

  _onCameraDenied(){
    Navigator.pop(context);
    AppSettings.openAppSettings();
  }

  _onCaptured(final String imagePath) async {
    this.profileImage = imagePath;
    this._profileBehavior.sink.add(imagePath);
  }

  bool skipTouch = false;

  _saveProfile() {
    if (!this.skipTouch) {
      this.skipTouch = true;
      Future.delayed(
        Duration(seconds: 1),
        () {
          final String _name = this._nameConfig.controller.text;
          final String _email = this._emailConfig.controller.text;
          final String _mobile = this._phoneConfig.controller.text;
          if (_name.isEmpty) {
            super.setError(this._nameConfig);
          } else if (_email.isEmpty) {
            super.setError(this._emailConfig);
          } else if (_mobile.isEmpty) {
            super.setError(this._phoneConfig);
          } else {
            final Map _arguments = Map.from(this.widget.arguments);
            _arguments['name'] = _name;
            _arguments['email'] = _email;
            _arguments['mobile'] = _mobile;
            _arguments['profile'] = profileImage;
            Navigator.pushNamed(context, AppRoutes.pageHealthData,
                arguments: _arguments);
          }
          this.skipTouch = false;
        },
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
    if (_profileBehavior != null && !_profileBehavior.isClosed) {
      _profileBehavior.close();
    }
  }

  Widget getImageWidget() {
    final _width = MediaQuery.of(context).size.width * 0.3;
    return Container(
      decoration: AppStyle.circularShadow(),
      child: ClipRRect(
        child: StreamBuilder<String>(
          stream: _profileBehavior.stream,
          initialData: this.profileImage,
          builder: (context, snapshot) {
            return snapshot.data == null
                ? Container(
                    width: _width,
                    height: _width,
                    child: new Material(
                      child: new InkWell(
                        onTap: _openCamera,
                        child: new Center(
                          child: Container(
                            height: 80,
                            width: 150,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
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
                : _getProfileImage(snapshot.data, _width);
          },
        ),
        borderRadius: BorderRadius.all(Radius.circular(_width)),
      ),
    );
  }

  @override
  onSubmitData() {
    super.onSubmitData();
    this._saveProfile();
  }

  @override
  String getAppBarTitle() {
    return 'Profile';
  }

  @override
  String getActionTitle() {
    return 'NEXT';
  }

  @override
  Widget getSingleChildContent() {
    return Container(
      height: super.getContentHeight(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 24, bottom: 24),
            child: Center(
              child: this.getImageWidget(),
            ),
          ),
          CustomPaint(
            size: Size(MediaQuery.of(context).size.width, 1.0),
            painter: DashLinePainter(),
          ),
          WidgetTemplate.getTextField(
            this._nameConfig,
            maxLen: 32,
            isReadOnly: false,
            showCursor: true,
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
          ),
          WidgetTemplate.getTextField(
            this._phoneConfig,
            maxLen: 15,
            isReadOnly: false,
            isDigit: true,
            showCursor: true,
          ),
        ],
      ),
    );
  }
}
