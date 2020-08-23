import 'dart:io';
import 'package:app_settings/app_settings.dart';
<<<<<<< HEAD
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:plasma_bank/app_utils/app_constants.dart';
import 'package:plasma_bank/app_utils/widget_templates.dart';
import 'package:plasma_bank/media/dash_painter.dart';
=======
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:plasma_bank/app_utils/app_constants.dart';
import 'package:plasma_bank/app_utils/widget_providers.dart';
import 'package:plasma_bank/app_utils/widget_templates.dart';
import 'package:plasma_bank/media/dash_painter.dart';
import 'package:plasma_bank/network/donor_handler.dart';
import 'package:plasma_bank/network/firebase_repositories.dart';
>>>>>>> 91d5bde7e182f349837b51c29c061962546dca35
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
<<<<<<< HEAD

  String profileImage;
  final BehaviorSubject<String> _profileBehavior = BehaviorSubject();

=======
  final String _message = 'This email has registered as Blood Donor! Please, Login and verify the account';
  String profileImage;
  final BehaviorSubject<String> _profileBehavior = BehaviorSubject();


>>>>>>> 91d5bde7e182f349837b51c29c061962546dca35
  @override
  void initState() {
    super.initState();
    this._nameConfig.controller.text = 'mostafizur rahman';
    this._emailConfig.controller.text = 'mostafizur.cse@gmail.com';
    this._phoneConfig.controller.text = '01675876752';
<<<<<<< HEAD
=======

>>>>>>> 91d5bde7e182f349837b51c29c061962546dca35
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
<<<<<<< HEAD
        () {
=======
        () async {
>>>>>>> 91d5bde7e182f349837b51c29c061962546dca35
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
<<<<<<< HEAD
            final Map _arguments = Map.from(this.widget.arguments);
            _arguments['name'] = _name;
            _arguments['email'] = _email;
            _arguments['mobile'] = _mobile;
            _arguments['profile'] = profileImage;
            Navigator.pushNamed(context, AppRoutes.pageHealthData,
                arguments: _arguments);
=======
            bool hasData = false;
            if(donorHandler.hasExistingAccount(_email)){
              this._onEmailExist(_email);
              hasData = true;
            }
            if(!hasData){
              WidgetProvider.loading(context);
              final _repository = FirebaseRepositories();
              if(await _repository.getDonorData(_email) == null){
                final Map _arguments = Map.from(this.widget.arguments);
                Navigator.pop(context);
                _arguments['name'] = _name;
                _arguments['email'] = _email;
                _arguments['mobile'] = _mobile;
                _arguments['profile'] = {'link' : profileImage, 'deletehash' : ''};
                Navigator.pop(context);
                Navigator.pushNamed(context, AppRoutes.pageHealthData,
                    arguments: _arguments);
              } else {
                Navigator.pop(context);
                this._onEmailExist(_email);
              }
            }
>>>>>>> 91d5bde7e182f349837b51c29c061962546dca35
          }
          this.skipTouch = false;
        },
      );
    }
  }

<<<<<<< HEAD
=======
  _onEmailExist(final String _email){

    WidgetTemplate.message(context,
        this._message,
        actionTitle: 'OPEN LOGIN',
        onActionTap: (){
        Navigator.popUntil(context, ModalRoute.withName(AppRoutes.pageRouteHome));
        Future.delayed(Duration(microseconds: 200), () async {
          donorHandler.donorLoginBehavior.sink.add(_email);
        });
    });
  }

>>>>>>> 91d5bde7e182f349837b51c29c061962546dca35
  @override
  void dispose() {
    super.dispose();
    if (_profileBehavior != null && !_profileBehavior.isClosed) {
      _profileBehavior.close();
    }
  }

  Widget getImageWidget() {
<<<<<<< HEAD
    final _width = MediaQuery.of(context).size.width * 0.3;
=======
    final _width = displayData.width * 0.3;
>>>>>>> 91d5bde7e182f349837b51c29c061962546dca35
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
<<<<<<< HEAD
            size: Size(MediaQuery.of(context).size.width, 1.0),
=======
            size: Size(displayData.width, 1.0),
>>>>>>> 91d5bde7e182f349837b51c29c061962546dca35
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
