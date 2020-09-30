import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:plasma_bank/app_utils/app_constants.dart';
import 'package:plasma_bank/app_utils/widget_providers.dart';
import 'package:plasma_bank/app_utils/widget_templates.dart';
import 'package:plasma_bank/media/dash_painter.dart';
import 'package:plasma_bank/network/api_client.dart';
import 'package:plasma_bank/network/firebase_repositories.dart';
import 'package:plasma_bank/network/imgur_handler.dart';
import 'package:plasma_bank/network/models/abstract_person.dart';
import 'package:plasma_bank/network/models/blood_collector.dart';
import 'package:plasma_bank/network/person_handler.dart';
import 'package:plasma_bank/widgets/base/base_address_state.dart';
import 'package:plasma_bank/widgets/base/base_state.dart';
import 'package:plasma_bank/widgets/base_widget.dart';
import 'package:rxdart/rxdart.dart';

class BloodCollectorWidget extends BaseWidget {
  BloodCollectorWidget(Map arguments) : super(arguments);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _CollectorState();
  }
}

class _CollectorState extends BaseAddressState<BloodCollectorWidget> {

  bool skipTouch = false;
  String profileImage;
  final BehaviorSubject<String> _profileBehavior = BehaviorSubject();

  final TextConfig _nameConfig = TextConfig('name');
  final TextConfig _emailConfig = TextConfig('email');
  final TextConfig _phoneConfig = TextConfig('mobile #', isDigit: true);
//  final TextConfig _addressConfig =
//      TextConfig('address', maxLine: 2, animateLen: 200);


  @override
  String getActionTitle() {
    return 'REGISTER';
  }

  @override
  String getAppBarTitle() {
    return 'COLLECTOR';
  }


  @override
  double getContentHeight() {
    return 930;
  }

  @override
  void dispose() {
    super.dispose();
    _profileBehavior.close();
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

  _onCaptured(final String imagePath) async {
    this.profileImage = imagePath;
    this._profileBehavior.sink.add(imagePath);
  }


  _openCamera() async {
    var _status = await Permission.camera.status;
    if (_status.isGranted || _status.isUndetermined) {
      this.skipTouch = true;
      final arguments = {
        'image_named': 'profile',
        'is_front_camera': true,
        'on_captured_function': _onCaptured,
        'route_name': AppRoutes.pageBloodTaker,
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

  @override
  Widget getTopWidget() {
    // TODO: implement getTopWidget
    return Column(
      children: <Widget>[
        WidgetTemplate.getSectionTitle('PERSONAL INFO', Icons.info_outline),
        Padding(
          padding: EdgeInsets.only(top: 12, bottom: 12),
          child: Center(
            child: this.getImageWidget(),
          ),
        ),

        WidgetTemplate.getCustomTextField(
          this._nameConfig,
              () => super.onTextFieldTapped(this._nameConfig),
        ),
        WidgetTemplate.getCustomTextField(
          this._phoneConfig,
              () => super.onTextFieldTapped(this._phoneConfig),
        ),
        WidgetTemplate.getCustomTextField(
          this._emailConfig,
              () => super.onTextFieldTapped(this._emailConfig),
        ),
      ],
    );
  }





  _onPopupClosed() {}

  @override
  onAddressCompleted(Map _address) async {
    // TODO: implement onAddressCompleted
    final String _name = this._nameConfig.controller.text;
    final String _email = this._emailConfig.controller.text;
    final String _mobile = this._phoneConfig.controller.text;
    if (_name.isEmpty) {
      super.setError(_nameConfig);
    } else if (_mobile.isEmpty) {
      super.setError(_phoneConfig);
    } else if (_email.isEmpty) {
      super.setError(_emailConfig);
    } else {
      WidgetProvider.loading(context);
      final bool isTaker = await donorHandler.isEmailRegisteredAsTaker(_email);
      final bool isDonor = !isTaker ? await donorHandler.isEmailRegisteredAsDonor(_email) : isTaker;
      if(isTaker || isDonor){
        Navigator.pop(context);
        WidgetTemplate.message(context, 'email is already registered, please! goto settings and login to post a blood collection request');
        return;
      }
      final _emailClient = EmailClient(_email);

      _emailClient.validateEmail().then((value) {
        if(value){

          final Map _takerData = {
            'name' : _name,
            'mobile' : _mobile,
            'email' : _email,
            'address' : _address,
          };
          if(this._profileBehavior.value != null){
            final String _image = ImgurHandler.getBase64(this._profileBehavior.value);
            final ImgurHandler _handler = ImgurHandler();
             _handler.uploadImage(_image).then((_response){
               _takerData['profile']  = _response.toJson();
               _uploadTakerData(_takerData);
            }).catchError((_error){
              Navigator.pop(context);
             });
          } else {
            _uploadTakerData(_takerData);
          }



//          final String _disease = this._diseaseConfig.controller.text;
//          final String _hospital = this._hospitalConfig.controller.text;
//          final String _group = this._bloodConfig.controller.text;
//          final String _bags = this._countConfig.controller.text;
//          final String _date = this._dateConfig.controller.text;




        } else {
          Navigator.pop(context);
          WidgetTemplate.message(context, 'this email is invalid. please! enter a valid email address and try again, later. thank you!');
        }
      }).catchError((_error){
        Navigator.pop(context);
      });
    }
  }

  _uploadTakerData(Map _takerData){
    final BloodCollector _collector = BloodCollector(_takerData);
    final FirebaseRepositories _repository = FirebaseRepositories();
    _repository.uploadBloodCollector(_collector).then((data) {
      Navigator.pop(context);
      WidgetTemplate.message(context,
          'your registration was successful! please! login to continue...',
          actionTitle: 'LOGIN', onActionTap: () {
            Navigator.pop(context);
            final Function _onTap = this.widget.getData('login_tap');
            _onTap();
          });
    }).catchError((_error) {
      Navigator.pop(context);
    });
  }



}
