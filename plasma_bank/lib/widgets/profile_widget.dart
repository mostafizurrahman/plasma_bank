import 'dart:io';
import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:plasma_bank/app_utils/app_constants.dart';
import 'package:plasma_bank/app_utils/widget_providers.dart';
import 'package:plasma_bank/app_utils/widget_templates.dart';
import 'package:plasma_bank/media/dash_painter.dart';
import 'package:plasma_bank/network/api_client.dart';
import 'package:plasma_bank/network/person_handler.dart';
import 'package:plasma_bank/network/firebase_repositories.dart';
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
  final TextConfig _emailConfig = TextConfig('email', );
  final TextConfig _phoneConfig = TextConfig('mobile #', isDigit: true, maxLen: 16);
  final String _message =
      'This email has registered as Blood Donor! Please, Login and verify the account';
  String profileImage;
  final BehaviorSubject<String> _profileBehavior = BehaviorSubject();

  @override
  void initState() {
    super.initState();
//    this._nameConfig.controller.text = 'mostafizur rahman';
//    this._emailConfig.controller.text = 'mostafizur.cse@gmail.com';
//    this._phoneConfig.controller.text = '01675876752';
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
    if (_status.isGranted || _status.isUndetermined) {
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
          actionIcon: Icon(
            Icons.settings,
            color: Colors.white,
          ),
          onActionTap: this._onCameraDenied,
          actionTitle: 'open app settings');
    }
  }

  _onCameraDenied() {
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
        () async {
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
            bool hasData = false;
            WidgetProvider.loading(context);
            final bool isDonor = await donorHandler.isEmailRegisteredAsDonor(_email);
            final bool isTaker = await donorHandler.isEmailRegisteredAsTaker(_email);
            if (isDonor || isTaker) {
              this._onEmailExist(_email);
              hasData = true;
            }
            final _emailClient = EmailClient(_email);
            final bool _hasValidEmail = await _emailClient.validateEmail().catchError((_error){
              return false;
            })??false;
            if(!_hasValidEmail){
              Navigator.pop(context);
              WidgetTemplate.message(context, 'this email is invalid. please! enter a valid email address and try again, later. thank you!');
              hasData = true;
            }
            if (!hasData) {
              final _repository = FirebaseRepositories();
              if (await _repository.getDonorData(_email) == null) {
                final Map _arguments = Map.from(this.widget.arguments);
                Navigator.pop(context);
                _arguments['name'] = _name;
                _arguments['email'] = _email;
                _arguments['mobile'] = _mobile;
                _arguments['profile'] = {
                  'link': profileImage,
                  'deletehash': ''
                };
                Navigator.pop(context);
                Navigator.pushNamed(context, AppRoutes.pageHealthData,
                    arguments: _arguments);
              } else {
                Navigator.pop(context);
                this._onEmailExist(_email);
              }
            } else {
              Navigator.pop(context);
            }
          }
          this.skipTouch = false;
        },
      );
    }
  }

  _onEmailExist(final String _email) {
    WidgetTemplate.message(context, this._message, actionTitle: 'OPEN LOGIN',
        onActionTap: () {
      Navigator.popUntil(context, ModalRoute.withName(AppRoutes.pageRouteHome));
      Future.delayed(Duration(microseconds: 200), () async {
        donorHandler.verificationEmail = _email;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    if (_profileBehavior != null && !_profileBehavior.isClosed) {
      _profileBehavior.close();
    }
  }

  Widget getImageWidget() {
    final _width = displayData.width * 0.3;
    return Container(
      decoration: AppStyle.circularShadow(),
      child: ClipRRect(
        child: StreamBuilder<String>(
          stream: _profileBehavior.stream,
          initialData: this.profileImage,
          builder: (context, snapshot) {
            return snapshot.data == null
                ? WidgetProvider.getInkButton(
                    _width, _width, _openCamera, Icons.person,
                    title: 'PICTURE', iconSize: 50)
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
            painter: DashLinePainter(),
          ),
//          WidgetTemplate.getTextField(
//            this._nameConfig,
//            maxLen: 32,
//            isReadOnly: false,
//            showCursor: true,
//          ),
          WidgetTemplate.getCustomTextField(
            this._nameConfig,
                () => super.onTextFieldTapped(this._nameConfig),
          ),

          WidgetTemplate.getCustomTextField(
            this._emailConfig,
                () => super.onTextFieldTapped(this._emailConfig),
          ),
          WidgetTemplate.getCustomTextField(
            this._phoneConfig,
                () => super.onTextFieldTapped(this._phoneConfig),
          ),

//          WidgetTemplate.getTextField(
//            this._emailConfig,
//            maxLen: 32,
//            isReadOnly: false,
//            showCursor: true,
//            validator: (String _value) {
//              if (_value == null || _value.isEmpty) {
//                return null;
//              }
//              bool emailValid = RegExp(
//                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
//                  .hasMatch(_value);
//              return emailValid ? null : 'enter valid email';
//            },
//          ),
//          WidgetTemplate.getTextField(
//            this._phoneConfig,
//            maxLen: 15,
//            isReadOnly: false,
//            isDigit: true,
//            showCursor: true,
//          ),
        ],
      ),
    );
  }
}
