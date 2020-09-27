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
import 'package:plasma_bank/network/models/blood_collector.dart';
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
  final TextConfig _diseaseConfig = TextConfig('disease', animateLen: 350);
  final TextConfig _countConfig =
      TextConfig('blood bags count', isDigit: true, maxLen: 1);
  final TextConfig _hospitalConfig =
      TextConfig('hospital address', animateLen: 350, maxLen: 250);
  final TextConfig _bloodConfig = TextConfig('blood group');
  final TextConfig _dateConfig = TextConfig('date for blood');

  @override
  String getActionTitle() {
    // TODO: implement getActionTitle
    return 'REGISTER';
  }

  @override
  String getAppBarTitle() {
    // TODO: implement getAppBarTitle
    return 'BLOOD COLLECTION';
  }


  @override
  double getContentHeight() {
    // TODO: implement getContentHeight
    return 1650;
  }

  @override
  void dispose() {
    super.dispose();
    this._profileBehavior.close();
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

  @override
  Widget getBottomWidget() {
    // TODO: implement getBottomWidget
    return Column(
      children: <Widget>[
        SizedBox(height: 16,),
        WidgetTemplate.getSectionTitle('PERSONAL INFO', Icons.info_outline),
        Padding(
          padding: EdgeInsets.only(top: 24, bottom: 24),
          child: Center(
            child: this.getImageWidget(),
          ),
        ),
        CustomPaint(
          painter: DashLinePainter(),
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

        WidgetTemplate.getSectionTitle('REASONS', Icons.info_outline),
        SizedBox(
          height: 24,
        ),
        Text(
          'enter brief details about the disease for whom you are collecting the blood, so that donner may realise the relevancy of blood donation. ignore, if you are unwilling to disclose.',
          textAlign: TextAlign.justify,
        ),
        WidgetTemplate.getCustomTextField(
          this._diseaseConfig,
              () => super.onTextFieldTapped(this._diseaseConfig),
        ),
        SizedBox(
          height: 24,
        ),
        Text(
          'enter the hospital name or address, so that near by donner may contact you soon.',
          textAlign: TextAlign.justify,
        ),
        WidgetTemplate.getCustomTextField(
          this._hospitalConfig,
              () => super.onTextFieldTapped(this._hospitalConfig),
        ),
        SizedBox(
          height: 24,
        ),
        Text(
          'enter the number of total blood bags you need for the patient.',
          textAlign: TextAlign.justify,
        ),
        WidgetTemplate.getCustomTextField(
          this._countConfig,
              () => super.onTextFieldTapped(this._countConfig),
        ),

        SizedBox(
          height: 24,
        ),
        Text(
          'enter the approximate date when you need the blood.',
          textAlign: TextAlign.justify,
        ),
        WidgetTemplate.getTextField(
          this._dateConfig,
          isReadOnly: true,
          showCursor: false,
          onTap: () => this._showDatePicker(this._dateConfig),
        ),
        SizedBox(
          height: 24,
        ),
        Text(
          'you may specify the blood group, which you are looking for. it will help you find the blood more easily.',
          textAlign: TextAlign.justify,
        ),
        WidgetTemplate.getTextField(
          _bloodConfig,
          maxLen: 15,
          isReadOnly: true,
          onTap: () {
            List _data = ['A+', 'B+', 'AB+', 'O+', 'A-', 'B-', 'AB-', 'O-'];
            WidgetProvider.openLocationPopUp(
                context,
                _data,
                    (_data) => _bloodConfig.controller.text = _data.toString(),
                _onPopupClosed,
                'SELECT BLOOD GROUP');
          },
        ),
      ],
    );
  }



  _onPopupClosed() {}

  @override
  onAddressCompleted(Map _address) {
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
      final _emailClient = EmailClient(_email);
      _emailClient.validateEmail().then((value) {
        Navigator.pop(context);
        if(value){
          final String _disease = this._diseaseConfig.controller.text;
          final String _hospital = this._hospitalConfig.controller.text;
          final String _group = this._bloodConfig.controller.text;
          final String _bags = this._countConfig.controller.text;
          final String _date = this._dateConfig.controller.text;

          final Map _takerData = {
            'name' : _name,
            'mobile' : _mobile,
            'email' : _email,
            'blood_group' : _group,
            'address' : _address,
            'hospital_address' : _hospital,
            'injection_date' : _date,
            'bag_count' : _bags,

            'disease_name' : _disease,
          };

//          this.fullName = _map['name'];
//          this.mobileNumber = _map['mobile'];
//          this.bloodGroup = _map['blood_group'];
//          this.address = Address.fromMap(_map['address']);
//          this.emailAddress = _map['email'];
//          this.profilePicture = ImgurResponse(jsonData:  _map['profile']);
//          this.age = _map['age'];
//          this.birthDate = getDOB(_map['age']);
//          this.hasValidPostal = _map['is_valid_postal'] ?? false;
//          this.verificationCode = _map['code'];
//          this.hospitalAddress = _inputData['hospital_address'];
//          this.injectionDate = _inputData['injection_date'];
//          this.bloodCount = _inputData['bag_count'];
//          this.diseaseName = _inputData['disease_name'];
//



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
        } else {
          Navigator.pop(context);
          WidgetTemplate.message(context, 'this email is invalid. please! enter a valid email address and try again, later. thank you!');
        }
      }).catchError((_error){
        Navigator.pop(context);
      });


    }
  }



  _showDatePicker(TextConfig _controller) async {
    final _dateTime = await showDatePicker(
        context: context,
        initialDate:  DateTime.now(),
        lastDate: DateTime(DateTime.now().year+2),
        firstDate: DateTime.now());
    if (_dateTime != null) {
      String date = DateFormat("dd MMM, yyyy").format(_dateTime);
      _controller.controller.text = date;
//      _controller.timestamped = _dateTime;
    }
  }
}
