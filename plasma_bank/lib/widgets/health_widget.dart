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
<<<<<<< HEAD
import 'package:plasma_bank/widgets/base_widget.dart';
import 'package:plasma_bank/widgets/stateful/data_picker_widget.dart';
=======
import 'package:plasma_bank/network/donor_handler.dart';
import 'package:plasma_bank/network/models/blood_donor.dart';
import 'package:plasma_bank/network/models/plasma_donor.dart';
import 'package:plasma_bank/widgets/base_widget.dart';
import 'package:plasma_bank/widgets/stateful/data_picker_widget.dart';
import 'package:plasma_bank/widgets/stateful/uploader_widget.dart';
>>>>>>> 91d5bde7e182f349837b51c29c061962546dca35
import 'package:rxdart/rxdart.dart';
import 'package:plasma_bank/widgets/base/base_state.dart';

class HealthWidget extends BaseWidget {
  HealthWidget(Map arguments) : super(arguments);

  @override
  State<StatefulWidget> createState() {
    return _HealthState();
  }
}

class _HealthState extends BaseKeyboardState<HealthWidget> {
  final String _disease =
      'People who might not be able to donate blood include those who:\n\n1. have used needles to take drugs, steroids, or other substances that a doctor has not prescribed  have engaged in sex for money or drugs' +
          "\n2. test positive for certain conditions, such as HIV or Creutzfeldt-Jakob disease (CJD)\n" +
          '3. have taken certain medications\n' +
          "4. are male and have had sexual contact with other males in the past 3 months\n";
  final String _covidInfo =
      'if you are infected by covid-19 then you may take plasma in critical infection status. and if you are recovered from covid-19 disease, then you may donate your plasma.';
  int languageGroupValue = 0, deviceRegGroupValue = 0;

  final BehaviorSubject<List<String>> _prescriptionBehavior = BehaviorSubject();
  DateTime _dateTime = new DateTime.now();
  final BehaviorSubject<int> _smokeBehavior = BehaviorSubject<int>();
  final BehaviorSubject<int> _drinkBehavior = BehaviorSubject<int>();
  final BehaviorSubject<int> _diseaseBehavior = BehaviorSubject<int>();
  final BehaviorSubject<int> _covidBehavior = BehaviorSubject<int>();

  bool skipTouch = false;
  String _imagePath;

  final TextConfig _weightConfig = TextConfig('body weight');
  final TextConfig _bloodConfig = TextConfig('blood group');
<<<<<<< HEAD
  final TextConfig _medicineConfig = TextConfig('remarks/disease');
=======
  final TextConfig _lastDonationConfig = TextConfig('last donation date');
>>>>>>> 91d5bde7e182f349837b51c29c061962546dca35
  final TextConfig _infectionConfig = TextConfig('infection date');
  final TextConfig _recoveryConfig = TextConfig('recovery date');
  final TextConfig _ageConfig = TextConfig('age');
  final TextConfig _heightConfig = TextConfig('height');
  TextConfig _selectedConfig;

  @override
  void dispose() {
    super.dispose();
    if (_smokeBehavior != null && !_smokeBehavior.isClosed) {
      _smokeBehavior.close();
    }
    if (_drinkBehavior != null && !_drinkBehavior.isClosed) {
      _drinkBehavior.close();
    }
    if (_diseaseBehavior != null && !_diseaseBehavior.isClosed) {
      _diseaseBehavior.close();
    }
    if (_covidBehavior != null && !_covidBehavior.isClosed) {
      _covidBehavior.close();
    }
    if (_prescriptionBehavior != null && !_prescriptionBehavior.isClosed) {
      _prescriptionBehavior.close();
    }
  }

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
=======
//    Navigator.pop(context);
>>>>>>> 91d5bde7e182f349837b51c29c061962546dca35
    return super.build(context);
  }

  Widget _getTitle(final String _title, final IconData _icon) {
    return Padding(
      padding: EdgeInsets.only(top: 48, bottom: 12),
      child: Row(
        children: [
          WidgetProvider.circledIcon(
            Icon(
              _icon,
              color: AppStyle.theme(),
            ),
          ),
          SizedBox(
            width: 12,
          ),
          Text(
            _title,
            style: TextStyle(
              fontSize: 24,
              fontFamily: AppStyle.fontBold,
            ),
          ),
        ],
      ),
    );
  }

<<<<<<< HEAD
  Widget _getPButton(String _data, final _width, final ratio ){
=======
  Widget _getPButton(String _data, final _width, final ratio) {
>>>>>>> 91d5bde7e182f349837b51c29c061962546dca35
    return Container(
      decoration: AppStyle.shadowDecoration,
      width: _width * ratio,
      height: _width * ratio * 16 / 9,
      child: new Material(
        child: new InkWell(
          onTap: () => _openCamera(_data),
          child: new Center(
            child: Container(
              height: 80,
              width: 150,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.description,
                    size: 50,
                  ),
                  Text('IMAGE')
                ],
              ),
            ),
          ),
        ),
        color: Colors.transparent,
      ),
    );
  }

  Widget _getPrescription(final List<String> data, final _width, final ratio) {
    final _widget1 = this._getPButton(data[0], _width, ratio);
    final _widget2 = this._getPButton(data[1], _width, ratio);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        data[0] == 'p1'
            ? _widget1
            : _getPrescriptionImage(data[0], _width * ratio),
<<<<<<< HEAD
        SizedBox(width: 8,),
=======
        SizedBox(
          width: 8,
        ),
>>>>>>> 91d5bde7e182f349837b51c29c061962546dca35
        data[1] == 'p2'
            ? _widget2
            : _getPrescriptionImage(data[1], _width * ratio),
      ],
    );
  }

  Widget _getPrescriptionImage(
      final String _imagePath, final double _dimension) {
    final _imageWidget = Image.file(
      File(_imagePath),
      fit: BoxFit.fitWidth,
    );
    _imageWidget.image.evict();
    return Container(
      decoration: AppStyle.shadowDecoration,
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(16)),
        child: Container(
          width: _dimension,
          height: _dimension * 16 / 9.0,
          child: new Material(
            child: new InkWell(
              onTap: () => _openCamera(_imagePath),
              child: _imageWidget,
            ),
            color: Colors.transparent,
          ),
        ),
      ),
    );
  }

<<<<<<< HEAD
  _onCameraDenied(){
=======
  _onCameraDenied() {
>>>>>>> 91d5bde7e182f349837b51c29c061962546dca35
    AppSettings.openAppSettings();
  }

  _openCamera(String _path) async {
    var status = await Permission.camera.status;
    if (status.isDenied) {
      WidgetTemplate.message(context,
          'camera permission is denied. please, go to app settings and grant the camera permission',
<<<<<<< HEAD
          onTapped: this._onCameraDenied,
          actionTitle: 'open app settings');
=======
          onTapped: this._onCameraDenied, actionTitle: 'open app settings');
>>>>>>> 91d5bde7e182f349837b51c29c061962546dca35
    } else if (!this.skipTouch) {
      this._imagePath = _path;
      this.skipTouch = true;

      final arguments = {
<<<<<<< HEAD
        'image_named' : _path.contains("/") ? _path.split('/').last : _path,
=======
        'image_named': _path.contains("/") ? _path.split('/').last : _path,
>>>>>>> 91d5bde7e182f349837b51c29c061962546dca35
        'is_front_camera': false,
        'on_captured_function': _onCaptured,
        'route_name': AppRoutes.pageHealthData,
      };
<<<<<<< HEAD
      Navigator.pushNamed(context, AppRoutes.pageRouteCamera,
          arguments: arguments);
      Future.delayed(Duration(seconds: 1), () {
        this.skipTouch = false;
      },);
=======
      Navigator.pushNamed(context,
          AppRoutes.pageRouteCamera,
          arguments: arguments);
      Future.delayed(
        Duration(seconds: 1), (){
          this.skipTouch = false;
        },
      );
>>>>>>> 91d5bde7e182f349837b51c29c061962546dca35
    }
  }

  _onCaptured(final String _imagePath) {
<<<<<<< HEAD
    if (_imagePath != null){
=======
    if (_imagePath != null) {
>>>>>>> 91d5bde7e182f349837b51c29c061962546dca35
      final _list = List.from(this._prescriptionBehavior.value ?? ['p1', 'p2']);
      if (_list[0] == 'p1' || _list[0] == this._imagePath) {
        this._prescriptionBehavior.sink.add([_imagePath, _list[1]]);
      } else if (_list[1] == 'p2' || _list[1] == this._imagePath) {
        this._prescriptionBehavior.sink.add([_list[0], _imagePath]);
      }
    }
  }

<<<<<<< HEAD
  _createDonor() {}
=======
  _createDonor() {
    final _bloodGroup = this._bloodConfig.controller.text;
    final _age = this._ageConfig.controller.text;
    final _weight = this._weightConfig.controller.text;
    final _height = this._heightConfig.controller.text;
    if (_bloodGroup.isEmpty) {
      super.setError(this._bloodConfig);
    } else if (_age.isEmpty) {
      super.setError(this._ageConfig);
    } else if (_weight.isEmpty) {
      super.setError(this._weightConfig);
    } else if (_height.isEmpty) {
      super.setError(this._heightConfig);
    } else {
      final _donorData = Map.from(this.widget.arguments);
      final _donate = this._lastDonationConfig.controller.text;
      final _drinking = (this._drinkBehavior.value ?? 0) == 1;
      final _smoking = (this._smokeBehavior.value ?? 0) == 1;
      final _disease = (this._diseaseBehavior.value ?? 0) == 1;
      final _isCovid = (this._covidBehavior.value ?? 0) == 1;

      _donorData['package'] = deviceInfo.appBundleID;
      _donorData['devices'] = [deviceInfo.deviceUUID];
      _donorData['blood_group'] = _bloodGroup;
      _donorData['covid'] = _isCovid;
      _donorData['smoke'] = _smoking;
      _donorData['drink'] = _drinking;
      _donorData['sick'] = _disease;
      _donorData['donation_date'] = this._lastDonationConfig.controller.text;
      _donorData['code'] = '123445';

      List<Map> _dataList = List();
      for(final String url in this._prescriptionBehavior.value ?? ['p1', 'p2']){
        Map _data = {'link' : url, 'deletehash' : ''};
        _dataList.add(_data);
      }
      _donorData['prescriptions'] = _dataList;
      _donorData['age'] = _age;
      _donorData['donation_date'] = _donate;
      _donorData['weight'] = _weight;
      _donorData['height'] = _height;

      /*
      this.weight = map['weight'];
    this.hasSickness = map['sick'];
    this.diseaseName = map['disease'];
    this.hasSmokeHabit = map['smoke'];
    this.hasDrinkHabit = map['drink'];




    this.medicineList = map['medicines'];
    this.prescriptionList = map['prescriptions'];
    this.lastDonationDate = map['donation_date'] == null ? null : (map['donation_date'] as Timestamp).toDate();
      */


      if (_isCovid) {
        final _infectionDate = this._infectionConfig.controller.text;
        final _infectionEnd = this._recoveryConfig.controller.text;
        if (_infectionDate.isEmpty) {
          FocusScope.of(context).requestFocus(this._infectionConfig.focusNode);
        } else {
          _donorData['covid_date'] = _infectionDate;
          _donorData['recovered_date'] = _infectionEnd;
        }
        final _donor = PlasmaDonor.fromMap(_donorData);
        debugPrint('done');
        _openDataUploader(_donor);
      } else{
        final _bloodDonor = BloodDonor.fromMap(_donorData);
        debugPrint('done');
        _openDataUploader(_bloodDonor);
      }
    }
  }

  _openDataUploader(final BloodDonor donor){
    showDialog(context: this.context, builder: (_)=>UploaderWidget(donor, donorHandler.donorEmails, onCompleted));
  }


  onCompleted(final bool _isSuccess){
    if(_isSuccess){
      Navigator.popUntil(
          context,
          ModalRoute.withName( AppRoutes.pageRouteHome));
    } else {
      WidgetTemplate.message(context, 'network error occurred! we are unable to create this account right now, please try again.\nthank your!');
    }
  }

>>>>>>> 91d5bde7e182f349837b51c29c061962546dca35

  _getTextField(
    TextConfig _config, {
    isDigit = true,
    isReadOnly = true,
  }) {
    return WidgetTemplate.getTextField(
      _config,
      maxLen: 15,
      isReadOnly: isReadOnly,
      isDigit: isDigit,
      showCursor: true,
      onTap: () {
        this._selectedConfig = _config;
        bool isHeight = _config.labelText == 'height';
        if (_config.labelText == 'body weight' ||
            _config.labelText == 'age' ||
            isHeight) {
          List<List<int>> _data = List();
          bool _isAge = _config.labelText == 'age';
          int _count = isHeight ? 140 : _isAge ? 17 : 40;
          for (int i = 0; i < 20 + (isHeight ? 5 : 0); i++) {
            List<int> _array = List();
            for (int j = 0; j < 4; j++) {
              _array.add(_count);
              _count++;
            }
            _data.add(_array);
          }
          this._openPopUp(
              _data,
              _onSelected,
              _onClosed,
              isHeight
                  ? 'SELECT HEIGHT'
                  : _isAge ? 'SELECT AGE' : 'SELECT WEIGHT',
              unit: isHeight ? 'cm' : _isAge ? 'yr' : 'kg');
        } else if (_config.labelText == 'blood group') {
          List _data = ['A+', 'B+', 'AB+', 'O+', 'A-', 'B-', 'AB-', 'O-'];
          this._openPopUp(_data, _onSelected, _onClosed, 'SELECT BLOOD GROUP');
        }
      },
    );
  }

  _onSelected(final _data) {
    if (_data == null) {
      this._selectedConfig.controller.text = '';
    } else if (this._selectedConfig.labelText == 'body weight') {
      this._selectedConfig.controller.text = _data.toString() + ' KG';
    } else if (this._selectedConfig.labelText == 'blood group') {
      this._selectedConfig.controller.text = _data.toString();
    } else if (this._selectedConfig.labelText == 'age') {
      this._selectedConfig.controller.text = _data.toString() + ' year';
    } else if (this._selectedConfig.labelText == 'height') {
      this._selectedConfig.controller.text = _data.toString() + ' cm';
    }
  }

  _onClosed() {}

  _openPopUp(final _data, final _selected, final _closed, final _title,
      {String unit = ''}) {
    Future.delayed(
      Duration(
        milliseconds: 100,
      ),
      () {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => Material(
            color: Colors.transparent,
            type: MaterialType.card,
            child: WillPopScope(
              onWillPop: () async {
                return Future<bool>.value(false);
              },
              child: DataPickerWidget(
                _data,
                _selected,
                _closed,
                picketTitle: _title,
                unit: unit,
              ),
            ),
          ),
        );
      },
    );
  }

<<<<<<< HEAD
  _showDatePicker(TextEditingController _controller) async {
=======
  _showDatePicker(TextConfig _controller) async {
>>>>>>> 91d5bde7e182f349837b51c29c061962546dca35
    _dateTime = await showDatePicker(
        context: context,
        initialDate: _dateTime ?? DateTime.now(),
        lastDate: DateTime.now(),
        firstDate: DateTime(1920));
    if (_dateTime != null) {
      String date = DateFormat("dd MMM, yyyy").format(_dateTime);
<<<<<<< HEAD
      _controller.text = date;
=======
      _controller.controller.text = date;
//      _controller.timestamped = _dateTime;
>>>>>>> 91d5bde7e182f349837b51c29c061962546dca35
    }
  }

  @override
  String getActionTitle() {
    return 'CREATE DONOR';
  }

  @override
  String getAppBarTitle() {
    return 'Health';
  }

  @override
  onSubmitData() {
    super.onSubmitData();
    this._createDonor();
  }

  @override
  Widget getSingleChildContent() {
<<<<<<< HEAD
    final _width = MediaQuery.of(context).size.width;
    return Container(
      width: _width,
=======

    return Container(
      width: displayData.width,
>>>>>>> 91d5bde7e182f349837b51c29c061962546dca35
      height: 1310,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          this._getTitle('PHYSICAL INFO', Icons.person),
          CustomPaint(
            size: Size(MediaQuery.of(context).size.width, 1.0),
            painter: DashLinePainter(),
          ),
          Row(
            children: [
              Container(
<<<<<<< HEAD
                width: (_width - 48) / 2 - 8,
=======
                width: (displayData.width - 48) / 2 - 8,
>>>>>>> 91d5bde7e182f349837b51c29c061962546dca35
                child: this._getTextField(this._bloodConfig),
              ),
              SizedBox(
                width: 16,
              ),
              Container(
<<<<<<< HEAD
                width: (_width - 48) / 2 - 8,
=======
                width: (displayData.width - 48) / 2 - 8,
>>>>>>> 91d5bde7e182f349837b51c29c061962546dca35
                child: this._getTextField(this._ageConfig),
              ),
            ],
          ),
          Row(
            children: [
              Container(
<<<<<<< HEAD
                width: (_width - 48) / 2 - 8,
=======
                width: (displayData.width - 48) / 2 - 8,
>>>>>>> 91d5bde7e182f349837b51c29c061962546dca35
                child: this._getTextField(this._weightConfig),
              ),
              SizedBox(
                width: 16,
              ),
              Container(
<<<<<<< HEAD
                width: (_width - 48) / 2 - 8,
=======
                width: (displayData.width - 48) / 2 - 8,
>>>>>>> 91d5bde7e182f349837b51c29c061962546dca35
                child: this._getTextField(this._heightConfig),
              ),
            ],
          ),
<<<<<<< HEAD
          this._getTextField(this._medicineConfig,
              isReadOnly: false, isDigit: false),
=======
          WidgetTemplate.getTextField(
            this._lastDonationConfig,
            isReadOnly: true,
            showCursor: false,
            onTap: () => this._showDatePicker(this._lastDonationConfig),
          ),
>>>>>>> 91d5bde7e182f349837b51c29c061962546dca35
          this._getTitle('BEHAVIOR INFO', Icons.accessibility),
          CustomPaint(
            size: Size(MediaQuery.of(context).size.width, 1.0),
            painter: DashLinePainter(),
          ),
          SizedBox(
            height: 16,
          ),
          WidgetTemplate.gateRadio(
<<<<<<< HEAD
            context,
=======
>>>>>>> 91d5bde7e182f349837b51c29c061962546dca35
            this._drinkBehavior,
            'DRINKING',
          ),
          WidgetTemplate.gateRadio(
<<<<<<< HEAD
            context,
=======
>>>>>>> 91d5bde7e182f349837b51c29c061962546dca35
            this._smokeBehavior,
            'SMOKING',
          ),
          WidgetTemplate.gateRadio(
<<<<<<< HEAD
            context,
=======
>>>>>>> 91d5bde7e182f349837b51c29c061962546dca35
            this._diseaseBehavior,
            'DISEASE',
            button: IconButton(
              color: Colors.amber,
              icon: Icon(
                Icons.error,
              ),
<<<<<<< HEAD
              onPressed: () {
                WidgetTemplate.message(context, _disease);
              },
=======
              onPressed: () => WidgetTemplate.message(context, _disease),
>>>>>>> 91d5bde7e182f349837b51c29c061962546dca35
            ),
          ),
          this._getTitle('COVID-19 INFO', Icons.brightness_high),
          CustomPaint(
            size: Size(MediaQuery.of(context).size.width, 1.0),
            painter: DashLinePainter(),
          ),
          WidgetTemplate.gateRadio(
<<<<<<< HEAD
            context,
=======
>>>>>>> 91d5bde7e182f349837b51c29c061962546dca35
            this._covidBehavior,
            'COVID-19 :',
            button: IconButton(
              color: Colors.amber,
              icon: Icon(
                Icons.error,
              ),
<<<<<<< HEAD
              onPressed: () {
                WidgetTemplate.message(context, _covidInfo);
              },
=======
              onPressed: () => WidgetTemplate.message(context, _covidInfo),
>>>>>>> 91d5bde7e182f349837b51c29c061962546dca35
            ),
          ),
          StreamBuilder(
            initialData: 0,
            stream: this._covidBehavior.stream,
            builder: (_context, _snap) {
              if (_snap.data == 0) {
                return SizedBox();
              }
              return Container(
<<<<<<< HEAD
                width: _width - 48,
=======
                width: displayData.width - 48,
>>>>>>> 91d5bde7e182f349837b51c29c061962546dca35
                child: Column(
                  children: [
                    WidgetTemplate.getTextField(
                      this._infectionConfig,
                      isReadOnly: true,
                      showCursor: false,
<<<<<<< HEAD
                      onTap: () {
                        this._showDatePicker(
                            this._infectionConfig.controller);
                      },
=======
                      onTap: () => this._showDatePicker(this._infectionConfig),
>>>>>>> 91d5bde7e182f349837b51c29c061962546dca35
                    ),
                    WidgetTemplate.getTextField(
                      this._recoveryConfig,
                      isReadOnly: true,
                      showCursor: false,
<<<<<<< HEAD
                      onTap: () {
                        this._showDatePicker(
                            this._recoveryConfig.controller);
                      },
=======
                      onTap: () => this._showDatePicker(this._recoveryConfig),
>>>>>>> 91d5bde7e182f349837b51c29c061962546dca35
                    ),
                  ],
                ),
              );
            },
          ),
          this._getTitle('PRESCRIPTION', Icons.description),
          CustomPaint(
            size: Size(MediaQuery.of(context).size.width, 1.0),
            painter: DashLinePainter(),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 48, bottom: 48),
            child: StreamBuilder<List<String>>(
              stream: _prescriptionBehavior.stream,
              initialData: ['p1', 'p2'],
              builder: (context, snapshot) {
<<<<<<< HEAD
                return _getPrescription(snapshot.data, _width, 0.325);
=======
                return _getPrescription(snapshot.data, displayData.width, 0.325);
>>>>>>> 91d5bde7e182f349837b51c29c061962546dca35
              },
            ),
          ),
        ],
      ),
    );
  }
}
